function [intensities, rowIDs, colIDs] = splitTable(table)
%%%
% Returns the content, rownames and columnames of a table
%
% Input:
% table - matlab table
% 
% Output:
% intensities - content of table
% rowIDs      - row names of table
% colIDs      - column names of table
%
% Comments:
% * might introduce functionalty for tables without rowIDs or columnIDs later
%%%
  intensities = table{:,:};
  rowIDs = table.Properties.RowNames;
  colIDs = table.Properties.VariableNames;
end
