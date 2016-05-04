
%path = 'C:\Users\chatterjeelab\Documents\Arrows_FMRI\Behavioral_Exp v03\';
path = 'C:\Users\stweis\SkyDrive\MVPA_ARROWS\FMRI_Materials\Behavioral_Exp v03';
rng shuffle;

addpath(path);
addpath(strcat(path,'\FINAL_24_ALL'));
%get sequence
part_num = input('What is the participant ID? ');
counter_balance = input('What is the counter_balance? (1 for Right is Correct) ');

while isnumeric(counter_balance) && (str2double(counter_balance) < 1 || str2double(counter_balance) > 2)
    counter_balance = input('Sorry. Enter either 1 or 2. ');
end


file = horzcat(path,'\FMRI_Experiment_Scripts\',num2str(part_num),'.txt');
fileID = fopen(file,'r');
[singleBlanks] = fscanf(fileID, ['%d' ',']);
singleBlanks = reshape(singleBlanks',1,length(singleBlanks));


%%Double the Blanks
count = 0;
zeroList = [];
for i = 1:length(singleBlanks)
    if singleBlanks(i) == 0
        zeroList = [zeroList i];
    end
end
doubleBlanks = zeros(1,length(singleBlanks)+length(zeroList));

for i = 1:length(zeroList)
    count = count+1;
    if i == 1
        doubleBlanks(1:zeroList(1)) = singleBlanks(1:zeroList(1));
    elseif i ~= length(zeroList)+1
        doubleBlanks(zeroList(i-1)+count:zeroList(i)+count) = singleBlanks(zeroList(i-1):zeroList(i));
    else
        continue
    end
end
doubleBlanks = doubleBlanks([1:(zeroList(1)+1), (zeroList(1)+3):end]);
doubleBlanks(length(doubleBlanks)+1) = 0;
doubleBlanks(zeroList(i)+count:end) = singleBlanks(zeroList(i):end);

catch_same_total = 1;
catch_diff_total = 1;

for i = 1:length(doubleBlanks)
    if doubleBlanks(i) == 23
        catch_diff_total = catch_diff_total + 1;
    elseif doubleBlanks(i) == 22
        catch_same_total = catch_same_total + 1;
    else
        continue
    end
end

%%Create list of Trials
trials = cell(23,length(doubleBlanks));

%Create catch trials
catchListDir = {'ahead','left','right','shLeft','shRight','slLeft','slRight'};
PermD = randperm(length(catchListDir));
catchListDir = catchListDir(PermD);
numD = 7;
catchListFormat = {'image', 'image' 'image','schema','schema','schema','word','word','word';
    'schema','image','word','schema','word','image','schema','word','image'};
PermF = randperm(length(catchListFormat));
catchListFormat = catchListFormat(:,PermF);
numF = 5;
Perm1 = randperm(length(catchListFormat));
extraCatchFormat=catchListFormat(:,Perm1);
extraCatchFormat = extraCatchFormat(:,1:4);
catchTrialsF = reshape(repmat(catchListFormat,numF,1),[2,45]);
catchTrialsF = horzcat(catchTrialsF,extraCatchFormat);
Perm2 = randperm(length(catchTrialsF));
catchTrials = catchTrialsF(:,Perm2);
catchTrialsD = cell(2,49);
for i = 1:7
    catchTrialsD(1,(i*7)-6:i*7) = catchListDir;
    catchTrialsD(2,(i*7)-6:i*7) = catchListDir(i);
end

Perm4 = randperm(length(catchTrialsD));
catchTrialsD = catchTrialsD(:,Perm4);


for i = 1:length(catchTrialsD)
    if i < catch_same_total
        if strcmpi(catchTrialsD{1,i},catchTrialsD{2,i})
            catch_same_total = catch_same_total + 1;
        end
    else
        catchTrialsD{1,i} = catchTrialsD{2,i};
    end
end

%This assigns random exemplars to each catch trial, ensuring that they are
%not the same exact example. 
catchTrials(3:4,:) = catchTrialsD;
Perm3 = randperm(length(catchTrials));
catchTrials = catchTrials(:,Perm3);
for i = 1:length(catchTrials)
    catchTrials(5,i) = num2cell(randi([1,24]));
    catchTrials(6,i) = num2cell(randi([1,24]));
    if eq(catchTrials{5,i},catchTrials{6,i})
        if catchTrials{5,i} == 24
            catchTrials(6,i) = num2cell(catchTrials{5,i}-1);
        else
            catchTrials(6,i) = num2cell(catchTrials{5,i} + 1);
        end
    end
    catchTrials(7,i) = cellstr(strcat(catchTrials{3,i},'_',catchTrials{1,i},'_',num2str(catchTrials{5,i}),'.png'));
    catchTrials(8,i) = cellstr(strcat(catchTrials{4,i},'_',catchTrials{2,i},'_',num2str(catchTrials{6,i}),'.png'));
end




catchTrialsSame = cell(8,49);
catchTrialsDiff = cell(8,49);
catchCount = 1;
catchCount_Same = 1;
catchCount_Diff =  1;
for i = 1:length(catchTrials(1,:))
    if strcmpi(catchTrials{3,i},catchTrials{4,i})
        catchTrialsSame(:,catchCount_Same) = catchTrials(:,catchCount);
        catchCount_Same = catchCount_Same + 1;
    else
        catchTrialsDiff(:,catchCount_Diff) = catchTrials(:,catchCount); 
        catchCount_Diff = catchCount_Diff + 1;
    end
    catchCount = catchCount + 1;
end


catchCount_Same = 1;
catchCount_Diff = 1;
for i = 1:length(doubleBlanks)
    if doubleBlanks(i) == 0
        trials(1:4,i) = cellstr('NULL');
    elseif 0<doubleBlanks(i)&&doubleBlanks(i)<8
        trials(1:2,i) = cellstr('image');
    elseif 7<doubleBlanks(i)&&doubleBlanks(i)<15
        trials(1:2,i) = cellstr('word');
    elseif 14<doubleBlanks(i)&&doubleBlanks(i)<22
        trials(1:2,i) = cellstr('schema');
    elseif doubleBlanks(i) == 23
        trials(1:2,i) = cellstr('CATCH');
        trials(8:15,i) = catchTrialsDiff(:,catchCount_Diff);
        catchCount_Diff = catchCount_Diff+1;
        trials(3,i) = cellstr('DIFF');
    else
        trials(1:2,i) = cellstr('CATCH');
        trials(8:15,i) = catchTrialsSame(:,catchCount_Same);
        catchCount_Same = catchCount_Same+1;
        trials(3,i) = cellstr('SAME');
        trials(10,i) = trials(11,i);
        if trials{12,i} == trials{13,i}
            trials{13,i} = trials{13,i} + 1;
        end
        trials(14,i) = cellstr(strcat(trials{10,i},'_',trials{8,i},'_',num2str(trials{12,i}),'.png'));
    end
end








for i = 1:length(trials)
    if doubleBlanks(i) == 1 || doubleBlanks(i) == 8 || doubleBlanks(i) == 15
        trials(1,i) = strcat('ahead_',trials(1,i));
        trials(3,i) = cellstr('ahead');
    elseif doubleBlanks(i) == 2 || doubleBlanks(i) == 9 || doubleBlanks(i) == 16
        trials(1,i) = strcat('left_',trials(1,i));
        trials(3,i) = cellstr('left');
    elseif doubleBlanks(i) == 3 || doubleBlanks(i) == 10 || doubleBlanks(i) == 17
        trials(1,i) = strcat('right_',trials(1,i));   
        trials(3,i) = cellstr('right');
    elseif doubleBlanks(i) == 4 || doubleBlanks(i) == 11 || doubleBlanks(i) == 18
        trials(1,i) = strcat('shLeft_',trials(1,i));
        trials(3,i) = cellstr('shLeft');
    elseif doubleBlanks(i) == 5 || doubleBlanks(i) == 12 || doubleBlanks(i) == 19
        trials(1,i) = strcat('shRight_',trials(1,i)); 
        trials(3,i) = cellstr('shRight');
    elseif doubleBlanks(i) == 6 || doubleBlanks(1,i) == 13 || doubleBlanks(i) == 20
        trials(1,i) = strcat('slLeft_',trials(1,i));
        trials(3,i) = cellstr('slLeft');
    elseif doubleBlanks(i) == 7 || doubleBlanks(i) == 14 || doubleBlanks(i) == 21
        trials(1,i) = strcat('slRight_',trials(1,i));
        trials(3,i) = cellstr('slRight');
    else
        continue
    end
end

randTrials = zeros(21,25);

for i = 1:21
    randTrials(i,1:24) = Shuffle(1:24);
    randTrials(i,25) = Randi(24);
end
counter = ones(1,21);
for i = 1:length(trials)
    if strcmp(trials(2,i),'image') && strcmp(trials(3,i),'ahead')
        trials(1,i) = strcat(trials(1,i),'_',num2str(randTrials(1,counter(1))));
        trials(4,i) = num2cell(randTrials(1,counter(1)));
        counter(1) = counter(1)+1;
    elseif strcmp(trials(2,i),'image') && strcmp(trials(3,i),'left')
        trials(1,i) = strcat(trials(1,i),'_',num2str(randTrials(2,counter(2))));
        trials(4,i) = num2cell(randTrials(2,counter(2)));
        counter(2) = counter(2)+1;
    elseif strcmp(trials(2,i),'image') && strcmp(trials(3,i),'right')
        trials(1,i) = strcat(trials(1,i),'_',num2str(randTrials(3,counter(3))));
        trials(4,i) = num2cell(randTrials(3,counter(3)));
        counter(3) = counter(3)+1;
    elseif strcmp(trials(2,i),'image') && strcmp(trials(3,i),'shLeft')
        trials(1,i) = strcat(trials(1,i),'_',num2str(randTrials(4,counter(4))));
        trials(4,i) = num2cell(randTrials(4,counter(4)));
        counter(4) = counter(4)+1;
    elseif strcmp(trials(2,i),'image') && strcmp(trials(3,i),'shRight')
        trials(1,i) = strcat(trials(1,i),'_',num2str(randTrials(5,counter(5))));
        trials(4,i) = num2cell(randTrials(5,counter(5)));
        counter(5) = counter(5)+1;
    elseif strcmp(trials(2,i),'image') && strcmp(trials(3,i),'slLeft')
        trials(1,i) = strcat(trials(1,i),'_',num2str(randTrials(6,counter(6))));
        trials(4,i) = num2cell(randTrials(6,counter(6)));
        counter(6) = counter(6)+1;
    elseif strcmp(trials(2,i),'image') && strcmp(trials(3,i),'slRight')
        trials(1,i) = strcat(trials(1,i),'_',num2str(randTrials(7,counter(7))));
        trials(4,i) = num2cell(randTrials(7,counter(7)));
        counter(7) = counter(7)+1;
    elseif strcmp(trials(2,i),'schema') && strcmp(trials(3,i),'ahead')
        trials(1,i) = strcat(trials(1,i),'_',num2str(randTrials(8,counter(8))));
        trials(4,i) = num2cell(randTrials(8,counter(8)));
        counter(8) = counter(8)+1;
    elseif strcmp(trials(2,i),'schema') && strcmp(trials(3,i),'left')
        trials(1,i) = strcat(trials(1,i),'_',num2str(randTrials(9,counter(9))));
        trials(4,i) = num2cell(randTrials(9,counter(9)));
        counter(9) = counter(9)+1;
    elseif strcmp(trials(2,i),'schema') && strcmp(trials(3,i),'right')
        trials(1,i) = strcat(trials(1,i),'_',num2str(randTrials(10,counter(10))));
        trials(4,i) = num2cell(randTrials(10,counter(10)));
        counter(10) = counter(10)+1;
    elseif strcmp(trials(2,i),'schema') && strcmp(trials(3,i),'shLeft')
        trials(1,i) = strcat(trials(1,i),'_',num2str(randTrials(11,counter(11))));
        trials(4,i) = num2cell(randTrials(11,counter(11)));
        counter(11) = counter(11)+1;
    elseif strcmp(trials(2,i),'schema') && strcmp(trials(3,i),'shRight')
        trials(1,i) = strcat(trials(1,i),'_',num2str(randTrials(12,counter(12))));
        trials(4,i) = num2cell(randTrials(12,counter(12)));
        counter(12) = counter(12)+1;
    elseif strcmp(trials(2,i),'schema') && strcmp(trials(3,i),'slLeft')
        trials(1,i) = strcat(trials(1,i),'_',num2str(randTrials(13,counter(13))));
        trials(4,i) = num2cell(randTrials(13,counter(13)));
        counter(13) = counter(13)+1;
    elseif strcmp(trials(2,i),'schema') && strcmp(trials(3,i),'slRight')
        trials(1,i) = strcat(trials(1,i),'_',num2str(randTrials(14,counter(14))));
        trials(4,i) = num2cell(randTrials(14,counter(14)));
        counter(14) = counter(14)+1;
    elseif strcmp(trials(2,i),'word') && strcmp(trials(3,i),'ahead')
        trials(1,i) = strcat(trials(1,i),'_',num2str(randTrials(15,counter(15))));
        trials(4,i) = num2cell(randTrials(15,counter(15)));
        counter(15) = counter(15)+1;
    elseif strcmp(trials(2,i),'word') && strcmp(trials(3,i),'left')
        trials(1,i) = strcat(trials(1,i),'_',num2str(randTrials(16,counter(16))));
        trials(4,i) = num2cell(randTrials(16,counter(16)));
        counter(16) = counter(16)+1;
    elseif strcmp(trials(2,i),'word') && strcmp(trials(3,i),'right')
        trials(1,i) = strcat(trials(1,i),'_',num2str(randTrials(17,counter(17))));
        trials(4,i) = num2cell(randTrials(17,counter(17)));
        counter(17) = counter(17)+1;
    elseif strcmp(trials(2,i),'word') && strcmp(trials(3,i),'shLeft')
        trials(1,i) = strcat(trials(1,i),'_',num2str(randTrials(18,counter(18))));
        trials(4,i) = num2cell(randTrials(18,counter(18)));
        counter(18) = counter(18)+1;
    elseif strcmp(trials(2,i),'word') && strcmp(trials(3,i),'shRight')
        trials(1,i) = strcat(trials(1,i),'_',num2str(randTrials(19,counter(19))));
        trials(4,i) = num2cell(randTrials(19,counter(19)));
        counter(19) = counter(19)+1;
    elseif strcmp(trials(2,i),'word') && strcmp(trials(3,i),'slLeft')
        trials(1,i) = strcat(trials(1,i),'_',num2str(randTrials(20,counter(20))));
        trials(4,i) = num2cell(randTrials(20,counter(20)));
        counter(20) = counter(20)+1;
    elseif strcmp(trials(2,i),'word') && strcmp(trials(3,i),'slRight')
        trials(1,i) = strcat(trials(1,i),'_',num2str(randTrials(21,counter(21))));
        trials(4,i) = num2cell(randTrials(21,counter(21)));
        counter(21) = counter(21)+1;
    else
        continue
    end
end



%doublecheck
for trial = 1:length(trials)
    if strcmpi(trials{2,trial},'CATCH')
        if ischar(trials{8,trial}) && ischar(trials{9,trial})
            continue
        elseif strcmpi(trials{3,trial},'DIFF')
            trials(8:9,trial) = catchListFormat(:,randi([1,9]));
            dir1 = randi([1,7]);
            trials(10,trial) = catchListDir(1,dir1);
            catchListDirRest = catchListDir;
            catchListDirRest(:,dir1) = [];
            dir2 = randi([1,6]);
            trials(11,trial) = catchListDir(1,dir2);
            trials{12,trial} = randi([1,24]);
            trials{13,trial} = randi([1,24]);
            trials(14,trial) = cellstr(strcat(trials{10,trial},'_',trials{8,trial},'_',num2str(trials{12,trial}),'.png'));
            trials(15,trial) = cellstr(strcat(trials{11,trial},'_',trials{9,trial},'_',num2str(trials{13,trial}),'.png'));
            
        elseif strcmpi(trials{3,trial},'SAME')
            trials(8:9,trial) = catchListFormat(:,randi([1,9]));
            dir1 = randi([1,7]);
            trials(10,trial) = catchListDir(1,dir1);
            trials(11,trial) = catchListDir(1,dir1);
             trials{12,trial} = randi([1,24]);
            trials{13,trial} = randi([1,24]);
            trials(14,trial) = cellstr(strcat(trials{10,trial},'_',trials{8,trial},'_',num2str(trials{12,trial}),'.png'));
            trials(15,trial) = cellstr(strcat(trials{11,trial},'_',trials{9,trial},'_',num2str(trials{13,trial}),'.png'));
        end
    end
end



%%PARAMS
trials_length = 1;
iti = 2;
run_length = 100;



save(horzcat(num2str(part_num),'_trials'));
