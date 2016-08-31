function [ demeaned ] = cocktailDemean(unDemeaned)
%%%must pass a matrix that is voxels * conditions

    ave = mean(unDemeaned')';
    
    aveAll = repmat(ave,1,size(unDemeaned,2));
    
    demeaned = unDemeaned - aveAll;

end

