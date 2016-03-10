

% %calculate within and between correlations

numImages = 84;


%1=ahead,2=left,3=right,4=shLeft,5=shRight,6=slLeft,7=slRight
directionIndex = [ones(1,(numImages/7)) 2*ones(1,(numImages/7)) 3*ones(1,(numImages/7)) 4*ones(1,(numImages/7)) 5*ones(1,(numImages/7)) 6*ones(1,(numImages/7)) 7*ones(1,(numImages/7))];

%1=image,2=schema,3=word
%formatIndex = repmat([ones(1,(numImages/21)) 2*ones(1,(numImages/21)) 3*ones(1,(numImages/21))],1,(numImages/36));


%delete the diagonal (1's)    
identity = eye(numImages);

corrNoDiag = C;
for len = 1:length(identity)
    for wid = 1:length(identity)
    if identity(len,wid) == 1
        corrNoDiag(len,wid) = NaN;
    end
    end
end


% %%This calculates the following averages.
% condensed = zeros(21,21);
% 
% same_dir_diff_format = zeros(1,21);
% sddf_count = 1;
% 
% diff_dir_diff_format = zeros(1,21);
% dddf_count = 1;
% 
% 
% diff_dir_same_format = zeros(1,21);
% ddsf_count = 1;
% 
% same_dir_same_format = zeros(1,21);
% sdsf_count = 1;
% 
% %%This steps through each direction, then format, then direction, then
% %%format. 
% 
% for i = 1:length(unique(directionIndex))
%     for j = 1:3
%         for k = 1:7
%             for m = 1:3
%                 condensed(((j-1)*7)+i,((m-1)*7)+k) = nanmean(nanmean(corrNoDiag(find(directionIndex==i&formatIndex==j),find(directionIndex==k&formatIndex==m))));
%                 if i == k && j ~= m
%                     same_dir_diff_format(1,sddf_count) = condensed(((j-1)*7)+i,((m-1)*7)+k);
%                     sddf_count = sddf_count+1;
%                 elseif i ~=k && j ~= m
%                     diff_dir_diff_format(1,dddf_count) = condensed(((j-1)*7)+i,((m-1)*7)+k);
%                     dddf_count = dddf_count+1;
%                 elseif i ~=k && j == m
%                     diff_dir_same_format(1,ddsf_count) = condensed(((j-1)*7)+i,((m-1)*7)+k);
%                     ddsf_count = ddsf_count+1;  
%                 elseif i ==k && j == m
%                     same_dir_same_format(1,sdsf_count) = condensed(((j-1)*7)+i,((m-1)*7)+k);
%                     sdsf_count = sdsf_count+1;    
%                 end
%             end
%         end
%     end
% end
% 
% same_dir_diff_format_mean = mean(same_dir_diff_format);
% diff_dir_diff_format_mean = mean(diff_dir_diff_format);
% diff_dir_same_format_mean = mean(diff_dir_same_format);
% same_dir_same_format_mean = mean(same_dir_same_format);
% 


%%This is the same thing, or should be, but steps through each IMAGE. 
% 
% same_dir_diff_format = zeros(1,21);
diff_dir = zeros(1,21);
same_dir = zeros(1,21);
% diff_dir_same_format = zeros(1,21);
% sd_count = 1;
% dddf_count2 = 1;
% sdsf_count2 = 1;  
dd_count = 1; 
sd_count = 1;

for image1 = 1:length(corrNoDiag)
    for image2 = 1:length(corrNoDiag)
        if directionIndex(image1) ~= directionIndex(image2) 
            diff_dir(1,dd_count) = corrNoDiag(image1,image2);
            dd_count = dd_count + 1; 
        elseif directionIndex(image1) == directionIndex(image2) 
            same_dir(1,sd_count) = corrNoDiag(image1,image2);
            sd_count = sd_count + 1;  
        end
    end
end




same_dir_mean = nanmean(same_dir);
diff_dir_mean = nanmean(diff_dir);
% diff_dir_same_format_mean2 = nanmean(diff_dir_same_format2);
% same_dir_same_format_mean2 = nanmean(same_dir_same_format2);









