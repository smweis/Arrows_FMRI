 
% Clear the workspace
close all;
sca;

%reseed the random number generator
rng shuffle;

path = 'C:\Users\chatterjeelab\Documents\Arrows_FMRI\Behavioral_Exp v03';
addpath(path);
addpath(strcat(path,'\stimuli_named'));

part_num = input('What is the participant ID? ');
counter_balance = input('What is the counter_balance? (1 for Right is Correct) ');

while isnumeric(counter_balance) && (counter_balance < 1 || counter_balance > 2)
    counter_balance = input('Sorry. Enter either 1 or 2. ');
end

%Prep Stimuli Presentation and Screens

priorityLevel = MaxPriority('GetSecs', 'KbCheck', 'KbWait', 'GetClicks', 'KbQueueCheck','KbQueueWait','Screen');
KbName('UnifyKeyNames');


screens = Screen('Screens');
screenNumber = 0;
%Screen('TextFont', window, 'Helvetica');
% 
% Screen('Preference', 'VisualDebugLevel',0);
% Screen('Preference', 'SkipSyncTests', 1);

white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;
inc = white - grey;

% Open an on screen window

[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

%PREFERENCES
Screen('TextFont', window, 'Helvetica');

destRect = zeros(63,4);
for i = 1:63
    rightEdge = randi([xCenter-500,xCenter+500])+400;
    leftEdge = rightEdge-800;
    bottomEdge = randi([yCenter-125,yCenter+125])+400;
    topEdge = bottomEdge-800;
    destRect(i,1) = leftEdge;
    destRect(i,2) = topEdge;
    destRect(i,3) = rightEdge;
    destRect(i,4) = bottomEdge;
end

cd('C:\Users\chatterjeelab\Documents\Arrows_FMRI\Behavioral_Exp v03\Extra_Stimuli');
practiceImsDir = dir('*jpg*');
tempIms = struct2cell(practiceImsDir);
practiceIms = tempIms(1,:)';
practiceIms = Shuffle(practiceIms);


responses = cell(1,length(practiceIms));

splitIms = cell(2,length(practiceIms));

if counter_balance == 1
    
    instructions = ['You will see a series of spatial directions. \n\n' ... 
    'Your job is to remember the spatial direction that appears. \n\n' ...
    'For some of the trials, another spatial direction will appear \n\n' ...
    'with the question "SAME?"\n\n' ...
    'You must press the J key \n\n' ...
    'to indicate a match of spatial directions,\n\n' ... 
    'and the F key to indicate a mistmatch. \n\n' ...
    'Be sure to respond as quickly as you can. \n\n' ... 
    'Press any key when you are ready to continue. \n\n'];
else
    instructions = ['You will see a series of spatial directions. \n\n' ... 
    'Your job is to remember the spatial direction that appears. \n\n' ...
    'For some of the trials, another spatial direction will appear \n\n' ...
    'with the question "SAME?"\n\n' ...
    'You must press the F key \n\n' ...
    'to indicate a match of spatial directions,\n\n' ... 
    'and the J key to indicate a mistmatch. \n\n' ...
    'Be sure to respond as quickly as you can. \n\n' ... 
    'Press any key when you are ready to continue. \n\n'];
end

Screen('TextSize', window, 35);


DrawFormattedText(window, instructions, 'center', 'center', [0 0 0]);
Screen('Flip', window);
KbWait();

keysWanted = [70 74];

keysOfInterest_Main=zeros(1,256);
keysOfInterest_Main(KbName('t'))=1;
keysOfInterest_Main(KbName('j'))=1;
keysOfInterest_Main(KbName('f'))=1;

keysOfInterest_Trigger=zeros(1,256);
keysOfInterest_Trigger(KbName('t'))=1;

keysOfInterest_Exp=zeros(1,256);
keysOfInterest_Exp(KbName('space'))=1;
        
        
for i = 1:length(practiceIms)
    splitIms{1,i} = strsplit(practiceIms{i},'_');
    responses{1,i} = splitIms{1,i}{1};
end

rand_trials = zeros(length(practiceIms));
for i = 1:length(practiceIms)
    rand_trials(i,1) = randi(5);
end

catch_images = cell(length(practiceIms),6);

KbQueueCreate(-1, keysOfInterest_Exp);
for i = 1:length(practiceIms)
    if rand_trials(i,1) ~= 1
        theImageLocation = (practiceIms{i});
        theImage = imread(theImageLocation);
        catch_images(i,1) = cellstr(theImageLocation);
        imageTexture = Screen('MakeTexture', window, theImage);
        Screen('DrawTexture', window, imageTexture, [], destRect(i,:), 0);
        Screen('Flip', window);
        WaitSecs(1);
        Screen('TextSize', window, 70);
        DrawFormattedText(window, '+', 'center','center', black);
        Screen('Flip',window);
        WaitSecs(2);
    else
        
        theImageLocation = (practiceIms{i});
        theImage = imread(theImageLocation);
        imageTexture = Screen('MakeTexture', window, theImage);
        Screen('DrawTexture', window, imageTexture, [], destRect(i,:), 0);
        Screen('Flip', window);
        WaitSecs(1);
        Screen('TextSize', window, 70);
        DrawFormattedText(window, '+', 'center','center', black);
        Screen('Flip',window);
        WaitSecs(1);
        catch_im = randi(62);
        theImageLocation2 = (practiceIms{catch_im});
        catch_images(i,2) = cellstr(theImageLocation2);
        catch_images(i,1) = cellstr(theImageLocation);
        theImage = imread(theImageLocation2);
        imageTexture2 = Screen('MakeTexture', window, theImage);
        Screen('DrawTexture', window, imageTexture2, [], [], 0);
        Screen('TextSize', window, 150);
        Screen('TextColor', window, [1 0 0]);
        DrawFormattedText(window, 'SAME?','center', screenYpixels*.75,[255 0 0]);           
        Screen('Flip', window);
        RT_Window = GetSecs+2.5;
        [RT_secs, kbData] = KbWait([],2,RT_Window);
        if RT_secs == 0
            break
        else
            WaitSecs(RT_Window-RT_secs);
            for j = 1:length(keysWanted)
                if kbData(keysWanted(j)) == 1
                    keyPressed = keysWanted(j);
                    catch_images(i,3) = cellstr(KbName(keyPressed));
                end
            end
        end
        Screen('TextSize', window, 70);
        DrawFormattedText(window, '+', 'center','center', black);
        Screen('Flip',window);
        WaitSecs(1.5);
    end
end

for i = 1:length(practiceIms)
    targetStr = catch_images(i,1);
    [name,address] = strtok(targetStr,'_');
    targetImage = name;
    catchStr = catch_images(i,2);
    [nameC,addressC] = strtok(catchStr,'_');
    catchImage = nameC;
    if isempty(catch_images{i,2})
        catch_images{i,4} = '';
        catch_images{i,5} = 0;
        catch_images{i,6} = 0;
    elseif strcmpi(targetImage,catchImage) 
        catch_images{i,4} = 'SAME';
        catch_images{i,6} = 1;
        if counter_balance == 1 && strcmpi(catch_images(i,3),'j')
            catch_images(i,5) = num2cell(1);
        elseif counter_balance == 2 && strcmpi(catch_images(i,3),'f')
            catch_images(i,5) = num2cell(1);
        elseif counter_balance == 1 && strcmpi(catch_images(i,3),'f')
            catch_images(i,5) = num2cell(0);
        elseif counter_balance == 2 && strcmpi(catch_images(i,3),'j')
            catch_images(i,5) = num2cell(0);
        else
            catch_images(i,5) = num2cell(0);
        end
    else
        catch_images{i,4} = 'DIFFERENT';
        catch_images{i,6} = 1;
        if counter_balance == 1 && strcmpi(catch_images(i,3),'f')
            catch_images(i,5) = num2cell(1);
        elseif counter_balance == 2 && strcmpi(catch_images(i,3),'j')
            catch_images(i,5) = num2cell(1);
        elseif counter_balance == 1 && strcmpi(catch_images(i,3),'j')
            catch_images(i,5) = num2cell(0);
        elseif counter_balance == 2 && strcmpi(catch_images(i,3),'f')
            catch_images(i,5) = num2cell(0);
        else
            catch_images(i,5) = num2cell(0);
        end
    end
end

correct = sum(cellfun(@double,catch_images(:,5)));
total = sum(cellfun(@double,catch_images(:,6)));

X=sprintf('You got %d correct out of %d',correct,total);
disp(X);


cd('C:\Users\chatterjeelab\Documents\Arrows_FMRI\Behavioral_Exp v03\FMRI_Experiment_Scripts');

save(horzcat(num2str(part_num),'_practice'));




sca;










