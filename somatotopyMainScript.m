

% Clear all the previous stuff
clc;
if ~ismac
    close all;
    clear Screen;
end

% make sure we got access to all the required functions and inputs
initEnv();

% set and load all the parameters to run the experiment
cfg = setParameters;
cfg = userInputs(cfg);
cfg = createFilename(cfg);

%%  Experiment

% Safety loop: close the screen if code crashes
try

    %% Init the experiment
    [cfg] = initPTB(cfg);

    
    % refractor 
    % s = loadAndMakeBeepAudio(cfg)
    %
    
    % do expDesign - pseudorandom order of blocks and targets in events
    % expDesign.m
    % 
    
    cfg = postInitializationSetup(cfg);

    % Prepare for the output logfiles with all
    logFile.extraColumns = cfg.extraColumns;
    logFile = saveEventsFile('init', cfg, logFile);
    logFile = saveEventsFile('open', cfg, logFile);
    
    
    disp(cfg);

    % Show experiment instruction
    standByScreen(cfg);

    % prepare the KbQueue to collect responses
    getResponse('init', cfg.keyboard.responseBox, cfg);

    %% Experiment Start

    cfg = getExperimentStart(cfg);

    getResponse('start', cfg.keyboard.responseBox);

    %% For Each Block

    for iBlock = 1:cfg.design.nbBlocks

        waitFor(cfg, cfg.timing.onsetDelay);

        % experimenter's cue to know where to stimulate
        cueOnset = playCueAudio(cfg, thisBlock);
    
        for iTrial = 1:cfg.design.nbTrials

            fprintf('\n - Running trial %.0f \n', iTrial);

            % Check for experiment abortion from operator
            checkAbort(cfg, cfg.keyboard.keyboard);

            [thisEvent, thisFixation, cfg] = preTrialSetup(cfg, iBlock, iTrial);


            % play the sounds and collect onset and duration of the event
            [onset, duration] = doAuditoryMotion(cfg, thisEvent);
            
            
            thisEvent = preSaveSetup( ...
                                     thisEvent, ...
                                     iBlock, ...
                                     iTrial, ...
                                     duration, onset, ...
                                     cfg, ...
                                     logFile);

            saveEventsFile('save', cfg, thisEvent);

            % collect the responses and appends to the event structure for
            % saving in the tsv file
            responseEvents = getResponse('check', cfg.keyboard.responseBox, cfg);
            
            responseEvents(1).isStim = logFile.isStim;
            responseEvents(1).fileID = logFile.fileID;
            responseEvents(1).extraColumns = logFile.extraColumns;
            saveEventsFile('save', cfg, responseEvents);


            waitFor(cfg, cfg.timing.ISI);

        end

    end

    % End of the run for the BOLD to go down
    waitFor(cfg, cfg.timing.endDelay);

    cfg = getExperimentEnd(cfg);

    eyeTracker('StopRecordings', cfg);

    % Close the logfiles
    saveEventsFile('close', cfg, logFile);

    getResponse('stop', cfg.keyboard.responseBox);
    getResponse('release', cfg.keyboard.responseBox);

    createJson(cfg, cfg);

    farewellScreen(cfg);

    cleanUp();

catch

    cleanUp();
    psychrethrow(psychlasterror);

end
