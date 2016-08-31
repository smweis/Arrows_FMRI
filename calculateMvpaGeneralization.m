function [] = calculateMvpaGeneralization(subjects)  %enter subjects as matrix (e.g., [103,104,...,110]).

pathSeed();

%%additional path for script
addpath('F:\MVPA_ARROWS\MVPA_107_and_up\');


for i = 1:length(subjects)
    allSubjects{1,i} = subjects(i);
end

nParameters = 21;
nRuns = 6;
pairwiseRuns = nchoosek(1:nRuns,2);
pairwiseParameters = nchoosek(1:nParameters,2);

rdm = zeros(nParameters,nParameters,length(pairwiseRuns)); %set rdm size

%1=ahead,2=left,3=right,4=shLeft,5=shRight,6=slLeft,7=slRight
directionIndex = [ones(1,(nParameters/7)) 2*ones(1,(nParameters/7)) 3*ones(1,(nParameters/7)) 4*ones(1,(nParameters/7)) 5*ones(1,(nParameters/7)) 6*ones(1,(nParameters/7)) 7*ones(1,(nParameters/7))];

%1=image,2=schema,3=word
formatIndex = repmat([ones(1,(nParameters/21)) 2*ones(1,(nParameters/21)) 3*ones(1,(nParameters/21))],1,7);





% 
% sddfCount = 1;
% dddfCount = 1;
% sdsfCount = 1;
% ddsfCount = 1;
% sdCount = 1;
% ddCount = 1;
% 
%         
% for parameterPair = 1:length(pairwiseParameters)
%     image1 = pairwiseParameters(parameterPair,2);
%     image2 = pairwiseParameters(parameterPair,1);
%     dirIsSame = directionIndex(image1) == directionIndex(image2);
%     formatIsSame = formatIndex(image1) == formatIndex(image2);
%     
%     if (dirIsSame&&~formatIsSame)
%         sameDirDiffFormat(1,sddfCount) = subjectRDM(image1,image2);
%         sameDir(1,sdCount) = subjectRDM(image1,image2);
%         sddfCount = sddfCount + 1;
%         sdCount = sdCount + 1;
%     elseif (~dirIsSame&&~formatIsSame)
%         diffDirDiffFormat(1,dddfCount) = subjectRDM(image1,image2);
%         diffDir(1,ddCount) = subjectRDM(image1,image2);
%         dddfCount = dddfCount + 1;
%         ddCount = ddCount + 1;
%     elseif (dirIsSame&&formatIsSame)
%         sameDirSameFormat(1,sdsfCount) = subjectRDM(image1,image2);
%         sameDir(1,sdCount) = subjectRDM(image1,image2);
%         sdsfCount = sdsfCount + 1;
%         sdCount = sdCount + 1;
%     elseif (~dirIsSame&&formatIsSame)
%         diffDirSameFormat(1,ddsfCount) = subjectRDM(image1,image2);
%         diffDir(1,ddCount) = subjectRDM(image1,image2);
%         ddsfCount = ddsfCount + 1;
%         ddCount = ddCount + 1;
%     end    
% end
% 



%real brain data loaded for each subject
roiNames = {'OPA','PPA','RSC'};

for thisSubject = 1:length(allSubjects)
    
    cd (horzcat('F:\MVPA_ARROWS\MVPA_107_and_up\',num2str(allSubjects{thisSubject}),'\Brain_Data\MVPA_Data\')); %go to subject directory
    
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
            
            parameterAverage1(thisParameter,:) = mean(tempParam(1:3,:));
            parameterAverage2(thisParameter,:) = mean(tempParam(4:6,:));
            
            
            clear('run1','run2','run3','run4','run5','run6');
            
        end     %average parameter runs together
    
        parameterAveragesFlipped1 = parameterAverage1';
        parameterAveragesFlipped2 = parameterAverage2';
        
        
        
        
        
        
      %  subRDM = corr([parameterAveragesFlipped]);   % THIS IS THE AVERAGE
      %  FOR ALL RUNS
        
       splitHalf = corr([parameterAveragesFlipped1 parameterAveragesFlipped2]);
       splitHalf = splitHalf(1:21,22:end);
        

        save(strcat(roiNames{thisRoi},'_generalization'));

        
    end
    allSubjects{thisSubject}
    cd ../..;
end



