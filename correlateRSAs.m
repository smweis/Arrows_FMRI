

allSubjects = {'107','108','109','110'};

currDir = pwd;
nConditions = 21;
loadRDMs; 
rsaContinuousRDMS = {'rsaGenDiscrete', 'rsaGenContinuous'};
rsaWithinRDMS = {'rsaWithinDiscImage','rsaWithinDiscSchema',...
           'rsaWithinDiscWord','rsaWithinContImage','rsaWithinContSchema','rsaWithinContWord'};

allRDMS = [rsaContinuousRDMS rsaWithinRDMS];
       
roiPath = 'F:\MVPA_ARROWS\MVPA_107_and_up\ROI_templates';
addpath(roiPath);
cd(roiPath);

subjectPath = 'F:\MVPA_ARROWS\MVPA_107_and_up\';

roiDir = 'ROI_Masks';
roiNames = {'OPA','PPA','RSC'};

correlationData = zeros(length(allSubjects),length(roiNames)*(length(rsaWithinRDMS)+2));
correlationOrder = cell(1,length(roiNames)*(length(rsaWithinRDMS)+2));
rdmtype = [ones(1,3) 2*ones(1,3) 3*ones(1,3) 4*ones(1,3) 5*ones(1,3) 6*ones(1,3) 7*ones(1,3) 8*ones(1,3)];
for i = 1:length(correlationOrder)
    roi = roiNames{mod(i+2,3)+1};
    correlationOrder{1,i} = strcat(roi,'_',allRDMS{rdmtype(i)});
end


for thisSubject = 1:length(allSubjects)
    cd(horzcat(subjectPath,allSubjects{thisSubject},'\Brain_Data\MVPA_Data\'));

    for thisRoi = 1:length(roiNames)
        load(strcat(roiNames{thisRoi},'_generalization.mat'));
        subjectRDM(1:21,21) = nan;
        indexNoNanDisc = find(~isnan(rsaGenDiscrete)&~isnan(subjectRDM));
        correlationData(thisSubject,thisRoi) = corr(rsaGenDiscrete(indexNoNanDisc),subjectRDM(indexNoNanDisc),'Type','Spearman');
        indexNoNanCont = find(~isnan(rsaGenContinuous)&~isnan(subjectRDM));
        correlationData(thisSubject,thisRoi+3) = corr(rsaGenContinuous(indexNoNanCont),subjectRDM(indexNoNanCont),'Type','Spearman');

        for thisRDM = 1:length(rsaWithinRDMS)
            load(strcat(roiNames{thisRoi},'_within.mat'));
            rsa = eval(rsaWithinRDMS{thisRDM});
            rsa  = rsa(1:nConditions,1:nConditions);
            index = find(~isnan(rsa)&~isnan(rdm_mean));
            correlationData(thisSubject,thisRoi+((thisRDM+1)*3)) = corr(rsa(index),rdm_mean(index),'Type','Spearman');
        end

    end
end
cd ..;
save('rsas');