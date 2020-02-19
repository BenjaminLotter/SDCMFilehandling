# SDCMFilehandling
*Filehandling tools to parse GDC transcriptome data into SDCM*

This is a small collection of methods that automates the input of [GDC transcriptome data ](https://gdc.cancer.gov/) 
into the [Matlab SDCM implementation by Michael Grau](https://github.com/GrauLab/SDCM).

#### Main files:
* downloadGDC.m: Downloads data from GDC using a manifest. Needs [gdc-client](https://gdc.cancer.gov/access-data/gdc-data-transfer-tool) to run. Alternatively the files can be downloaded by hand or some other tool.
* makeGDCTable.m: Parses the downloaded files into Matlab tables for data and metadata
* runSDCM.m: Exemplatory implementation of an SDCM call

#### Helper Files:
* defaultWorkflowConfig.m: Sets up the default settings for parsing GDC transcriptome data
* getAbsPath.m: Returns the absolute path from a relative path
* splitTable.m: Splits a table into data, row IDs and column IDs
