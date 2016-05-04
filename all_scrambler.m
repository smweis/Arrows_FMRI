cd('C:\Users\stweis\SkyDrive\MVPA_ARROWS\FMRI_Materials\Behavioral_Exp v03\FINAL_24_ALL\');
mkdir('scrambled');
files = dir('*image*');
temp = struct2cell(files);
names = temp(1,:)';


cd('scrambled');


for i=1:length(names)
    name = mat2str(cell2mat(names(i)));
    name = name(2:end-1);
    phase_scrambler('C:\Users\stweis\SkyDrive\MVPA_ARROWS\FMRI_Materials\Behavioral_Exp v03\FINAL_24_ALL\',name);
end