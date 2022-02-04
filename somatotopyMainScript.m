

getOnlyPress = 1;

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
    
    % load sounds & make beep sounds for events
    [cfg] = loadAudioFiles(cfg);
    
    % pseudorandom order of blocks and targets in events
    [cfg] = expDesign(cfg);

    % Prepare for the output logfiles with all
    logFile.extraColumns = cfg.extraColumns;
    logFile = saveEventsFile('init', cfg, logFile);
    logFile = saveEventsFile('open', cfg, logFile);
    
    % want to see cfg?
    disp(cfg);

    % Show experiment instruction
    standByScreen(cfg);

    % prepare the KbQueue to collect responses
    getResponse('init', cfg.keyboard.responseBox, cfg);

    % Wait for Trigger from Scanner
    waitForTrigger(cfg);
    
    %% Experiment Start

    cfg = getExperimentStart(cfg);

    getResponse('start', cfg.keyboard.responseBox);

    % baseline wait with fixation cross while fMRI is ON
    waitFor(cfg, cfg.timing.onsetDelay);
     
    %% For Each Block

    for iBlock = 1:cfg.design.nbBlocks

        fprintf('\n - Running block %s \n', cfg.design.blockNames{iBlock}); 
        
        % experimenter's cue to know where to stimulate
        [thisBlock]  = playCueAudio(cfg, iBlock);
        % % % we might need certain wait period here
        % % % after playCue, wait the rest
    
        for iEvent = 1:cfg.design.nbEventsPerBlock

            fprintf('\n - Running trial %.0f \n', iEvent);

            % Check for experiment abortion from operator
            checkAbort(cfg, cfg.keyboard.keyboard);

            [thisEvent, thisFixation, cfg] = preTrialSetup(cfg, iBlock, thisBlock, iEvent);


            % play the sounds and collect onset and duration of the event
            [onset, duration] = doAudioVisual(cfg, thisEvent, thisFixation);
            
            
            thisEvent = preSaveSetup( ...
                                     thisEvent, ...
                                     iBlock, ...
                                     iEvent, ...
                                     duration, onset, ...
                                     cfg, ...
                                     logFile);

            saveEventsFile('save', cfg, thisEvent);

            responseEvents = getResponse('check', cfg.keyboard.responseBox, cfg);
            collectAndSave(responseEvents, cfg, logFile, cfg.experimentStart);

            waitFor(cfg, cfg.timing.ISI);

        end
        
        % wait time in between 2 blocks
        waitFor(cfg, cfg.timing.IBI);
        
    end

    % End of the run for the BOLD to go down
    waitFor(cfg, cfg.timing.endDelay);

    cfg = getExperimentEnd(cfg);

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
