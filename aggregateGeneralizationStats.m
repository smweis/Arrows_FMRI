function [] = aggregateGeneralizationStats(subjects)  %enter subjects as matrix (e.g., [103,104,...,110]).

pathSeed();


for i = 1:length(subjects)
    subjs{1,i} = subjects(i);
end

%%additional path for script
addpath('F:\MVPA_ARROWS\MVPA_107_and_up\');

roiNames = {'OPA','PPA','RSC'};



avg_group_matrix = zeros(21,21,length(subjs),length(roiNames));




for newSubject = 1:length(subjs)
    
    cd (horzcat('F:\MVPA_ARROWS\MVPA_107_and_up\',num2str(subjs{newSubject}),'\Brain_Data\MVPA_Data\')); %go to subject directory
    
    for newRoi = 1:length(roiNames)
        load(horzcat(roiNames{newRoi},'_generalization.mat'));
        avg_group_matrix(:,:,newSubject,newRoi) = splitHalf;
        
    end
    
end

opa = avg_group_matrix(:,:,:,1);
ppa = avg_group_matrix(:,:,:,2);
rsc = avg_group_matrix(:,:,:,3);

opa_ave = mean(opa,3);
ppa_ave = mean(ppa,3);
rsc_ave = mean(rsc,3);

loadRDMs;

opaSameImage = opa_ave(find(rsaWithinDiscImage == 1));
opaDiffImage = opa_ave(find(rsaWithinDiscImage == 0));
opaWithinImage = mean(opaSameImage) - mean(opaDiffImage);

opaSameSchema = opa_ave(find(rsaWithinDiscSchema == 1));
opaDiffSchema = opa_ave(find(rsaWithinDiscSchema == 0));
opaWithinSchema = mean(opaSameSchema) - mean(opaDiffSchema);

opaSameWord = opa_ave(find(rsaWithinDiscWord == 1));
opaDiffWord = opa_ave(find(rsaWithinDiscWord == 0));
opaWithinWord = mean(opaSameWord) - mean(opaDiffWord);

opaSameGen = opa_ave(find(rsaGenDiscrete == 1));
opaDiffGen = opa_ave(find(rsaGenDiscrete == 0));
opaGeneralize = mean(opaSameGen) - mean(opaDiffGen);

ppaSameImage = ppa_ave(find(rsaWithinDiscImage == 1));
ppaDiffImage = ppa_ave(find(rsaWithinDiscImage == 0));
ppaWithinImage = mean(ppaSameImage) - mean(ppaDiffImage);

ppaSameSchema = ppa_ave(find(rsaWithinDiscSchema == 1));
ppaDiffSchema = ppa_ave(find(rsaWithinDiscSchema == 0));
ppaWithinSchema = mean(ppaSameSchema) - mean(ppaDiffSchema);

ppaSameWord = ppa_ave(find(rsaWithinDiscWord == 1));
ppaDiffWord = ppa_ave(find(rsaWithinDiscWord == 0));
ppaWithinWord = mean(ppaSameWord) - mean(ppaDiffWord);

ppaSameGen = ppa_ave(find(rsaGenDiscrete == 1));
ppaDiffGen = ppa_ave(find(rsaGenDiscrete == 0));
ppaGeneralize = mean(ppaSameGen) - mean(ppaDiffGen);

rscSameImage = rsc_ave(find(rsaWithinDiscImage == 1));
rscDiffImage = rsc_ave(find(rsaWithinDiscImage == 0));
rscWithinImage = mean(rscSameImage) - mean(rscDiffImage);

rscSameSchema = rsc_ave(find(rsaWithinDiscSchema == 1));
rscDiffSchema = rsc_ave(find(rsaWithinDiscSchema == 0));
rscWithinSchema = mean(rscSameSchema) - mean(rscDiffSchema);

rscSameWord = rsc_ave(find(rsaWithinDiscWord == 1));
rscDiffWord = rsc_ave(find(rsaWithinDiscWord == 0));
rscWithinWord = mean(rscSameWord) - mean(rscDiffWord);

rscSameGen = rsc_ave(find(rsaGenDiscrete == 1));
rscDiffGen = rsc_ave(find(rsaGenDiscrete == 0));
rscGeneralize = mean(rscSameGen) - mean(rscDiffGen);

cd ../../..
save('generalizationStats.mat');