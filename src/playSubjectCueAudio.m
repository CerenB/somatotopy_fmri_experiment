function [thisBlock]  = playSubjectCueAudio(cfg, iBlock, thisBlock)

    %% Get parameters        
    soundData = cfg.soundData;
    
    % set block name
    block = cfg.design.blockOrder(iBlock);
    % OLD ORDER [1:7] is hand, feet, nose, tongue, lips, cheek, forehead
    % NEW ORDER [1:7] is hand, feet, lips, tongue, forehead

    switch block
        case 1
            fieldName = 'H';
        case 2
            fieldName = 'Fe';
        case 3
            fieldName = 'L';
        case 4
            fieldName = 'To';
        case 5
            fieldName = 'Fo';
    end

    soundCh1 = soundData.(fieldName);
    soundCh2 = soundCh1;
    
    % amplify to decrease the sound level for participant
    if isfield(cfg, 'ampSubject')
        soundCh1 = cfg.ampSubject .* soundCh1;
    end
    
    % give silence to experimenter's ear
    if cfg.audio.doSplitHeadphone
        soundCh2 = soundData.silence; 
    end
    
    % it will play the name of the block and wait till rest of the gap
    % Start the sound presentation
    PsychPortAudio('FillBuffer', cfg.audio.pahandle, [soundCh2; soundCh1]);
    PsychPortAudio('Start', cfg.audio.pahandle,cfg.audio.cueSubRepeat);
    onset = GetSecs;
    
    % Get the end time
    waitForEndOfPlayback = 1; 
    [onsetEnd, ~, ~, estStopTime] = PsychPortAudio('Stop', cfg.audio.pahandle, ...
                                                waitForEndOfPlayback);
    duration = estStopTime - onsetEnd;

    % save them into a structure
    thisBlock.cueSubOnset = onset - cfg.experimentStart;
    thisBlock.cueSubOnsetEnd = estStopTime - cfg.experimentStart;
    thisBlock.cueSubDuration = duration;
            
end