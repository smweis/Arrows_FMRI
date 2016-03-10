gen_within = Lback(85:252,1:168);
gen_between = Lback(85:252,1:168);

gen_within(1:84,85:168) = nan;
gen_between(1:84,85:168) = nan;

nums = [1,13,25,37,49,61,73,85,97,109,121,133,145,157];
nums2 = [12,24,36,48,60,72,84,96,108,120,132,144,156,168];

nums3 = [85,97,109,121,133,145,157];
nums4 = [96,108,120,132,144,156,168];

% gen_within = Lback(85:168,1:84);
% gen_between = Lback(85:168,1:84);
% 
% gen_within(1:84,85:168) = nan;
% gen_between(1:84,85:168) = nan;
% 
% nums = [1,13,25,37,49,61,73];
% nums2 = [12,24,36,48,60,72,84];
% 


gen_within_cat = cell(1,21);

for i = 1:length(nums)
    gen_within_cat{i} = gen_within(nums(i):nums2(i),nums(i):nums2(i));
    gen_between(nums(i):nums2(i),nums(i):nums2(i)) = nan;
end

for k = 1:length(nums3)
    gen_within_cat{k+14} = gen_within(nums3(k):nums4(k),nums(k):nums2(k));
    gen_between(nums3(k):nums4(k),nums(k):nums2(k)) = nan;
    gen_between(nums3(k):nums4(k),nums3(k):nums4(k)) = nan;
end

gen_within_cat = cell2mat(gen_within_cat);
within_other = mean(mean(gen_within_cat,'omitnan'),'omitnan');

between_other = mean(mean(gen_between, 'omitnan'), 'omitnan');


%%%Randomized Matrix

low_ind = find(tril(ones(numImages),-1)==1);
low_length = length(low_ind);
low_elements = Lback(low_ind);
finalRand = zeros(1,numConditions);

%%%how many permutations?
numPerms = 10000;


betweenRand = zeros(1,numPerms);
withinRand = zeros(1,numPerms);
subtractRand = zeros(1,numPerms);
%calculate between/within means for each randomly shuffled matrix, store it
%in a vector
for i = 1:numPerms
    L_Rand = Lback;
    L_Rand(low_ind) = low_elements(randperm(low_length));

    for j = 1:length(nums)
        finalRand(j) = mean(mean(L_Rand(nums(j):nums2(j),nums(j):nums2(j)),'omitnan'),'omitnan');
        L_Rand(nums(j):nums2(j),nums(j):nums2(j)) = nan;
    end

    betweenRand(1,i) = mean(mean(L_Rand, 'omitnan'),'omitnan');
    withinRand(1,i) = mean(finalRand);
    subtractRand(1,i) = withinRand(1,i) - betweenRand(1,i);
end

%plot within vs. between
histogram(subtractRand,20);

