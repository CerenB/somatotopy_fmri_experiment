function onset  = playBeepAudio(cfg, thisEvent)

    %% Get parameters        
    soundData = cfg.soundData;
    fieldName = 'eventNoTarget';

    if thisEvent.soundTarget == 1
        fieldName = 'eventTarget';
    end
    
    soundCh1 = soundData.(fieldName);
    soundCh2 = soundCh1;
    
    % amplify more for the experimenter - if using a crappy NNL headphones
    if isfield(cfg, 'ampExperimenter')
        soundCh1 = cfg.ampExperimenter.* soundCh1;
    end
    
    % give silence to subject's ear
    if ~cfg.beepForParticipant
        soundCh2 = soundData.silenceBeep;     
    end
    
    % Start the sound presentation
    PsychPortAudio('FillBuffer', cfg.audio.pahandle, [soundCh1; soundCh2]);
    onset = PsychPortAudio('Start', cfg.audio.pahandle);
   % onset = GetSecs;

    % PsychPortAudio('Start', pahandle, repetitions, startCue, waitForDeviceStart);

%     
%     %% play sequences
%     % fill the buffer % start sound presentation
%     PsychPortAudio('FillBuffer', cfg.audio.pahandle, ...
%         [currSeq.outAudio;currSeq.outAudio]);
%     
%     % wait for baseline delays and then start the audio
%     onset = PsychPortAudio('Start', cfg.audio.pahandle, [], ...
%         cfg.experimentStart + cfg.timing.onsetDelay,1);
    
    
end