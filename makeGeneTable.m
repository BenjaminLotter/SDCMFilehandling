function [intensityTable, metaTable] = makeGeneTable(sampleSheetPath, dataPath, method) 
%%%
% Generate data- and metadata table from GDC download.
%
% Inputs:
% sampleSheetPath - full path to the sample sheet
% dataPath        - full path to the downloaded GDC data
% method          - Gene sequencing method used. 
%
% Outputs:
% intensityTable  - GeneID (rows) x SampleID (columns) table of the gene intensity data 
% metaTable       - metadata to the output if provided in the files
% 
% Comments:
% * Currently only one method can be selected at once.
% * methodConfig has to be updated for new methods
%%%
  methodConfig = struct;
  methodConfig.methods.htseq.methodString = "htseq";
  methodConfig.methods.htseq.indexcol = 1;
  methodConfig.methods.htseq.countcol = 2;
  methodConfig.methods.htseq.headerLines = 0;
  methodConfig.methods.htseq.metaLines = '__';
  
  methodConfig.methods.mirnas.methodString = "mirnas";
  methodConfig.methods.mirnas.indexcol = 1;
  methodConfig.methods.mirnas.countcol = 2;
  methodConfig.methods.mirnas.headerLines = 1;
  methodConfig.methods.mirnas.metaLines = NaN;  
  
  methodConfig.explanations.methods.methodString = "String that is matched against the filnames provided by the samplesheet";
  methodConfig.explanations.methods.indexcol = "column number that sets the table row-index (gene descriptors)";
  methodConfig.explanations.methods.countcol = "column number that sets the table data column";
  methodConfig.explanations.methods.headerLines = "number of lines on top to be skipped";
  methodConfig.explanations.methods.metaLines = "substring that denotes metadata in the files";
  
  sampleSheet = readtable(sampleSheetPath,'FileType','text', 'HeaderLines', 0 ); 
  methodMatch = sampleSheet(contains(sampleSheet.FileName, methodConfig.methods.(method).methodString),:);
  
  for i = 1:height(methodMatch)
    rowInfo = methodMatch(i,:);
    filePath = fullfile(dataPath, rowInfo.FileID, rowInfo.FileName);

    if contains(filePath, ".gz")
      zippedPath = erase(filePath, ".gz");
      if ~isfile(zippedPath)
        gunzip(filePath, fullfile(dataPath, rowInfo.FileID));
      end
      readPath = zippedPath;
    else
      readPath = filePath;
    end  

    indexcol = methodConfig.methods.(method).indexcol;
    countcol = methodConfig.methods.(method).countcol;
    headerLines = methodConfig.methods.(method).headerLines;

    newRowData = readtable(readPath, 'HeaderLines', headerLines, 'FileType', 'text');
    newRowData = newRowData(:,[indexcol, countcol]);
    newRowData.Properties.VariableNames = {'GeneID', rowInfo.SampleID{1}};

    if ~exist('oldRowData','var')
      oldRowData = newRowData;
    else
      oldRowData = join(oldRowData, newRowData);
    end

  end
  if ~isnan(methodConfig.methods.(method).metaLines)
    bIsMetaLine = startsWith(oldRowData.GeneID, methodConfig.methods.(method).metaLines);
    intensityTable = oldRowData(~bIsMetaLine,:);
    metaTable = oldRowData(bIsMetaLine,:);
  else
    intensityTable = oldRowData;
    metaTable = NaN;
  end
end
