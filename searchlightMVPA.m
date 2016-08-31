function [] = searchlightMVPA(subject)  %enter subjects as matrix (e.g., [103,104,...,110]).

pathSeed();

%%additional path for script
addpath('F:\MVPA_ARROWS\MVPA_107_and_up\');



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


function [demeanedFirstHalf, demeanedSecondHalf] = getCocktailDemeanedMatrices()

cd (horzcat('F:\MVPA_ARROWS\MVPA_107_and_up\',num2str(subject),'\Brain_Data\MVPA_Data\')); %go to subject directory
    
    for thisRun = 1:nRuns
        %get names of all parameter estimates from thisRun
        files = dir(horzcat('*pe*',num2str(thisRun),'*'));
        
        for thisParameter = 1:nParameters
            %load parameter estimates
            param = load_nii(files(thisParameter).name);
            param = param.img;
            
            %reshape parameter estimates into vectors, arrange them into
            %voxels by conditions matrix
            voxelsByConditions(:,thisParameter) = reshape(param,1,91*109*91);
            
        end    
        
        %cockta
        demeaned = cocktailDemean(voxelsByConditions);
        
        demeanedAll(:,:,thisRun) = demeaned;
            


        
    end
    
    demeanedFirstHalf = mean(demeanedAll(:,:,1:3),3);
    demeanedSecondHalf = mean(demeanedAll(:,:,4:6),3);
    
end

[firstHalf, secondHalf] = getCocktailDemeanedMatrices;


% Define the radius of the searchlight masks (See Kriegeskorte et al 2006
% PNAS for more details if interested.) Standard is 5 mm.
sphere_radius_mm = 5;

% Specify voxel sizes (XYZ). Standard is 3x3x3.
vox_size_X_mm = 2;
vox_size_Y_mm = 2;
vox_size_Z_mm = 2;



% find 3D coords of nonzero elements of param
[subx,suby,subz] = ind2sub(size(param),find(param));

% Define a 3D space for searchlights
[X,Y,Z] = ndgrid(0:vox_size_X_mm:(size(param,1)-1)*vox_size_X_mm,0:...
    vox_size_Y_mm:(size(param,2)-1)*vox_size_Y_mm,0:vox_size_Z_mm:...
    (size(param,3)-1)*vox_size_Z_mm);

% Initialize the mask volume here in order to same time later
mask = zeros(size(param));

% Initialize the storage volumes
withinImagesMap = zeros(size(param));
withinSchemasMap = zeros(size(param));





% Find number of searchlights by counting nonzero elements in
% loaded volume
num_vox = sum(param(:)~=0);


% Strip out zero elements of loaded volumes
firstSemiVolholder = firstHalf(param~=0,:);
secondSemiVolholder = secondHalf(param~=0,:);

% Loop through voxels
for this_voxel = 1:num_vox
    

    % Reset 3D space with origin at the current voxel
    % and define 'mask' as a volume with 1's where voxels
    % are closer than sphere_radius_mm and 0's elsewhere
    mask = (sqrt((X-(subx(this_voxel)-1)*vox_size_X_mm).^2+...
        (Y-(suby(this_voxel)-1)*vox_size_Y_mm).^2+...
        (Z-(subz(this_voxel)-1)*vox_size_Z_mm).^2)<=sphere_radius_mm);
    
    
    % Strip out voxels that are either outside the mask or zero in
    % original volumes
    firstVolholder = firstSemiVolholder(mask(param~=0),:);
    secondVolholder = secondSemiVolholder(mask(param~=0),:);
    
    
            
    % Check to see that the searchlight has at least 2 voxels, and
    % continue to the next voxel if it doesn't
    if size(firstVolholder,1)<2
        continue
    end
    
    
    theMatrix = corr([firstVolholder secondVolholder]);
    
    theMatrix = theMatrix(1:21,22:end);
    
    %CALC TEST COMPARISONS HERE!!
    
    
   % withinImagesMap(subx(this_voxel),suby(this_voxel),subz(this_voxel)) = TESTCOMPARISON; 
    
    
    
    
    
end

end



