function [] = calculateMvpaGeneralization()

pathSeed('C:\Users\stweis\SkyDrive\MVPA_ARROWS\FMRI_Materials\Behavioral_Exp v03\MVPA_Data_4_Subjects');


addpath('MVPA_Data_4_Subjects');

allSubjects = {'103','104','105','106'};

nParameters = 21;
nRuns = 6;
pairwiseRuns = nchoosek(1:nRuns,2);
pairwiseParameters = nchoosek(1:nParameters,2);

rdm = zeros(nParameters,nParameters,length(pairwiseRuns)); %set rdm size

%1=ahead,2=left,3=right,4=shLeft,5=shRight,6=slLeft,7=slRight
directionIndex = [ones(1,(nParameters/7)) 2*ones(1,(nParameters/7)) 3*ones(1,(nParameters/7)) 4*ones(1,(nParameters/7)) 5*ones(1,(nParameters/7)) 6*ones(1,(nParameters/7)) 7*ones(1,(nParameters/7))];

%1=image,2=schema,3=word
formatIndex = repmat([ones(1,(nParameters/21)) 2*ones(1,(nParameters/21)) 3*ones(1,(nParameters/21))],1,7);

%this is just for making a random ROI to make things go faster
% brainSize = numel(zeros(91,109,91)); %size of .img
% randROI = randperm(brainSize); 
% randROI = randROI(1:300); %choose 300 random voxels


%real brain data loaded for each subject
roiNames = {'OPA','PPA','RSC'};

for thisSubject = 1:length(allSubjects)
    
    cd (horzcat('MVPA_Data_4_Subjects/',allSubjects{thisSubject})); %go to subject directory
    
    for thisRoi = 1:length(roiNames)
        cd('ROI_Masks');
        roiNifti_L = load_nii(strcat('L',roiNames{thisRoi},'_mask.nii.gz'));
        roiNifti_R = load_nii(strcat('R',roiNames{thisRoi},'_mask.nii.gz'));
        roiIndex = find(roiNifti_L.img>0 | roiNifti_R.img>0);
        cd ..;
        for thisParameter = 1:nParameters
            tempParameter = zeros(nRuns,length(roiIndex));
            
            %average parameters together
            firstParameterRun = horzcat('pe',num2str(thisParameter),'_reg_run1.nii.gz');
            secondParameterRun = horzcat('pe',num2str(thisParameter),'_reg_run2.nii.gz');
            thirdParameterRun = horzcat('pe',num2str(thisParameter),'_reg_run3.nii.gz');
            fourthParameterRun = horzcat('pe',num2str(thisParameter),'_reg_run4.nii.gz');
            fifthParameterRun = horzcat('pe',num2str(thisParameter),'_reg_run5.nii.gz');
            sixthParameterRun = horzcat('pe',num2str(thisParameter),'_reg_run6.nii.gz');
            
            run1 = load_nii(firstParameterRun);
            run2 = load_nii(secondParameterRun);
            run3 = load_nii(thirdParameterRun);
            run4 = load_nii(fourthParameterRun);
            run5 = load_nii(fifthParameterRun);
            run6 = load_nii(sixthParameterRun);
            
            
            
            tempParam(1,:) = run1.img(roiIndex);
            tempParam(2,:) = run2.img(roiIndex);
            tempParam(3,:) = run3.img(roiIndex);
            tempParam(4,:) = run4.img(roiIndex);
            tempParam(5,:) = run5.img(roiIndex);
            tempParam(6,:) = run6.img(roiIndex);
            
            parameterAverages(thisParameter,:) = mean(tempParam);
            
            clear('run1','run2','run3','run4','run5','run6');
            
        end     %average parameter runs together
    
        parameterAveragesFlipped = parameterAverages';
        
        
        
        sddfCount = 1;
        dddfCount = 1;
        sdsfCount = 1;
        ddsfCount = 1;
        sdCount = 1;
        ddCount = 1;
    
        for parameterPair = 1:length(pairwiseParameters)
            image1 = pairwiseParameters(parameterPair,2);
            image2 = pairwiseParameters(parameterPair,1);
            
            subjectRDM(image1,image2) = corr(parameterAveragesFlipped(:,image1),parameterAveragesFlipped(:,image2));
            
            
            
            dirIsSame = directionIndex(image1) == directionIndex(image2);
            formatIsSame = formatIndex(image1) == formatIndex(image2);
            
            if (dirIsSame&&~formatIsSame)
                sameDirDiffFormat(1,sddfCount) = subjectRDM(image1,image2);
                sameDir(1,sdCount) = subjectRDM(image1,image2);
                sddfCount = sddfCount + 1;
                sdCount = sdCount + 1;
            elseif (~dirIsSame&&~formatIsSame)
                diffDirDiffFormat(1,dddfCount) = subjectRDM(image1,image2);
                diffDir(1,ddCount) = subjectRDM(image1,image2);
                dddfCount = dddfCount + 1;
                ddCount = ddCount + 1;
                %         elseif (dirIsSame&&formatIsSame)
                %             sameDirSameFormat(1,sdsfCount) = subjectRDM(image1,image2);
                %             sameDir(1,sdCount) = subjectRDM(image1,image2);
                %             sdsfCount = sdsfCount + 1;
                %             sdCount = sdCount + 1;
            elseif (~dirIsSame&&formatIsSame)
                diffDirSameFormat(1,ddsfCount) = subjectRDM(image1,image2);
                diffDir(1,ddCount) = subjectRDM(image1,image2);
                ddsfCount = ddsfCount + 1;
                ddCount = ddCount + 1;
            end
            
        end
        
        
        subjectRDM(subjectRDM==0) = NaN;
        
        sameDirDiffFormatMean = nanmean(sameDirDiffFormat);
        diffDirDiffFormatMean = nanmean(diffDirDiffFormat);
        diffDirSameFormatMean = nanmean(diffDirSameFormat);
        %     sameDirSameFormatMean = nanmean(sameDirSameFormat);
        sameDirMean = nanmean(sameDir);
        diffDirMean = nanmean(diffDir);
        
        

        save(strcat(roiNames{thisRoi},'_generalization'));

        
    end
    allSubjects{thisSubject}
    cd ../..;
end



