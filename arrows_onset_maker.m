
addpath('C:\Users\stweis\Documents\GitHub\Arrows_FMRI');

dataPath = 'F:\MVPA_Arrows\MVPA_107_and_up\';
allPath = genpath(dataPath);
addpath(allPath);

cd(dataPath);

participants = [107 108 109 110];

for participant = 1:length(participants)
    part_num = participants(participant);
    cd (horzcat(num2str(part_num),'\Matlab_Data\'));
    
    
    for run = 1:6
        ons_run_num = run;
        rundir = horzcat('run_',num2str(run));
        mkdir(rundir);
        cd(rundir);
        
        run_length = 100;
        
        listDir = {'ahead','left','right','shLeft','shRight','slLeft','slRight'};
        listFormat = {'image', 'schema','word'};
        
        listDirForm = cell(1,23);
        listDirForm{22} = 'SAME_CATCH';
        listDirForm{23} = 'DIFF_CATCH';
        
        %%%%SET LENGTH OF TR HERE
        
        TR = 3;
        catch_TR = 6;
        
        for a = 1:length(listDir)
            listDirForm{a} = horzcat(listDir{a},'_',listFormat{1});
            listDirForm{a+7} = horzcat(listDir{a},'_',listFormat{2});
            listDirForm{a+14} = horzcat(listDir{a},'_',listFormat{3});
        end
        
        
        onsets_ahead_image_count = 1;
        onsets_left_image_count = 1;
        onsets_right_image_count = 1;
        onsets_shLeft_image_count = 1;
        onsets_shRight_image_count = 1;
        onsets_slLeft_image_count = 1;
        onsets_slRight_image_count = 1;
        onsets_ahead_schema_count = 1;
        onsets_left_schema_count = 1;
        onsets_right_schema_count = 1;
        onsets_shLeft_schema_count = 1;
        onsets_shRight_schema_count = 1;
        onsets_slLeft_schema_count = 1;
        onsets_slRight_schema_count = 1;
        onsets_ahead_word_count = 1;
        onsets_left_word_count = 1;
        onsets_right_word_count = 1;
        onsets_shLeft_word_count = 1;
        onsets_shRight_word_count = 1;
        onsets_slLeft_word_count = 1;
        onsets_slRight_word_count = 1;
        onsets_catch_same_count = 1;
        onsets_catch_diff_count = 1;
        onsets_image_count = 1;
        onsets_schema_count = 1;
        onsets_word_count = 1;
        
        onsets_non_cat_count = 1;
        onsets_cat_count = 1;
        
        
        
        load(horzcat(num2str(part_num),'_',num2str(ons_run_num),'.mat'));
        T_cell = table2cell(T);
        
        if run == 1
            start_num = 1;
        else
            start_num = 6;
        end
        
        for i = start_num:run_length
            trialType = horzcat(T_cell{i,3},'_',T_cell{i,2});
            if strcmpi(trialType, listDirForm{1}) == 1
                onsets_ahead_image(onsets_ahead_image_count,1) = T_cell{i,5};
                onsets_ahead_image_count = onsets_ahead_image_count+1;
            elseif strcmpi(trialType, listDirForm{2}) == 1
                onsets_left_image(onsets_left_image_count,1) = T_cell{i,5};
                onsets_left_image_count = onsets_left_image_count+1;
            elseif strcmpi(trialType, listDirForm{3}) == 1
                onsets_right_image(onsets_right_image_count,1) = T_cell{i,5};
                onsets_right_image_count = onsets_right_image_count+1;
            elseif strcmpi(trialType, listDirForm{4}) == 1
                onsets_shLeft_image(onsets_shLeft_image_count,1) = T_cell{i,5};
                onsets_shLeft_image_count = onsets_shLeft_image_count+1;
            elseif strcmpi(trialType, listDirForm{5}) == 1
                onsets_shRight_image(onsets_shRight_image_count,1) = T_cell{i,5};
                onsets_shRight_image_count = onsets_shRight_image_count+1;
            elseif strcmpi(trialType, listDirForm{6}) == 1
                onsets_slLeft_image(onsets_slLeft_image_count,1) = T_cell{i,5};
                onsets_slLeft_image_count = onsets_slLeft_image_count+1;
            elseif strcmpi(trialType, listDirForm{7}) == 1
                onsets_slRight_image(onsets_slRight_image_count,1) = T_cell{i,5};
                onsets_slRight_image_count = onsets_slRight_image_count+1;
            elseif strcmpi(trialType, listDirForm{8}) == 1
                onsets_ahead_schema(onsets_ahead_schema_count,1) = T_cell{i,5};
                onsets_ahead_schema_count = onsets_ahead_schema_count+1;
            elseif strcmpi(trialType, listDirForm{9}) == 1
                onsets_left_schema(onsets_left_schema_count,1) = T_cell{i,5};
                onsets_left_schema_count = onsets_left_schema_count+1;
            elseif strcmpi(trialType, listDirForm{10}) == 1
                onsets_right_schema(onsets_right_schema_count,1) = T_cell{i,5};
                onsets_right_schema_count = onsets_right_schema_count+1;
            elseif strcmpi(trialType, listDirForm{11}) == 1
                onsets_shLeft_schema(onsets_shLeft_schema_count,1) = T_cell{i,5};
                onsets_shLeft_schema_count = onsets_shLeft_schema_count+1;
            elseif strcmpi(trialType, listDirForm{12}) == 1
                onsets_shRight_schema(onsets_shRight_schema_count,1) = T_cell{i,5};
                onsets_shRight_schema_count = onsets_shRight_schema_count+1;
            elseif strcmpi(trialType, listDirForm{13}) == 1
                onsets_slLeft_schema(onsets_slLeft_schema_count,1) = T_cell{i,5};
                onsets_slLeft_schema_count = onsets_slLeft_schema_count+1;
            elseif strcmpi(trialType, listDirForm{14}) == 1
                onsets_slRight_schema(onsets_slRight_schema_count,1) = T_cell{i,5};
                onsets_slRight_schema_count = onsets_slRight_schema_count+1;
            elseif strcmpi(trialType, listDirForm{15}) == 1
                onsets_ahead_word(onsets_ahead_word_count,1) = T_cell{i,5};
                onsets_ahead_word_count = onsets_ahead_word_count+1;
            elseif strcmpi(trialType, listDirForm{16}) == 1
                onsets_left_word(onsets_left_word_count,1) = T_cell{i,5};
                onsets_left_word_count = onsets_left_word_count+1;
            elseif strcmpi(trialType, listDirForm{17}) == 1
                onsets_right_word(onsets_right_word_count,1) = T_cell{i,5};
                onsets_right_word_count = onsets_right_word_count+1;
            elseif strcmpi(trialType, listDirForm{18}) == 1
                onsets_shLeft_word(onsets_shLeft_word_count,1) = T_cell{i,5};
                onsets_shLeft_word_count = onsets_shLeft_word_count+1;
            elseif strcmpi(trialType, listDirForm{19}) == 1
                onsets_shRight_word(onsets_shRight_word_count,1) = T_cell{i,5};
                onsets_shRight_word_count = onsets_shRight_word_count+1;
            elseif strcmpi(trialType, listDirForm{20}) == 1
                onsets_slLeft_word(onsets_slLeft_word_count,1) = T_cell{i,5};
                onsets_slLeft_word_count = onsets_slLeft_word_count+1;
            elseif strcmpi(trialType, listDirForm{21}) == 1
                onsets_slRight_word(onsets_slRight_word_count,1) = T_cell{i,5};
                onsets_slRight_word_count = onsets_slRight_word_count+1;
            elseif strcmpi(trialType, listDirForm{22}) == 1
                onsets_catch_same(onsets_catch_same_count,1) = T_cell{i,5};
                onsets_catch_same_count = onsets_catch_same_count+1;
            elseif strcmpi(trialType, listDirForm{23}) == 1
                onsets_catch_diff(onsets_catch_diff_count,1) = T_cell{i,5};
                onsets_catch_diff_count = onsets_catch_diff_count+1;
            else
                continue
            end
            
            
        end
        
        for i = start_num:run_length
            trialType = horzcat(T_cell{i,3},'_',T_cell{i,2});
            if strfind(trialType, listFormat{1})
                onsets_image(onsets_image_count,1) = T_cell{i,5};
                onsets_image_count = onsets_image_count+1;
                onsets_non_cat(onsets_non_cat_count,1) = T_cell{i,5};
                onsets_non_cat_count = onsets_non_cat_count+1;
            elseif strfind(trialType, listFormat{2})
                onsets_schema(onsets_schema_count,1) = T_cell{i,5};
                onsets_schema_count = onsets_schema_count+1;
                onsets_non_cat(onsets_non_cat_count,1) = T_cell{i,5};
                onsets_non_cat_count = onsets_non_cat_count+1;
            elseif strfind(trialType, listFormat{3})
                onsets_word(onsets_word_count,1) = T_cell{i,5};
                onsets_word_count = onsets_word_count+1;
                onsets_non_cat(onsets_non_cat_count,1) = T_cell{i,5};
                onsets_non_cat_count = onsets_non_cat_count+1;
            elseif strfind(trialType, listDirForm{22})
                onsets_all_catch(onsets_cat_count,1) = T_cell{i,5};
                onsets_cat_count = onsets_cat_count+1;
            elseif strfind(trialType, listDirForm{23})
                onsets_all_catch(onsets_cat_count,1) = T_cell{i,5};
                onsets_cat_count = onsets_cat_count+1;
            end
        end
        
        onsets = who;
        
        formatSpecs = '%f %f %f\n';
        
        for i = 1:length(onsets)
            if strfind(onsets{i},'onsets')
                if isempty(strfind(onsets{i},'count'))
                    textFilename = [onsets{i} '.onsets'];
                    fid = fopen(textFilename,'w');
                    onsets{i,2} = eval(onsets{i});
                    for j = 1:length(onsets{i,2})
                        onsets{i,2}(j,1) = round(onsets{i,2}(j,1),2);
                        if strfind(onsets{i},'catch')
                            onsets{i,2}(j,2) = catch_TR;
                        else
                            onsets{i,2}(j,2) = TR;
                        end
                        onsets{i,2}(j,3) = 1;
                    end
                    [nrows,ncolumns] = size(onsets{i,2});
                    for row = 1:nrows
                        fprintf(fid,formatSpecs,onsets{i,2}(row,:));
                    end
                    fclose(fid);
                end
            end
        end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        save(horzcat(num2str(part_num),'_',num2str(ons_run_num),'_onsets.mat'),'onsets_ahead_image', 'onsets_ahead_image_count', 'onsets_ahead_schema', 'onsets_ahead_schema_count', 'onsets_ahead_word', 'onsets_ahead_word_count',...
            'onsets_catch_same','onsets_catch_diff', 'onsets_catch_same_count', 'onsets_catch_diff_count', 'onsets_left_image', 'onsets_left_image_count', 'onsets_left_schema', 'onsets_left_schema_count', 'onsets_left_word', 'onsets_left_word_count', 'onsets_right_image',...
            'onsets_right_image_count', 'onsets_right_schema', 'onsets_right_schema_count', 'onsets_right_word', 'onsets_right_word_count', 'onsets_shLeft_image', 'onsets_shLeft_image_count', 'onsets_shLeft_schema',...
            'onsets_shLeft_schema_count', 'onsets_shLeft_word', 'onsets_shLeft_word_count', 'onsets_shRight_image', 'onsets_shRight_image_count', 'onsets_shRight_schema', 'onsets_shRight_schema_count', 'onsets_shRight_word',...
            'onsets_shRight_word_count', 'onsets_slLeft_image', 'onsets_slLeft_image_count', 'onsets_slLeft_schema', 'onsets_slLeft_schema_count', 'onsets_slLeft_word', 'onsets_slLeft_word_count', 'onsets_slRight_image',...
            'onsets_slRight_image_count', 'onsets_slRight_schema', 'onsets_slRight_schema_count', 'onsets_slRight_word', 'onsets_slRight_word_count', 'T', 'T_cell');
     
    
    clear('onsets');    
    cd ..
    
    end
    
    
cd ../..
    
end

        
        
        
        
        
        
        
        
        
    