
addpath('F:\MVPA_ARROWS\MVPA_107_and_up\');

allSubjects = {'107','108','109','110'};


%calculate within and between correlations

numImages = 21;
numDirections = 7;
numExemplars = 1;
numFormats = 3;

%1=ahead,2=left,3=right,4=shLeft,5=shRight,6=slLeft,7=slRight
directionIndex = [ones(1,(numImages/numDirections)) 2*ones(1,(numImages/numDirections)) 3*ones(1,(numImages/numDirections)) 4*ones(1,(numImages/numDirections)) ...
    5*ones(1,(numImages/numDirections)) 6*ones(1,(numImages/numDirections)) 7*ones(1,(numImages/numDirections))];

%1=image,2=schema,3=word
formatIndex = repmat([ones(1,(numImages/(numFormats*numDirections))) 2*ones(1,(numImages/(numFormats*numDirections))) 3*ones(1,(numImages/(numFormats*numDirections)))],1,(numDirections));



%%This is the same thing, or should be, but steps through each IMAGE. 
%These sizes are arbitrary.
sameDirDiffFormat = zeros(1,6048);
diffDirDiffFormat = zeros(1,36288);
sameDirSameFormat = zeros(1,3024);
diffDirSameFormat = zeros(1,18144);
diffDir = zeros(1,54432);
sameDir = zeros(1,9072);

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


%%This will do the same analyses but over a bunch of randomly permuted
%%matrices.
numPerms = 100;




sameDirDiffFormatRandAll = zeros(1,numPerms);
diffDirDiffFormatRandAll = zeros(1,numPerms);
diffDirSameFormatRandAll = zeros(1,numPerms);
sameDirSameFormatRandAll = zeros(1,numPerms);
sameDirRandAll = zeros(1,numPerms);
diffDirRandAll = zeros(1,numPerms);
generalizeRandAll = zeros(1,numPerms);

%These sizes are arbitrary.
sameDirDiffFormatRand = zeros(1,6048);
diffDirDiffFormatRand = zeros(1,36288);
sameDirSameFormatRand = zeros(1,3024);
diffDirSameFormatRand = zeros(1,18144);
diffDirRand = zeros(1,54432);
sameDirRand = zeros(1,9072);

%Find the index for all numbers in the lower triangle without the diagonal.
%We will randomize this for each permutation, then re-assign the gist
%correlations to another cell. Then mirror the lower triangle and change
%the diagonal to NaNs.

lowerIndex = find(tril(ones(size(rdm_mean)),-1)==1);
for perm = 1:numPerms
    
    randomIndex = lowerIndex(randperm(length(lowerIndex)));  
    corrRand = zeros(size(rdm_mean));
    for thisRandomIndex = 1:length(randomIndex)
        [row, col] = ind2sub(size(rdm_mean),lowerIndex(thisRandomIndex));
        corrRand(row,col) = rdm_mean(randomIndex(thisRandomIndex));
    end
    
    
    %Symmetrize the matrix and turn the diag into nans
    upperCorrRand = corrRand';
    corrRand = corrRand + upperCorrRand;
    corrRand(1:size(corrRand,1)+1:end) = NaN;
    
    
    
    sddfCountRand = 1;
    dddfCountRand = 1;
    sdsfCountRand = 1;  
    ddsfCountRand = 1; 
    ddCountRand = 1; 
    sdCountRand = 1;
    
    
    for image1 = 1:length(corrRand)
        for image2 = 1:length(corrRand)
            dirIsSame = directionIndex(image1) == directionIndex(image2);
            formatIsSame = formatIndex(image1) == formatIndex(image2);
            if (dirIsSame&&~formatIsSame)
                sameDirDiffFormatRand(1,sddfCountRand) = corrRand(image1,image2);
                sddfCountRand = sddfCountRand + 1;
                sameDirRand(1,sdCountRand) = corrRand(image1,image2);
                sdCountRand = sdCountRand + 1;
            elseif (~dirIsSame&&~formatIsSame)
                diffDirDiffFormatRand(1,dddfCountRand) = corrRand(image1,image2);
                dddfCountRand = dddfCountRand + 1;
                diffDirRand(1,ddCountRand) = corrRand(image1,image2);
                ddCountRand = ddCountRand + 1;
            elseif (dirIsSame&&formatIsSame)
                sameDirSameFormatRand(1,sdsfCountRand) = corrRand(image1,image2);
                sdsfCountRand = sdsfCountRand + 1;
                sameDirRand(1,sdCountRand) = corrRand(image1,image2);
                sdCountRand = sdCountRand + 1;
            elseif (~dirIsSame&&formatIsSame)
                diffDirSameFormatRand(1,ddsfCountRand) = corrRand(image1,image2);
                ddsfCountRand = ddsfCountRand + 1;
                diffDirRand(1,ddCountRand) = corrRand(image1,image2);
                ddCountRand = ddCountRand + 1;
            end
        end
    end

    sameDirDiffFormatRandAll(1,perm) = nanmean(sameDirDiffFormatRand);
    diffDirDiffFormatRandAll(1,perm) = nanmean(diffDirDiffFormatRand);
    diffDirSameFormatRandAll(1,perm) = nanmean(diffDirSameFormatRand);
    sameDirSameFormatRandAll(1,perm) = nanmean(sameDirSameFormatRand);
    sameDirRandAll(1,perm) = nanmean(sameDirRand);
    diffDirRandAll(1,perm) = nanmean(diffDirRand);
    
    generalizeRandAll(1,perm) = sameDirDiffFormatRandAll(1,perm) - diffDirDiffFormatRandAll(1,perm);
    
end
    
sameDirDiffFormatRandMean = mean(sameDirDiffFormatRandAll);
diffDirDiffFormatRandMean = mean(diffDirDiffFormatRandAll);
diffDirSameFormatRandMean = mean(diffDirSameFormatRandAll);
sameDirSameFormatRandMean = mean(sameDirSameFormatRandAll);
sameDirRandMean = mean(sameDirRandAll);
diffDirRandMean = mean(diffDirRandAll);
