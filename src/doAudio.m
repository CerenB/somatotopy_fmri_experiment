function [onset, duration] = doAudio(cfg, thisEvent)

    % Play the auditory stimulation of pure tone beeps (metronome)
    %
    %
    % Input:
    %   - cfg: PTB/machine configurations returned by setParameters and initPTB
    %   - expParameters: parameters returned by setParameters
    %   - thisEvent: structure that the parameters regarding the event to present
    %
    % Output:
    %     - onset in machine time
    %     - duration in seconds
    %

    %% Get parameters

    % experimenter beep sound event
    onset = playBeepAudio(cfg, thisEvent);


    % Get the end time
    waitForEndOfPlayback = 1; % hard coding that will need to be moved out
    [onset, ~, ~, estStopTime] = PsychPortAudio('Stop', cfg.audio.pahandle, ...
                                                waitForEndOfPlayback);

    duration = estStopTime - onset;
    
    % playTime = PsychPortAudio('Start', pahandle, repetitions, startCue, waitForDeviceStart);
    
