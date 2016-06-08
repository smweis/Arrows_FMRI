function [] = arrows_1_28()


% Clear the workspace
close all;
sca;

%reseed the random number generator
rng shuffle;

path = 'C:\Users\chatterjeelab\Documents\Arrows_FMRI\Behavioral_Exp v03\';
addpath(path);
addpath(strcat(path,'\stimuli_named'));
addpath(strcat(path,'\FMRI_Sequences_For_Matlab'));

part_num = input('What is the participant ID? ');


impath = horzcat('C:\Users\chatterjeelab\Documents\Arrows_FMRI\Behavioral_Exp v03\stimuli_named\',num2str(part_num));
cd(impath);
imnames = dir('*.png');
imloaded = struct('names','','images','');
numStims = 504;
imlist = cell(1,numStims);
for i = 1:length(imnames)
    imloaded(i).names = imnames(i).name;
    imloaded(i).images = imread(imnames(i).name);
    imlist{1,i} = imnames(i).name;
end

cd(strcat(path,'\FMRI_Experiment_Scripts'));


%get sequence


run_number = input('What is the run? (1 if new subject) ');


while isnumeric(run_number) && (run_number < 1 || run_number > 6)
    run_number = input('Sorry. Enter a number between 1 and 6. ');
end
load(horzcat(num2str(part_num),'_trials'));


%Prep Stimuli Presentation and Screens

MaxPriority('GetSecs', 'KbCheck', 'KbWait', 'GetClicks', 'KbQueueCheck','KbQueueWait','Screen');
KbName('UnifyKeyNames');


screens = Screen('Screens');
screenNumber = screens;

% 
% Screen('Preference', 'VisualDebugLevel',0);
% Screen('Preference', 'SkipSyncTests', 1);

white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;

% Open an on screen window

[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% % Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

%PREFERENCES
Screen('TextFont', window, 'Helvetica');

trials = load(strcat(num2str(part_num),'_trials.mat'),'trials');
trials = struct2array(trials);

%Jitter the locations
destRect = zeros(length(trials),4);
for i = 1:length(trials)
    rightEdge = randi([xCenter-500,xCenter+500])+400;
    leftEdge = rightEdge-800;
    bottomEdge = randi([yCenter-125,yCenter+125])+400;
    topEdge = bottomEdge-800;
    destRect(i,1) = leftEdge;
    destRect(i,2) = topEdge;
    destRect(i,3) = rightEdge;
    destRect(i,4) = bottomEdge;
end

catch_trial_length = 2.5;

%Present the instructions

if counter_balance == 1
    
    instructions = ['You will see a series of spatial directions. \n\n' ... 
    'Your job is to remember the spatial direction. \n\n' ...
    'For some of the trials, another spatial direction \n\n' ...
    'will appear with the question "SAME?"\n\n' ...
    'You must press the RED key \n\n' ...
    'to indicate a match of spatial directions,\n\n' ... 
    'and the BLUE key to indicate a mistmatch. \n\n' ...
    'Be sure to respond as quickly as you can. \n\n' ... 
    'Press any key when you are ready to continue. \n\n'];
else
    instructions = ['You will see a series of spatial directions. \n\n' ... 
    'Your job is to remember the spatial direction. \n\n' ...
    'For some of the trials, another spatial direction \n\n' ...
    'will appear with the question "SAME?"\n\n' ...
    'You must press the BLUE key \n\n' ...
    'to indicate a match of spatial directions,\n\n' ... 
    'and the RED key to indicate a mistmatch. \n\n' ...
    'Be sure to respond as quickly as you can. \n\n' ... 
    'Press any key when you are ready to continue. \n\n'];
end


numRuns = 6;
overlap = 5;

Screen('TextSize', window, 40);
DrawFormattedText(window, instructions, 'center', 'center', [0 0 0]);
Screen('Flip', window);

KbQueueCreate(-1); 
KbQueueFlush();       
KbQueueStart;
KbQueueWait;
KbQueueRelease;
WaitSecs(.3);



TRs_heard = 0;
TR_data = zeros(2,2000);
run_timing = zeros(4,8);
run_start_secs = 0;
run_end_secs = 0;


keysOfInterest_Main=zeros(1,256);
keysOfInterest_Main(KbName('b'))=1;
keysOfInterest_Main(KbName('r'))=1;

keysOfInterest_Trigger=zeros(1,256);
keysOfInterest_Trigger(KbName('t'))=1;

keysOfInterest_Exp=zeros(1,256);
keysOfInterest_Exp(KbName('space'))=1;



for which_run = run_number:numRuns
    if which_run == 1
        KbQueueCreate(-1, keysOfInterest_Exp);
        first_trial = 1;
        last_trial = run_length;
        run_start = sprintf('Scan will begin shortly.');
        Screen('TextSize', window, 40);
        DrawFormattedText(window, run_start, 'center', 'center', [0 0 0]);
        Screen('Flip', window);
        KbQueueFlush();       
        KbQueueStart;   
        KbQueueWait;
        KbQueueRelease;
        
        KbQueueCreate(-1, keysOfInterest_Trigger);
        KbQueueFlush();
        KbQueueStart;
        DrawFormattedText(window, 'Waiting for scanner...', 'center', 'center', [0 0 0 ]);
        Screen('Flip', window);
        KbQueueFlush();       
        pressed = 0;
        while ~pressed
            [pressed, firstpress] = KbQueueCheck();
            if firstpress(KbName('t'))>0
                TR_time = GetSecs();
                run_start_secs = TR_time;
                run_start_realtime = datevec(now());
                TRs_heard = TRs_heard+1;
                TR_data(1,TRs_heard) = TRs_heard;
                TR_data(2,TRs_heard) = TR_time;
            end
        end




        
        
    elseif which_run == numRuns
        KbQueueCreate(-1, keysOfInterest_Exp);  
        first_trial = ((which_run-1)*run_length - overlap);
        last_trial = 601;
        Screen('TextSize', window, 40);
        run_start = sprintf('Run number %d of %d will begin shortly. \n\n Press any button when ready.',which_run,numRuns);
        DrawFormattedText(window, run_start, 'center', 'center', [0 0 0]);
        Screen('Flip', window);
        KbQueueFlush();
        KbQueueStart;
        KbQueueWait;
        KbQueueRelease;
        
        KbQueueCreate(-1, keysOfInterest_Trigger);
        KbQueueStart;
        DrawFormattedText(window, 'Waiting for scanner...', 'center', 'center', [0 0 0 ]);
        Screen('Flip', window);
        KbQueueFlush();
        pressed = 0;
        while ~pressed
            [pressed, firstpress] = KbQueueCheck();
            if firstpress(KbName('t'))>0
                TR_time = GetSecs();
                run_start_secs = TR_time;
                run_start_realtime = datevec(now());
                TRs_heard = TRs_heard+1;
                TR_data(1,TRs_heard) = TRs_heard;
                TR_data(2,TRs_heard) = TR_time;
            end
        end

    else
        KbQueueCreate(-1, keysOfInterest_Exp); 
        first_trial = ((which_run-1)*run_length - overlap);
        last_trial = ((which_run)*run_length);
        Screen('TextSize', window, 40);
        run_start = sprintf('Run number %d of %d will begin shortly. \n\n Press any button when ready.',which_run,numRuns);
        DrawFormattedText(window, run_start, 'center', 'center', [0 0 0]);
        Screen('Flip', window);
        KbQueueFlush();        
        KbQueueStart;
        KbQueueWait;
        KbQueueRelease;
        
        KbQueueCreate(-1, keysOfInterest_Trigger);

        KbQueueStart;
        DrawFormattedText(window, 'Waiting for scanner...', 'center', 'center', [0 0 0 ]);
        Screen('Flip', window);
        KbQueueFlush();
        pressed = 0;
        while ~pressed
            [pressed, firstpress] = KbQueueCheck();
            if firstpress(KbName('t'))>0
                TR_time = GetSecs();
                run_start_secs = TR_time;
                run_start_realtime = datevec(now());
                TRs_heard = TRs_heard+1;
                TR_data(1,TRs_heard) = TRs_heard;
                TR_data(2,TRs_heard) = TR_time;
            end
        end
             
    end
    
    for i = first_trial:last_trial
        
        
        trials_begin = GetSecs();
        
        %what kind of trial is it?
        if strcmp(trials(2,i), 'image') || strcmp(trials(2,i), 'schema') || strcmp(trials(2,i), 'word')      
            timetest = GetSecs;
            theImageLocation = (strcat(trials{1,i},'.png'));
            theImage = imloaded(find(strcmp(theImageLocation,imlist))).images;
            imageTexture = Screen('MakeTexture', window, theImage);
            Screen('DrawTexture', window, imageTexture, [], destRect(i,:));
            [flip_secs] = Screen('Flip', window);        
            delay = flip_secs-timetest;
            KbQueueFlush();        
            WaitSecs(trials_length);
            [~, firstpress] = KbQueueCheck();
            if firstpress(KbName('t'))>0
                TR_time = GetSecs();
                TRs_heard = TRs_heard+1;
                TR_data(1,TRs_heard) = TRs_heard;
                TR_data(2,TRs_heard) = TR_time;
            end
            iti_test = GetSecs;
            Screen('TextSize', window, 70);
            DrawFormattedText(window, '+', 'center','center', black);
            [ITI_flip_secs] = Screen('Flip',window);
            iti_delay = GetSecs- iti_test;
            
            WaitSecs(iti-delay-iti_delay);
            [~, firstpress] = KbQueueCheck();
            if firstpress(KbName('t'))>0
                TR_time = GetSecs();
                TRs_heard = TRs_heard+1;
                TR_data(1,TRs_heard) = TRs_heard;
                TR_data(2,TRs_heard) = TR_time;
            end

            

        elseif strcmp(trials(2,i), 'NULL')
            timetest = GetSecs;
            Screen('TextSize', window, 70);
            DrawFormattedText(window, '+', 'center','center', black);
            [flip_secs] = Screen('Flip', window);
            KbQueueFlush();        
            %%%%THIS FIXES THE LAG FOR THE OVERALL EXP. BY SHORTENING NULL
            %%%%TRIALS. Shouldn't be more than .2-.3 seconds.

            if (i-first_trial) > 7 && (last_trial - i) > 6 
                if strcmp(trials(2,i+1), 'NULL') && not(strcmp(trials{2,i+2},'NULL')) && not(strcmp(trials{2,i+3},'NULL'))    
                    total_delay = trials{5,i-6} - fix(trials{5,i-6});
                    if total_delay > (trials{5,i-1} - fix(trials{5,i-1}))
                        total_delay = 0;
                    elseif total_delay > .5
                        total_delay = 0;
                    end
                else
                    total_delay = 0;
                end
            else
                total_delay = 0;
            end
            
 
            
            
            
            delay = GetSecs - timetest;
            WaitSecs(trials_length - delay - total_delay);
            [~, firstpress] = KbQueueCheck();
            if firstpress(KbName('t'))>0
                TR_time = GetSecs();
                TRs_heard = TRs_heard+1;
                TR_data(1,TRs_heard) = TRs_heard;
                TR_data(2,TRs_heard) = TR_time;
            end

            iti_timetest = GetSecs;
            Screen('TextSize', window, 70);
            DrawFormattedText(window, '+', 'center','center', black);
            [ITI_flip_secs] = Screen('Flip',window);
            iti_delay = GetSecs-iti_timetest;
            
            
            
            WaitSecs(iti - iti_delay);
            [~, firstpress] = KbQueueCheck();
            if firstpress(KbName('t'))>0
                TR_time = GetSecs();
                TRs_heard = TRs_heard+1;
                TR_data(1,TRs_heard) = TRs_heard;
                TR_data(2,TRs_heard) = TR_time;
            end
            
            

        elseif strcmp(trials(2,i), 'CATCH')
            timetest = GetSecs;
            theImageLocation = trials{14,i};
            theImage = imloaded(find(strcmp(theImageLocation,imlist))).images;
            imageTexture = Screen('MakeTexture', window, theImage);
            Screen('DrawTexture', window, imageTexture, [], destRect(i,:));
            [flip_secs] = Screen('Flip', window);
            delay = GetSecs-timetest;
            KbQueueFlush();        
            WaitSecs(trials_length/2);                      
            [~, firstpress] = KbQueueCheck();
            if firstpress(KbName('t'))>0
                TR_time = GetSecs();
                TRs_heard = TRs_heard+1;
                TR_data(1,TRs_heard) = TRs_heard;
                TR_data(2,TRs_heard) = TR_time;
            end
            WaitSecs(trials_length/2);                      
            [~, firstpress] = KbQueueCheck();
            if firstpress(KbName('t'))>0
                TR_time = GetSecs();
                TRs_heard = TRs_heard+1;
                TR_data(1,TRs_heard) = TRs_heard;
                TR_data(2,TRs_heard) = TR_time;
            end

            iti_test = GetSecs;
            Screen('TextSize', window, 70);
            DrawFormattedText(window, '+', 'center','center', black);
            
            [ITI_flip_secs] = Screen('Flip',window);
            iti_delay = GetSecs - iti_test;

            WaitSecs(1-iti_delay);
            [~, firstpress] = KbQueueCheck();
            if firstpress(KbName('t'))>0
                TR_time = GetSecs();
                TRs_heard = TRs_heard+1;
                TR_data(1,TRs_heard) = TRs_heard;
                TR_data(2,TRs_heard) = TR_time;
            end
            
            theImageLocation2 = trials{15,i};
            timetest_2 = GetSecs;
            theImage2 = imloaded(find(strcmp(theImageLocation2,imlist))).images;
            imageTexture2 = Screen('MakeTexture', window, theImage2);
            Screen('DrawTexture', window, imageTexture2, [], []);
            Screen('TextSize', window, 150);
            Screen('TextColor', window, [1 0 0]);
            DrawFormattedText(window, 'SAME?','center', screenYpixels*.75,[255 0 0]);           
            [flip_same_secs] = Screen('Flip', window);
            timetest_2_delay = GetSecs-timetest_2;
            
            KbQueueRelease;
            KbQueueCreate(-1, keysOfInterest_Main);
            KbQueueFlush();        
            KbQueueStart;
            

            RT_Start = GetSecs;
            RT_Window = catch_trial_length - timetest_2_delay;
            while RT_Window > 0
                RT_elapsed = GetSecs - RT_Start;
                RT_Start = GetSecs;
                RT_Window = RT_Window - RT_elapsed;
                [~,firstpress] = KbQueueCheck();
                if firstpress(KbName('b')) > 0
                    trials(21,i) = cellstr('b');
                    trials(20,i) = num2cell((catch_trial_length - timetest_2_delay) - RT_Window);
                    WaitSecs(RT_Window);
                
                elseif firstpress(KbName('r')) > 0
                    trials(21,i) = cellstr('r');
                    trials(20,i) = num2cell((catch_trial_length - timetest_2_delay) - RT_Window);
                    WaitSecs(RT_Window);
                end
            end
            
            KbQueueRelease;
            KbQueueCreate(-1, keysOfInterest_Trigger);
            KbQueueFlush();        
            KbQueueStart;
            
            
            Screen('TextSize', window, 70);
            DrawFormattedText(window, '+', 'center','center', black);
            
            [ITI_catch_flip_secs] = Screen('Flip',window);
            
            
            
            WaitSecs(.5-delay);                 
            [~, firstpress] = KbQueueCheck();
            if firstpress(KbName('t'))>0
                TR_time = GetSecs();
                TRs_heard = TRs_heard+1;
                TR_data(1,TRs_heard) = TRs_heard;
                TR_data(2,TRs_heard) = TR_time;
            end
            
            WaitSecs((iti/2) - .20);                 
            [~, firstpress] = KbQueueCheck();
            if firstpress(KbName('t'))>0
                TR_time = GetSecs();
                TRs_heard = TRs_heard+1;
                TR_data(1,TRs_heard) = TRs_heard;
                TR_data(2,TRs_heard) = TR_time;
            end
            
            
            trials(16,i) = num2cell(flip_secs);
            trials(17,i) = num2cell(ITI_flip_secs);
            trials(18,i) = num2cell(flip_same_secs);
            trials(23,i) = num2cell(ITI_catch_flip_secs);
            
            
            
        else
            continue
        end
        

    stim_onset = flip_secs - run_start_secs;
    trials(5,i) = num2cell(stim_onset);
    trials(6,i) = num2cell(trials_begin);   
    trials(7,i) = num2cell(flip_secs);
    trials(22,i) = num2cell(ITI_flip_secs);


    end

    
    
    
    run_end_secs = GetSecs();
    
    run_timing(1,which_run) = run_number+1;
    run_timing(2,which_run) = run_start_secs;
    run_timing(3,which_run) = run_end_secs;
    run_timing(4,which_run) = run_end_secs - run_start_secs;
    
    %%%%%%%%%%%%%%%%sca;
    
        
    
    correct_catch = 0;
    total_catch = 0;
    for i = first_trial:last_trial
        if strcmpi(trials{3,i},'SAME')
            total_catch = total_catch+1;
            if counter_balance == 1 && strcmpi(trials{21,i},'r')
                correct_catch = correct_catch + 1;
            elseif counter_balance == 2 && strcmpi(trials{21,i},'b')
                correct_catch = correct_catch + 1;
            elseif counter_balance == 1 && strcmpi(trials{21,i},'b')
                continue;
            elseif counter_balance == 2 && strcmpi(trials{21,i},'r')
                continue;
            else
                continue
            end
        elseif strcmpi(trials{3,i},'DIFF')
            total_catch = total_catch+1;
            if counter_balance == 1 && strcmpi(trials{21,i},'r')
                continue;
            elseif counter_balance == 2 && strcmpi(trials{21,i},'b')
                continue;
            elseif counter_balance == 1 && strcmpi(trials{21,i},'b')
                correct_catch = correct_catch + 1;
            elseif counter_balance == 2 && strcmpi(trials{21,i},'r')
                correct_catch = correct_catch + 1;
            else
                continue
            end
        else
            continue
        end
    end
    
    feedback = sprintf('In that session, you got %d \n\n out of %d correct.',correct_catch,total_catch);
    Screen('TextSize', window, 40);
    DrawFormattedText(window, feedback, 'center','center', black);
            
    Screen('Flip',window);
    
    
    
    T = cell2table(trials(:,first_trial:last_trial)', 'VariableNames',{'Image','Format','Direction','Number','Stim_onset','Trial_begins','Raw_Flip_Secs_Stimulus','Catch_1_format',...
    'Catch_2_format','Catch_1_direction','Catch_2_direction','Catch_1_number','Catch_2_number','Catch_1_image','Catch_2_image',...
    'catch_num_1','catch_num_2','catch_num_3','catch_num_4','RT_for_Catch','Catch_Response','ITI_flip_secs','Catch_ITI_2'});
    
    if exist ((horzcat(num2str(part_num),'_',num2str(which_run),'_data.txt')),'file') == 2
        currTime = datetime('now','Format','yyyy-MM-dd''T''HHmmss');
        writetable(T,horzcat(num2str(part_num),'_', num2str(which_run),'_data_',char(currTime),'.txt'));
    else
        writetable(T,horzcat(num2str(part_num),'_', num2str(which_run),'_data.txt'));
    end
    if exist ((horzcat(num2str(part_num),'_',num2str(which_run),'.mat')),'file') == 2
        currTime = datetime('now','Format','yyyy-MM-dd''T''HHmmss');
        save(horzcat(num2str(part_num),'_',num2str(which_run),'_',char(currTime)), '-regexp', '^(?!.*imloaded).*$');
    else
        save(horzcat(num2str(part_num),'_',num2str(which_run)), '-regexp', '^(?!.*imloaded).*$');
    end
       
   

    

    
    KbQueueCreate(-1, keysOfInterest_Exp);
    KbQueueStart;
    KbQueueWait;

end
    


        



  
part = num2str(part_num);    
T = cell2table(trials(:,first_trial:last_trial)', 'VariableNames',{'Image','Format','Direction','Number','Stim_onset','Trial_begins','Raw_Flip_Secs_Stimulus','Catch_1_format',...
    'Catch_2_format','Catch_1_direction','Catch_2_direction','Catch_1_number','Catch_2_number','Catch_1_image','Catch_2_image',...
    'catch_num_1','catch_num_2','catch_num_3','catch_num_4','RT_for_Catch','Catch_Response','ITI_flip_secs','Catch_ITI_2'});

if exist ((horzcat(part,'_total_data.txt')),'file') == 2
    currTime = datetime('now','Format','yyyy-MM-dd''T''HHmmss');
    writetable(T,horzcat(part,'_total_data',char(currTime),'.txt'));
else
    writetable(T,horzcat(part,'_total_data.txt'));
end

if exist ((horzcat(num2str(part_num),'_total.mat')),'file') == 2
    currTime = datetime('now','Format','yyyy-MM-dd''T''HHmmss');
    save(horzcat(num2str(part_num),'_total_',char(currTime)), '-regexp', '^(?!.*imloaded).*$');
else
    save(horzcat(num2str(part_num),'_total.mat'), '-regexp', '^(?!.*imloaded).*$');
end


%% Clear temporary variables



sca;