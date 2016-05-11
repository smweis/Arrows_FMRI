function [] = multipleParticipantTrialMaker(participants)

%%Sample usage: multipleParticipantTrialMaker(110:130)

for participant = 1:length(participants)
    arrows_trial_maker_fixed_catch(participants(participant));
end

