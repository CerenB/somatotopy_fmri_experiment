function s = loadAndMakeBeepAudio(cfg)

% insert the soundData (audio beeps with 250ms long) with silence of 
% the rest of event duration 

% load sounds 
[cfg] = loadAudioFiles(cfg);

% then make audio with sounds + event silences
fs = cfg.audio.fs(1);

beepDuration = cfg.timing.beepDuration;   
eventDuration = cfg.timing.eventDuration; % second
interEventInterval = cfg.timing.ISI; % Time between events in secs
    

t = [0 : eventDuration * fs] / fs; 
s = zeros(1,length(t));
  
%insert sound event
s(0:length(beepDuration * fs)) = soundEvent;
soundEvent = soundEvent.*currAmp;

end 