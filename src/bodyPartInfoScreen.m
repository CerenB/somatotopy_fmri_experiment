function [thisBlock] = bodyPartInfoScreen(cfg, textToPrint)
    %
    % It shows a basic one-page instruction stored in `cfg.task.instruction` and wait
    % for fixed duration 
    %
    % USAGE::
    %
    %  bodyPartInfoScreen(cfg)
    %
    
    Screen('FillRect', cfg.screen.win, cfg.color.background, cfg.screen.winRect);

    DrawFormattedText(cfg.screen.win, ...
                      textToPrint, ...
                      'center', 'center', cfg.text.color);

    vbl = Screen('Flip', cfg.screen.win);

    % Wait time before continue
    WaitSecs(cfg.timing.visualCueDuration);
    
    % get end time
    vblStopTime = GetSecs();
    duration = vblStopTime - vbl;
    
    % save them into a structure
    thisBlock.cueVisOnset = vbl - cfg.experimentStart;
    thisBlock.cueVisDuration = duration;
%     % dummy numbers
%     thisBlock.cueVisOnsetEnd = vblStopTime - cfg.experimentStart;
%     thisBlock.cueVisDuration2  = duration;
end