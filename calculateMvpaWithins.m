function [] = calculateMvpaWithins()
%%%This script will correlate individual runs, pairwise, to get estimates
%%%for the within-format same direction - diff direction comparisons. 

% DEPENDENCY! combinator package for matlab

addpath('F:\MVPA_ARROWS\MVPA_107_and_up\');

allSubjects = {'107','108','109','110'};

nParameters = 21;
nRuns = 6;
a = 1:nParameters;
b = 1:nRuns;
result = combvec(a,b);
loadNiiVector = result';

pairwiseRuns = nchoosek(1:nRuns,2); %we don't want to correlate each run w/ itself

pairwiseParameters = combinator(21,2,'c','r'); 



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
    
    cd (horzcat('F:\MVPA_ARROWS\MVPA_107_and_up\',allSubjects{thisSubject},'\Brain_Data\MVPA_Data\')); %go to subject directory
    
    for thisRoi = 1:length(roiNames)
        cd('ROI_Masks');
        roiNifti_L = load_nii(strcat('L',roiNames{thisRoi},'_mask.nii.gz'));
        roiNifti_R = load_nii(strcat('R',roiNames{thisRoi},'_mask.nii.gz'));
        roiIndex = find(roiNifti_L.img>0 | roiNifti_R.img>0);
        cd ..;
        

        tempParam = zeros(length(roiIndex),nParameters*nRuns);
        %load all parameters, index them with the ROI (bilaterally)
        for thisParam = 1:nParameters*nRuns
            peName = strcat('pe',num2str(loadNiiVector(thisParam,1)),'_reg_run',num2str(loadNiiVector(thisParam,2)),'.nii.gz');
            run = load_nii(peName);
            tempParam(:,thisParam) = run.img(roiIndex);
        end
        
        %take all pairwise correlations, and put them in the RDM.
        for thisParameter = 1:length(pairwiseParameters)
            
            for thisRun = 1:length(pairwiseRuns)
                tempParamIndex1 = (pairwiseParameters(thisParameter,1)-1)*6 + pairwiseRuns(thisRun,1);
                tempParamIndex2 = (pairwiseParameters(thisParameter,2)-1)*6 + pairwiseRuns(thisRun,2);
                rdm(pairwiseParameters(thisParameter,2),pairwiseParameters(thisParameter,1),thisRun) = corr(tempParam(:, tempParamIndex1),tempParam(:,tempParamIndex2));   
            end
            
           
        end
        rdm(rdm==0) = NaN;
        rdm_mean = nanmean(rdm,3);
        
        sameDirDiffFormat = zeros(1,1);
        diffDirDiffFormat = zeros(1,1);
        sameDirSameFormat = zeros(1,1);
        diffDirSameFormat = zeros(1,1);
        diffDir = zeros(1,1);
        sameDir = zeros(1,1);
        
        sddfCount = 1;
        dddfCount = 1;
        sdsfCount = 1;
        ddsfCount = 1;
        ddCount = 1;
        sdCount = 1;
        
        for image1 = 1:length(rdm_mean)
            for image2 = 1:length(rdm_mean)
                dirIsSame = directionIndex(image1) == directionIndex(image2);
                formatIsSame = formatIndex(image1) == formatIndex(image2);
                if (dirIsSame&&~formatIsSame)
                    sameDirDiffFormat(1,sddfCount) = rdm_mean(image1,image2);
                    sameDir(1,sdCount) = rdm_mean(image1,image2);
                    sddfCount = sddfCount + 1;
                    sdCount = sdCount + 1;
                elseif (~dirIsSame&&~formatIsSame)
                    diffDirDiffFormat(1,dddfCount) = rdm_mean(image1,image2);
                    diffDir(1,ddCount) = rdm_mean(image1,image2);
                    dddfCount = dddfCount + 1;
                    ddCount = ddCount + 1;
                elseif (dirIsSame&&formatIsSame)
                    sameDirSameFormat(1,sdsfCount) = rdm_mean(image1,image2);
                    sameDir(1,sdCount) = rdm_mean(image1,image2);
                    sdsfCount = sdsfCount + 1;
                    sdCount = sdCount + 1;
                elseif (~dirIsSame&&formatIsSame)
                    diffDirSameFormat(1,ddsfCount) = rdm_mean(image1,image2);
                    diffDir(1,ddCount) = rdm_mean(image1,image2);
                    ddsfCount = ddsfCount + 1;
                    ddCount = ddCount + 1;
                end
            end
        end
        
        
        
        
        sameDirDiffFormatMean = nanmean(sameDirDiffFormat);
        diffDirDiffFormatMean = nanmean(diffDirDiffFormat);
        diffDirSameFormatMean = nanmean(diffDirSameFormat);
        sameDirSameFormatMean = nanmean(sameDirSameFormat);
        sameDirMean = nanmean(sameDir);
        diffDirMean = nanmean(diffDir);
        
        
        generalize = sameDirDiffFormatMean - diffDirDiffFormatMean;
        
        save(strcat(roiNames{thisRoi},'_within'),'rdm','rdm_mean','sameDirDiffFormatMean','diffDirDiffFormatMean','sameDirSameFormatMean','diffDirSameFormatMean','generalize');  
    end
    
    
    cd ../..;

end