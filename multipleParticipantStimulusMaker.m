function [] = multipleParticipantStimulusMaker(participants)

%%Sample usage: multipleParticipantTrialMaker(110:130)

for participant = 1:length(participants)
    backgroundMakerAll(participants(participant));
end

