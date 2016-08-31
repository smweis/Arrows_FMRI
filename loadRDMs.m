

currDir = pwd;
%%%Change file names and variable names!!


filename = 'C:\Users\stweis\SkyDrive\MVPA_ARROWS\FMRI_Materials\Behavioral_Exp v03\RDMs\rsa_dir_discrete.csv';
delimiter = ',';
startRow = 2;
formatSpec = '%*s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
rsaGenDiscrete = [dataArray{1:end-1}];
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

filename = 'C:\Users\stweis\SkyDrive\MVPA_ARROWS\FMRI_Materials\Behavioral_Exp v03\RDMs\rsa_dir_continuous.csv';
delimiter = ',';
startRow = 2;
formatSpec = '%*s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
rsaGenContinuous = [dataArray{1:end-1}];
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

filename = 'C:\Users\stweis\SkyDrive\MVPA_ARROWS\FMRI_Materials\Behavioral_Exp v03\RDMs\rsa_dir_discrete_within_image.csv';
delimiter = ',';
startRow = 2;
formatSpec = '%*s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
rsaWithinDiscImage = [dataArray{1:end-1}];
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

filename = 'C:\Users\stweis\SkyDrive\MVPA_ARROWS\FMRI_Materials\Behavioral_Exp v03\RDMs\rsa_dir_discrete_within_schema.csv';
delimiter = ',';
startRow = 2;
formatSpec = '%*s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
rsaWithinDiscSchema = [dataArray{1:end-1}];
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

filename = 'C:\Users\stweis\SkyDrive\MVPA_ARROWS\FMRI_Materials\Behavioral_Exp v03\RDMs\rsa_dir_discrete_within_word.csv';
delimiter = ',';
startRow = 2;
formatSpec = '%*s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
rsaWithinDiscWord = [dataArray{1:end-1}];
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

filename = 'C:\Users\stweis\SkyDrive\MVPA_ARROWS\FMRI_Materials\Behavioral_Exp v03\RDMs\rsa_dir_continuous_within_image.csv';
delimiter = ',';
startRow = 2;
formatSpec = '%*s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
rsaWithinContImage = [dataArray{1:end-1}];
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

filename = 'C:\Users\stweis\SkyDrive\MVPA_ARROWS\FMRI_Materials\Behavioral_Exp v03\RDMs\rsa_dir_continuous_within_schema.csv';
delimiter = ',';
startRow = 2;
formatSpec = '%*s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
rsaWithinContSchema = [dataArray{1:end-1}];
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

filename = 'C:\Users\stweis\SkyDrive\MVPA_ARROWS\FMRI_Materials\Behavioral_Exp v03\RDMs\rsa_dir_continuous_within_word.csv';
delimiter = ',';
startRow = 2;
formatSpec = '%*s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
rsaWithinContWord = [dataArray{1:end-1}];
clearvars filename delimiter startRow formatSpec fileID dataArray ans;


rsaWithinContImage = rsaWithinContImage(1:21,1:21);
rsaWithinContSchema = rsaWithinContSchema(1:21,1:21);
rsaWithinContWord = rsaWithinContWord(1:21,1:21);
rsaWithinDiscImage = rsaWithinDiscImage(1:21,1:21);
rsaWithinDiscSchema = rsaWithinDiscSchema(1:21,1:21);
rsaWithinDiscWord = rsaWithinDiscWord(1:21,1:21);
