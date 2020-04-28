function outInfo = runSDCM(inputTable, rootDir, additionalSDCMConfig)
%%%
% Starts an SDCM session with a previously generated data table
% 
% Input:
% inputTable            - table with rowIDs and colIDs
% rootDir               - String where output is saved
% additionalSDCMConfig  - optional parameters for the SDCM config
%
% Output:
% outInfo - default SDCM output
% 
% Comments:
% * this serves as an expemplatory function demonstrating the execution of SDCM. 
%   For more personalized options it's recommended to adapt this code for your own
%   purposes.
% * To speed up calculation time you should enable parpool either via Matlab GUI or 
%   in your code
%%%
  % Load table
  [intensities, rowIDs, colIDs] = splitTable(inputTable);
  inputSize = size(intensities);
  
  % Set up configutation
  rootDir = getAbsPath(rootDir);
  configuration = SDCM_defaultConfig(inputSize);
  if (exist('additionalSDCMConfig', 'var'))
    [configuration, ~] = mergeStructs(configuration, additionalSDCMConfig);
  end
  configuration.export.rootDir = char(rootDir);
  configuration.reference.colIDs = colIDs;
  configuration.reference.rowIDs = rowIDs;

  % Make Log2 ratios from intensities
  L2Is=log2(intensities+1);
  medians = median(L2Is,2);
  L2Rs = L2Is - medians;
  
  % Run SDCM
  outInfo = SDCM(L2Rs, configuration);
end
