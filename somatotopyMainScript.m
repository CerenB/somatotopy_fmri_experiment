
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
%     disp(cfg);

    % Show experiment instruction
    standByScreenWithText(cfg);

    % prepare the KbQueue to collect responses
    getResponse('init', cfg.keyboard.responseBox, cfg);
    
    % Wait for Trigger from Scanner
    waitForTrigger(cfg);
    
    %% Experiment Start

    % start with fixation corss & take time onset
    cfg = getExperimentStart(cfg);
    
    getResponse('start', cfg.keyboard.responseBox);

    % after this wait time, exp hears the audio cue for which body part to
    % brush
    WaitSecs(cfg.timing.experimenterCueOnsetDelay);
     
    %% For Each Block

    for iBlock = 1:cfg.design.nbBlocks

        currentBlock = cfg.design.blockNamesOrder{iBlock};
        
        fprintf('\n - Running block %d, %s \n', iBlock, currentBlock);
        
        if iBlock < cfg.design.nbBlocks
            cfg.nextBlock = cfg.design.blockNamesOrder{iBlock+1};
        else
            cfg.nextBlock = ' done! ';
        end
        
        if cfg.doAudioCue
           % experimenter's cue to know where to stimulate
            [thisBlock]  = playCueAudio(cfg, iBlock);
            thisBlock.cueDuration = thisBlock.cueAudDuration;
            
        elseif cfg.doVisualCue
            %experimenter's visual cue to where where to move
            [thisBlock]  = bodyPartInfoScreen(cfg, currentBlock);
            thisBlock.cueDuration = thisBlock.cueVisDuration;
        end
        

        if iBlock == 1
            % play subject's cue
            % 2s cue hear it and then wait 1s then start stimulation
            if cfg.audio.doSplitHeadphone
                % % % if participant cue is 3s before, you can delete this
                % waitFor 
                waitFor(cfg, cfg.timing.afterCueOnsetDelay - cfg.timing.subjectCueOnset...
                             - thisBlock.cueDuration);
                % % %
                [thisBlock]  = playSubjectCueAudio(cfg, iBlock, thisBlock);
                waitFor(cfg, cfg.timing.subjectCueOnset - thisBlock.cueSubDuration); 
            % wait time after auditory cue for beginning of exp
            else
                waitFor(cfg, cfg.timing.afterCueOnsetDelay - thisBlock.cueDuration);
            end
        else
            if cfg.audio.doSplitHeadphone
               waitFor(cfg, cfg.timing.IBI(iBlock) - thisBlock.cueDuration...
                            - cfg.timing.subjectCueOnset); 
               [thisBlock]  = playSubjectCueAudio(cfg, iBlock, thisBlock);
               waitFor(cfg, cfg.timing.subjectCueOnset - thisBlock.cueSubDuration); 
            else
                % wait time in between 2 blocks
                % IBI - the audio cue playing tme (1s x 2)
                waitFor(cfg, cfg.timing.IBI(iBlock) - thisBlock.cueDuration);
            end
        end
        
        % present things visually to the screen
        thisFixation = doVisual(cfg);
        
        for iEvent = 1:cfg.design.nbEventsPerBlock

            fprintf('\n - Running trial %.0f \n', iEvent);

            % Check for experiment abortion from operator
            checkAbort(cfg, cfg.keyboard.keyboard);

            [thisEvent, cfg] = preTrialSetup(cfg, iBlock, thisBlock, iEvent);


            % play the sounds and collect onset and duration of the event
            [onset, duration] = doAudio(cfg, thisEvent);
            
            
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
        end     
    end

    % End of the run for the BOLD to go down
    WaitSecs(cfg.timing.endDelay);

    cfg = getExperimentEnd(cfg);

    % Close the logfiles
    saveEventsFile('close', cfg, logFile);

    getResponse('stop', cfg.keyboard.responseBox);
    getResponse('release', cfg.keyboard.responseBox);

    % save bold.json
    createJson(cfg, 'func');

    % save config info
    saveCfg(cfg);
    
    farewellScreen(cfg);

    cleanUp();

catch
    
    % save config info
    saveCfg(cfg);

    cleanUp();
    psychrethrow(psychlasterror);

end
