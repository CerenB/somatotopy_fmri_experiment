function onset  = playBeepAudio(cfg, thisEvent)

    %% Get parameters        
    soundData = cfg.soundData;
    fieldName = NT;

    if thisEvent.soundTarget == 1
        fieldName = [fieldName 'T'];
    end
    
    sound = soundData.(fieldName);

    
    % Start the sound presentation
    PsychPortAudio('FillBuffer', cfg.audio.pahandle, sound);
    PsychPortAudio('Start', cfg.audio.pahandle);
    onset = GetSecs;

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