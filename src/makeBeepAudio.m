function [cfg] = makeBeepAudio(cfg)

% insert the soundData (audio beeps with 250ms long) with silence of 
% the rest of trial/event duration 
% then make audio with sounds + event silences


fs = cfg.audio.fs(1);

amplitude = cfg.amp;

% refractor to on the moment- creating a pure tone with a given frequency
% and duration as below:
% t = [0 : round(cfg.pattern.gridIOIs * cfg.fs)-1]/cfg.fs;
% % create carrier
% s = sin(2*pi*currF0*t);

% take no-target beep
soundNoTarget = cfg.soundData.NT(1,:);

% target event
soundTarget = cfg.soundData.T(1,:);

% % length of beep
% beepDuration = cfg.timing.beepDuration; 

% embed the no-target beep into 1s long trial
% while embed two target sounds within 1s

% whole length of trial/event
eventDuration = cfg.timing.eventDuration; 
    

t = [0 : round(eventDuration * fs)-1] / fs; 
eventNoTarget = zeros(1,length(t));
eventTarget = eventNoTarget;
idxStart = length(soundTarget)+ 1 + length(soundTarget);
idxEnd = 3 * length(soundTarget);


%insert sound event
eventNoTarget(1:length(soundNoTarget)) = soundNoTarget;
eventNoTarget = eventNoTarget.*amplitude;

eventTarget(1:length(soundTarget)) = soundTarget;
eventTarget(idxStart:idxEnd) = soundTarget;
eventTarget = eventTarget.*amplitude;

cfg.soundData.eventTarget = eventTarget;
cfg.soundData.eventNoTarget = eventNoTarget;

% % to visualise 1 pattern
% figure; plot(t,eventTarget);

end 