function workflowConfig = defaultWorkflowConfig()
%%%
% Returns the default method config for GDC data files
%
% Input: 
% None
%
% Output:
% workflowConfig - workflow Config struct
%
% Comments:
% * see workflowConfig.explanations for details
%%%
  workflowConfig = struct;
  workflowConfig.workflows.htseq.regexp = "htseq";
  workflowConfig.workflows.htseq.indexcol = 1;
  workflowConfig.workflows.htseq.countcol = 2;
  workflowConfig.workflows.htseq.headerLines = 0;
  workflowConfig.workflows.htseq.metaLines = '__';
  
  workflowConfig.workflows.FPKM.regexp = 'FPKM(?!-)';
  workflowConfig.workflows.FPKM.indexcol = 1;
  workflowConfig.workflows.FPKM.countcol = 2;
  workflowConfig.workflows.FPKM.headerLines = 0;
  workflowConfig.workflows.FPKM.metaLines = NaN;
  
  workflowConfig.workflows.FPKMUQ.regexp = "FPKM-UQ";
  workflowConfig.workflows.FPKMUQ.indexcol = 1;
  workflowConfig.workflows.FPKMUQ.countcol = 2;
  workflowConfig.workflows.FPKMUQ.headerLines = 0;
  workflowConfig.workflows.FPKMUQ.metaLines = NaN;
  
  workflowConfig.workflows.mirnas.regexp = "mirnas";
  workflowConfig.workflows.mirnas.indexcol = 1;
  workflowConfig.workflows.mirnas.countcol = 2;
  workflowConfig.workflows.mirnas.headerLines = 1;
  workflowConfig.workflows.mirnas.metaLines = NaN;
  
  workflowConfig.workflows.isoforms.regexp = "isoforms";
  workflowConfig.workflows.isoforms.indexcol = 2;
  workflowConfig.workflows.isoforms.countcol = 3;
  workflowConfig.workflows.isoforms.headerLines = 1;
  workflowConfig.workflows.isoforms.metaLines = NaN; 
  
  workflowConfig.workflows.star.regexp = "star";
  workflowConfig.workflows.star.indexcol = 1;
  workflowConfig.workflows.star.countcol = 2;
  workflowConfig.workflows.star.headerLines = 1;
  workflowConfig.workflows.star.metaLines = '_'; 
  
  workflowConfig.explanations.workflows.regexp = "Regexp string that is uniquely matched against the filenames provided by the samplesheet";
  workflowConfig.explanations.workflows.indexcol = "column number that sets the table row-index (gene descriptors). Currently not used.";
  workflowConfig.explanations.workflows.countcol = "column number that sets the table data column";
  workflowConfig.explanations.workflows.headerLines = "number of lines on top to be skipped";
  workflowConfig.explanations.workflows.metaLines = "substring that denotes metadata in the files";
end
