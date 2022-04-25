function standByScreenWithText(cfg)
    %
    % It shows a basic one-page instruction stored in `cfg.task.instruction` and wait
    % for `space` stroke.
    %
    % USAGE::
    %
    %  standByScreen(cfg)
    %
    % (C) Copyright 2020 CPP_PTB developers

    textToPrint = ['Next:', cfg.design.blockNamesOrder{1}];
    
    Screen('FillRect', cfg.screen.win, cfg.color.background, cfg.screen.winRect);

    DrawFormattedText(cfg.screen.win, ...
                      textToPrint, ...
                      'center', 'center', cfg.text.color);
                  
    Screen('Flip', cfg.screen.win);

    % Wait for space key to be pressed
    pressSpaceForMe();

end