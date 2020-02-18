function absPath = getAbsPath(path)
%%%
% Returns the absolute path of a relative path
%
% Input:
% path - relative path to file or directory
%
% Output:
% absPath - absolutePath to file or directory
%
% Comments:
% * the base of the path must exist in the filesystem. E.g in ../A/B.txt, 'A' must exist in the filesystem. 
%%%
  [filepath,name,ext] = fileparts(path); 
  if isempty(filepath)
    filepath = '.';
  end
  curDir = pwd();
  cd(filepath);
  absPath = fullfile(pwd(), string(name)+string(ext));
  cd(curDir)
end
