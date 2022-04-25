function showNextBlock(cfg, textToPrint)
    %
    % It prints on the screen the input text
    % adapted from drawFixation script
    % USAGE::
    %
    %  showText(cfg, textToPrint)
    %
    
    textToPrint = ['Next:', textToPrint];
    
    Screen('FillRect', cfg.screen.win, cfg.color.background, cfg.screen.winRect);

    DrawFormattedText(cfg.screen.win, ...
                      textToPrint, ...
                      'center', 'center', cfg.text.color);

end