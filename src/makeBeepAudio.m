function [cfg] = makeBeepAudio(cfg)

% insert the soundData (audio beeps with 250ms long) with silence of 
% the rest of trial/event duration 
% then make audio with sounds + event silences


fs = cfg.audio.fs(1);
amplitude = cfg.amp;

% take no-target beep
soundNoTarget = cfg.soundData.NT(1,:);

% % length of beep
% beepDuration = cfg.timing.beepDuration; 

% embed the no-target beep into 1s long trial
% while embed two target sounds within 1s

% whole length of trial/event
eventDuration = cfg.timing.eventDuration;
   
% make time vector
t = [0 : round(eventDuration * fs)-1] / fs; 

% preallocate to silence/zeros as default
eventNoTarget = zeros(1,length(t));

%insert no-target sound event
eventNoTarget(1:length(soundNoTarget)) = soundNoTarget;

    
% arrange the almplitude
eventNoTarget = eventNoTarget.*amplitude;

% save them
cfg.soundData.eventNoTarget = eventNoTarget;

% easy fix for now - 
% omitting the target = going to passive 
if cfg.audio.noTask
    cfg.soundData.eventTarget = eventNoTarget;
end

% % to visualise 1 pattern
% figure; plot(t,eventTarget);

end 