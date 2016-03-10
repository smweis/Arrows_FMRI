

allSubjects = {'103','104','105','106'};

currDir = pwd;

roiPath = 'C:\Users\stweis\SkyDrive\MVPA_ARROWS\FMRI_Materials\Behavioral_Exp v03\MVPA_Data_4_Subjects\ROI_templates';
addpath(roiPath);
cd(roiPath);

subjectPath = 'C:\Users\stweis\SkyDrive\MVPA_ARROWS\FMRI_Materials\Behavioral_Exp v03\MVPA_Data_4_Subjects\';

roiDir = 'ROI_Masks';
roiNames = {'LOPA','LPPA','LRSC','ROPA','RPPA','RRSC'};



%%this finds the intersection of each brain area w/ the top 100 voxels
%%activated for images - other.
for thisSubject = 1:length(allSubjects)
    cd(horzcat(subjectPath,allSubjects{thisSubject}));
    mkdir(roiDir);
    subjectUnivariate = load_nii('scene_uni.nii.gz');  %load images - else
    for roi = 1:length(roiNames)
        brainRegion = load_nii(horzcat(roiNames{roi},'.nii.gz')); %load brain data
        index = find(brainRegion.img>0);    %get an index of the parcel
        data = subjectUnivariate.img(index);  %find the values within the parcel
        ranked = sort(data);    %sort the parcel
        threshold = ranked(end-99);  %find the threshold for the top 100 voxels
        thresholdIndex = find(subjectUnivariate.img>=threshold); %find the index (in subject brain) of ALL voxels > threshold
        threshIntersect = intersect(thresholdIndex,index); %intersect ALL voxels > threshold with the parcel (this should be a vector, length = 100)
        mask = zeros(size(subjectUnivariate.img)); %next lines save this as a mask
        mask(threshIntersect) = 1;
        
        copySub = subjectUnivariate;
        
        copySub.img = mask;

        cd(roiDir);
        save_nii(copySub,strcat(roiNames{roi},'_mask.nii.gz'));
        cd ..;
    end
    
end


    
    
    