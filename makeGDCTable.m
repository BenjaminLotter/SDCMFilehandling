function [intensityTable, metaTable] = makeGDCTable(sampleSheetPath, dataPath, workflow,bDebug) 
%%%
% Generate data- and metadata table from GDC download.
%
% Inputs:
% sampleSheetPath - full path to the sample sheet
% dataPath        - full path to the downloaded GDC data
% workflow        - Gene sequencing workflow used. 
% bDebug          - bool value that sets debug output. Default value: True.
%
% Outputs:
% intensityTable  - GeneID (rows) x (SampleID (columns)+1) table of the gene intensity data 
% metaTable       - metadata to the output if provided in the files
% 
% Comments:
% * Currently only one workflow can be selected at once.
% * workflowConfig has to be updated for new workflows
%%%
  if ~exist('bDebug','var')
    bDebug = true;
  end
  
  workflowConfig = defaultWorkflowConfig();
  
  sampleSheet = readtable(sampleSheetPath,...
                          'ReadVariableNames', true,...
                          'PreserveVariableNames', true,...
                          'FileType','text',...
                          'HeaderLines', 0); 
  workflowMatchArray = ~cellfun(@isempty,regexp(sampleSheet.("File Name"), workflowConfig.workflows.(workflow).regexp));
  
  numMatches = sum(workflowMatchArray);
  if numMatches ==0
    intensityTable = NaN;
    metaTable = NaN;
    warning('No matches were found for workflow "%s" in directory "%s"', workflow, getAbsPath(dataPath));
  else
    workflowMatchSheet = sampleSheet(workflowMatchArray,:);

    numFilesLoaded = 0;
    for i = 1:height(workflowMatchSheet)
      rowInfo = workflowMatchSheet(i,:);
      filePath = fullfile(dataPath, rowInfo.("File ID"){1}, rowInfo.("File Name"){1});
      if exist(filePath,'file')
        numFilesLoaded = numFilesLoaded+1;
      end
      if contains(filePath, ".gz")
        zippedPath = erase(filePath, ".gz");
        if ~isfile(zippedPath)
          gunzip(filePath, fullfile(dataPath, rowInfo.("File ID")));
        end
        readPath = zippedPath;
      else
        readPath = filePath;
      end  

      %indexcol = workflowConfig.workflows.(workflow).indexcol;
      countcol = workflowConfig.workflows.(workflow).countcol;
      headerLines = workflowConfig.workflows.(workflow).headerLines;

      newRowData = readtable(readPath,...
                            'HeaderLines',headerLines,...
                            'FileType', 'text',...
                             'ReadRowNames', true);
      newRowData = newRowData(:,countcol-1);
      newRowData.Properties.VariableNames = rowInfo.("Sample ID")(1);

      if ~exist('oldRowData','var')
        oldRowData = newRowData;
      else
        oldRowData = join(oldRowData, newRowData, 'Keys','Row');
      end
    end
    if numFilesLoaded < 0.75*numMatches
      warning("Only %.3f % of matched files were found in %s. Maybe check data consistency.", numFilesLoaded/numMatches, dataPath)
    end
    if bDebug
      fprintf("Used samplesheet %s\n", getAbsPath(sampleSheetPath))
      fprintf("Loaded files from %s\n", getAbsPath(dataPath))
      fprintf("Number of files matched in samplesheet: %u\n", numMatches)
      fprintf("Number of files loaded from datapath: %u\n", numFilesLoaded)
      fprintf("%.2f%% of matched files were loaded.\n", 100*numFilesLoaded/numMatches)
    end
    if ~isnan(workflowConfig.workflows.(workflow).metaLines)
      bIsMetaLine = startsWith(oldRowData.Properties.RowNames, workflowConfig.workflows.(workflow).metaLines);
      intensityTable = oldRowData(~bIsMetaLine,:);
      metaTable = oldRowData(bIsMetaLine,:);
    else
      intensityTable = oldRowData;
      metaTable = NaN;
    end
  end
end
