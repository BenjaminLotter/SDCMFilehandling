function downloadGDC(manifest, downloadPath)
  currDir=pwd;
  cd(downloadPath)
  command = "gdc-client download -m" + manifest;
  system(command)
  cd(currDir)
end
