function [subDownloadPath, retValue] = downloadGDC(manifest, downloadPath, descriptor)
%%%
% Takes a GDC-manifest path string, a download path string and a descriptor string to download GDC-files via the gdc-client. 
% gdc-client must be installed and accessible by Matlab (see https://gdc.cancer.gov/access-data/gdc-data-transfer-tool (Accessed 2020-2-18, 11:14))
%
% Input:
% manifest      - full or relative path to manifest file
% downloadPath  - full or relative path to download direcotry
% descriptor    - string that is added into the download directory
%
% Output:
% subDownloadPath - path string where files are downloaded
% retValue        - return value of gdc-client system call
%
% Comments
% * gdc-client is not fully reliable. Some files might be missing due to download/database errors.
%   Always check consistency of downloads. Alternatively download files by hand or with other tools.
%%%
  fullManifestPath = getAbsPath(manifest);
  fullDownloadPath = getAbsPath(downloadPath);
  dirName = descriptor+"_"+datestr(now,'yyyy-mm-dd_HH:MM:SS.FFF');
  subDownloadPath = fullfile(fullDownloadPath, dirName);
  if ~exist(subDownloadPath, 'dir')
    mkdir(subDownloadPath);
  end
  currDir=pwd;
  cd(subDownloadPath)
  command = "gdc-client download -m" + fullManifestPath;
  retValue = system(command);
  cd(currDir)
end
