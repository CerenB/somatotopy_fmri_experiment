function thisFixation = doVisual(cfg)
% draw fixation cross and then present the upcoming body party

% If this frame shows a target we change the color of the cross
    thisFixation.fixation = cfg.fixation;
    thisFixation.screen = cfg.screen;
    
    
    drawFixation(thisFixation);
    vbl = Screen('Flip', cfg.screen.win);

   showNextBlock(cfg, cfg.nextBlock)
   Screen('Flip', cfg.screen.win, vbl + cfg.screen.ifi);
end