
% Clear the workspace
close all;
sca;




path = 'C:\Users\chatterjeelab\Documents\Arrows_FMRI\Behavioral_Exp v03';
addpath(path);
addpath(strcat(path,'\stimuli_named'));



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

cd('C:\Users\chatterjeelab\Documents\Arrows_FMRI\Behavioral_Exp v03\Extra_Stimuli');
practiceImsDir = dir('*png*');
tempIms = struct2cell(practiceImsDir);
practiceIms = tempIms(1,:)';
practiceIms = Shuffle(practiceIms);

keysOfInterest_Exp=zeros(1,256);
keysOfInterest_Exp(KbName('c'))=1;
keysOfInterest_Exp(KbName('f'))=1;
keysOfInterest_Exp(KbName('t'))=1;
keysOfInterest_Exp(KbName('y'))=1;
keysOfInterest_Exp(KbName('u'))=1;
keysOfInterest_Exp(KbName('j'))=1;
keysOfInterest_Exp(KbName('m'))=1;

responses = cell(1,length(practiceIms));

splitIms = cell(2,length(practiceIms));

instructions = ['You will see a series of spatial directions. \n\n' ... 
'Your job is to indicate which spatial direction you see. \n\n' ...
'There are 7 possible spatial directions. \n\n' ...
'Sharp Right, Right, Slight Right, Ahead...\n\n'...
'Slight Left, Left, and Sharp Left. \n\n'...
'Imagine the M J U Y T F C keys represent an arrow pad.\n\n'...
'For example, F = Left, U = Slight Right, and Y = Ahead.\n\n'...
'Use those keys to respond. You have as long as you like. \n\n'];

Screen('TextSize', window, 35);


DrawFormattedText(window, instructions, 'center', 'center', [0 0 0]);
Screen('Flip', window);
KbWait();
        
        
for i = 1:length(practiceIms)
    splitIms{1,i} = strsplit(practiceIms{i},'_');
    responses{1,i} = splitIms{1,i}{1};
end


KbQueueCreate(-1, keysOfInterest_Exp);
for i = 1:length(practiceIms)
    
    theImageLocation = (practiceIms{i});
    theImage = imread(theImageLocation);
    imageTexture = Screen('MakeTexture', window, theImage);
    Screen('DrawTexture', window, imageTexture,[],[],0);
    Screen('Flip', window);
    KbQueueStart;
    pressed = 0;
    while ~pressed
        [pressed, firstPress] = KbQueueCheck();
        if firstPress(KbName('c'))
            responses{2,i} = 'shLeft';
        elseif firstPress(KbName('f'))
            responses{2,i} = 'left';
        elseif firstPress(KbName('t'))
            responses{2,i} = 'slLeft';
        elseif firstPress(KbName('y'))
            responses{2,i} = 'ahead';
        elseif firstPress(KbName('u'))
            responses{2,i} = 'slRight';
        elseif firstPress(KbName('j'))
            responses{2,i} = 'right';
        elseif firstPress(KbName('m'))
            responses{2,i} = 'shRight';
        else
            continue
        end
    WaitSecs(.01);
    end
end

average = 0;
total = 0;
for i = 1:length(responses)
    if strcmpi(responses{1,i},responses{2,i})
        average = average+1;
        total = total+1;
    else
        total = total+1;
    end
end

correct_info = sprintf('You got %d of %d correct. Please get your experimenter.',average,total);
DrawFormattedText(window, correct_info, 'center', 'center', [0 0 0]);
Screen('Flip', window);
KbQueueWait();





sca;










