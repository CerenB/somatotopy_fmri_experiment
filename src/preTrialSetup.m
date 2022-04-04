% (C) Copyright 2020 CPP visual motion localizer developpers

function varargout = preTrialSetup(varargin)
    % varargout = postInitializatinSetup(varargin)

    % prepare some structure before each trial

    [cfg, iBlock, thisBlock, iEvent] = deal(varargin{:});

    % set block name and targets
    thisEvent.trial_type = cfg.design.blockNamesOrder{iBlock};
    thisEvent.blockNb = cfg.design.blockOrder(iBlock);
    
    % store block IBI
    thisEvent.ibi = cfg.timing.IBI(iBlock);
    
    if cfg.doAudioCue
        % save block info into thisEvent structure
        thisEvent.expAudCueOnset = thisBlock.cueAudOnset;
        thisEvent.expAudCueOnsetEnd = thisBlock.cueAudOnsetEnd;
        thisEvent.expAudCueDuration = thisBlock.cueAudDuration;
%         thisEvent.expAudCueDuration2 = thisBlock.cueAudDuration2;
    elseif cfg.doVisualCue
        thisEvent.expVisCueOnset = thisBlock.cueVisOnset;
        thisEvent.expVisCueDuration = thisBlock.cueVisDuration;
    end
    
    if cfg.audio.doSplitHeadphone
        thisEvent.subCueOnset = thisBlock.cueSubOnset;
        thisEvent.subCueOnsetEnd = thisBlock.cueSubOnsetEnd;
        thisEvent.subCueDuration = thisBlock.cueSubDuration;
%         thisEvent.subCueDuration2 = thisBlock.cueSubDuration2;
    end
    
    % think about calculating duration properly
    if mod(iEvent,12) == 1
        thisEvent.trial_type = ['block_', cfg.design.blockNamesOrder{iBlock}];
    end
    

    thisEvent.fixationTarget = cfg.design.fixationTargets(iBlock, iEvent);
    thisEvent.soundTarget = cfg.design.soundTargets(iBlock, iEvent);
            
    % If this frame shows a target we change the color of the cross
    thisFixation.fixation = cfg.fixation;
    thisFixation.screen = cfg.screen;

    varargout = {thisEvent, thisFixation, cfg};

end
