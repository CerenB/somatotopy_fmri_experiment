function [cfg] = expDesign(cfg, displayFigs)

    % refractored by CB on 01/02/2022 for Moebius Experiment
    
    % Creates the sequence of blocks and the events in them
    %
    % The conditions are consecutive static and motion blocks
    % (Gives better results than randomised).
    %
    % Style guide: constants are in SNAKE_UPPER_CASE
    %
    % EVENTS
    % The numEventsPerBlock should be a multiple of the number of "base"
    % listed in the MOTION_DIRECTIONS and STATIC_DIRECTIONS (4 at the moment).
    %  MOTION_DIRECTIONS = [0 90 180 270];
    %  STATIC_DIRECTIONS = [-1 -1 -1 -1];
    %
    % Pseudorandomization rules:
    % (1) Directions are all present in random orders in `numEventsPerBlock/nDirections`
    % consecutive chunks. This evenly distribute the directions across the
    % block.
    % (2) No same consecutive direction
    %
    %
    % TARGETS
    %
    % Pseudorandomization rules:
    % (1) If there are 2 targets per block we make sure that they are at least 2
    % events apart.
    % (2) Targets cannot be on the first or last event of a block.
    % (3) Targets can not be present more than 2 times in the same event
    % position across blocks.
    %
    % Input:
    % - cfg: parameters returned by setParameters
    % - displayFigs: a boolean to decide whether to show the basic design
    % matrix of the design
    %
    % Output:
    % - ExpParameters.designBlockNames = cell array (nr_blocks, 1) with the
    % name for each block
    %
    % - cfg.designDirections = array (nr_blocks, numEventsPerBlock)
    % with the direction to present in a given block
    % - 0 90 180 270 indicate the angle
    % - -1 indicates static
    %
    % - cfg.designSpeeds = array (nr_blocks, numEventsPerBlock) * speedEvent;
    %
    % - cfg.designFixationTargets = array (nr_blocks, numEventsPerBlock)
    % showing for each event if it should be accompanied by a target
    %

    %% Check inputs

    % Set to 1 for a visualtion of the trials design order
    if nargin < 2 || isempty(displayFigs)
        displayFigs = 0;
    end

    % Set variables here for a dummy test of this function
    if nargin < 1 || isempty(cfg)
        error('give me something to work with');
    end

    fprintf('\n\nCreating design.\n\n');

    [NB_BLOCKS, NB_CONDITION, ~, NB_EVENTS_PER_BLOCK, MAX_TARGET_PER_BLOCK] = getInput(cfg);
    [blockOrder, blockNames, indices] = setBlocks(cfg);
    
    % we have 3 repetition, and 3 possible target. So each condition in
    % each repetition takes 1 of the possible targets
    RANGE_TARGETS = 0:MAX_TARGET_PER_BLOCK;

   % shuffle the possible targets for each condition separately
    numTargetsForEachBlock = zeros(1, NB_BLOCKS);
    for iCondition = 1:NB_CONDITION
        numTargetsForEachBlock(indices(:,iCondition)) = shuffle(RANGE_TARGETS);
    end
    
    %% Give the blocks the names with condition and design the task in each event
    while 1

        fixationTargets = zeros(NB_BLOCKS, NB_EVENTS_PER_BLOCK);

        soundTargets = zeros(NB_BLOCKS, NB_EVENTS_PER_BLOCK);

        for iBlock = 1:NB_BLOCKS

            % Set target
            % - if there are 2 targets per block we make sure that they are at least
            % 2 events apart
            % - targets cannot be on the first event of a block

            nbTarget = numTargetsForEachBlock(iBlock);

            % Fixation targets
            forbiddenPositions = [];
            chosenPosition = setTargetPositionInSequence( ...
                                                         NB_EVENTS_PER_BLOCK, ...
                                                         nbTarget, ...
                                                         forbiddenPositions);

            fixationTargets(iBlock, chosenPosition) = 1;

            % Sound targets
            forbiddenPositions = [chosenPosition];
            chosenPosition = setTargetPositionInSequence( ...
                                                         NB_EVENTS_PER_BLOCK, ...
                                                         nbTarget, ...
                                                         forbiddenPositions);

            soundTargets(iBlock, chosenPosition) = 1;


        end

        % Check that fixation and shorter sound are not presented in the same event
        if max(unique(fixationTargets + soundTargets)) < 2
            break
        end

    end
    
    % I want fixation target == auditory for pilot exp - CB 01/02/2022
    fixationTargets = soundTargets;

    %% Now we do the easy stuff
    cfg.design.blockNames = blockNames;

    cfg.design.nbBlocks = NB_BLOCKS;

    cfg.design.blockOrder = blockOrder;

    cfg.design.fixationTargets = fixationTargets;

    cfg.design.soundTargets = soundTargets;

    %% Plot
    diplayDesign(cfg, displayFigs);

end

function [blockOrder, blockNames, indices] = setBlocks(cfg)


    [~, NB_CONDITION ,NB_REPETITIONS, ~] = getInput(cfg);
    blockOrder = zeros(NB_REPETITIONS, NB_CONDITION);
    blockNames = cell(NB_REPETITIONS * NB_CONDITION,1);
    
    % pseudorandomization of blocks
    counter = 1;
    for iRep = 1:NB_REPETITIONS
        
        blockOrder(iRep,:) = randperm(length(cfg.design.blockNames));
        blockNames(counter:(iRep *NB_CONDITION)) = cfg.design.blockNames(blockOrder(iRep,:));
        
        counter = counter +7;
    end
    
    
    % now reorganise for easy saving
    blockOrder = reshape(blockOrder',1,[]);
    
    % Get the index of each condition
    % not using transpose and
    hand = find(blockOrder == 1);
    feet = find(blockOrder == 2);
    nose = find(blockOrder == 3);
    tongue = find(blockOrder == 4);
    lips = find(blockOrder == 5);
    cheek = find(blockOrder == 6);
    forehead = find(blockOrder == 7);

    indices = [hand', feet', nose', tongue', lips', cheek', forehead'];

end


function [nbBlocks, nbCondition, nbRepet, nbEventsBlock, maxTargBlock] = getInput(cfg)
    nbCondition = length(cfg.design.blockNames);
    nbRepet = cfg.design.nbRepetitions;
    nbEventsBlock = cfg.design.nbEventsPerBlock;
    maxTargBlock = cfg.target.maxNbPerBlock;
    nbBlocks = length(cfg.design.blockNames) * nbRepet;
end



function diplayDesign(cfg, displayFigs)

    %% Visualize the design matrix
    if displayFigs

        close all;

        figure(1);

        % Shows blocks (static and motion) and events (motion direction) order
        blocks = cfg.design.blockOrder;

        subplot(3, 1, 1);
        imagesc(blocks);

        labelAxesBlock();

        caxis([1 7]);
        myColorMap = lines(7);
        colormap(myColorMap);
        colorbar();

        title('Block (static and motion) & Events (motion direction)');

        % Shows the fixation targets design in each event (1 or 0)
        fixationTargets = cfg.design.fixationTargets;

        subplot(3, 1, 2);
        imagesc(fixationTargets);
        labelAxesBlock();
        title('Fixation Targets design');
        colormap(gray);

        % Shows the fixation targets position distribution in the block across
        % the experimet
        [~, itargetPosition] = find(fixationTargets == 1);

        subplot(3, 1, 3);
        hist(itargetPosition);
        labelAxesFreq();
        title('Fixation Targets position distribution');

%         figure(2);
% 
%         [motionDirections] = getDirectionBaseVectors(cfg);
%         motionDirections = unique(motionDirections);
% 
%         for iMotion = 1:length(motionDirections)
% 
%             [~, position] = find(directions == motionDirections(iMotion));
% 
%             subplot(2, 2, iMotion);
%             hist(position);
%             scaleAxes();
%             labelAxesFreq();
%             title(num2str(motionDirections(iMotion)));
% 
%         end

    end

end

function labelAxesBlock()
    % an old viking saying because they really cared about their axes
    ylabel('Block seq.', 'Fontsize', 8);
    xlabel('Events', 'Fontsize', 8);
end

function labelAxesFreq()
    % an old viking saying because they really cared about their axes
    ylabel('Number of targets', 'Fontsize', 8);
    xlabel('Events', 'Fontsize', 8);
end

% function scaleAxes()
%     xlim([1 12]);
%     ylim([0 5]);
% end
