function onset  = playCueAudio(cfg, thisBlock)

    %% Get parameters        
    soundData = cfg.soundData;

    block = thisBlock.name; %hand, feet, forehead, nose, cheek, tongue, lips

    
    %%
        
    switch block
        case 1
            fieldName = 'H';
        case 2
            fieldName = 'Fe';
        case 3
            fieldName = 'Fo';
        case 4
            fieldName = 'N';
        case 5
            fieldName = 'C';
        case 6
            fieldName = 'To';
        case 7
            fieldName = 'L';
    end

    sound = soundData.(fieldName);

    %% 
    % it will play the name of the block and wait till rest of the gap
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