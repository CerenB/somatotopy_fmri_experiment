function [thisBlock]  = playSubjectCueAudio(cfg, iBlock, thisBlock)

    %% Get parameters        
    soundData = cfg.soundData;
    
    % set block name
    block = cfg.design.blockOrder(iBlock);
    % ORDER [1:7] is hand, feet, nose, tongue, lips, cheek, forehead
    % NEW ORDER [1:7] is hand, feet, lips, tongue, nose, cheek, forehead

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
            fieldName = 'N';
        case 6
            fieldName = 'C';
        case 7
            fieldName = 'Fo';
    end

    soundCh1 = soundData.(fieldName);
    soundCh2 = soundCh1;
    
    % give silence to experimenter's ear
    if cfg.audio.doSplitHeadphone
        soundCh2 = soundData.silence; 
    end
    
    % it will play the name of the block and wait till rest of the gap
    % Start the sound presentation
    PsychPortAudio('FillBuffer', cfg.audio.pahandle, [soundCh2; soundCh1]);
    PsychPortAudio('Start', cfg.audio.pahandle,cfg.audio.cueRepeat);

    onset = GetSecs;
    
    % Get the end time
    waitForEndOfPlayback = 1; 
    [onsetEnd, ~, ~, estStopTime] = PsychPortAudio('Stop', cfg.audio.pahandle, ...
                                                waitForEndOfPlayback);

    duration = estStopTime - onsetEnd;
    duration2 = estStopTime - onset;

    % save them into a structure
    thisBlock.cueSubOnset = onset - cfg.experimentStart;
    thisBlock.cueSubOnsetEnd = onsetEnd - cfg.experimentStart;
    thisBlock.cueSubDuration = duration;
    thisBlock.cueSubDuration2  = duration2;

            
end