function [cfg] = loadAudioFiles(cfg)

    
    %% Load the sounds
    freq = [];
    
    %load auditory beep sounds
    fileName = fullfile('input', '700Hz_250ms.wav');
    [soundData.T, freq(1)] = audioread(fileName);
    soundData.T = soundData.T';
    
    fileName = fullfile('input', '350Hz_250ms.wav');
    [soundData.NT, freq(2)] = audioread(fileName);
    soundData.NT = soundData.NT';

    %% load the cue
    
    fileName = fullfile('input', 'hand.wav');
    [soundData.H, freq(3)] = audioread(fileName);
    soundData.H = soundData.H';
    
    fileName = fullfile('input', 'feet.wav');
    [soundData.Fe, freq(4)] = audioread(fileName);
    soundData.Fe = soundData.Fe';
    
    fileName = fullfile('input', 'forehead.wav');
    [soundData.Fo, freq(5)] = audioread(fileName);
    soundData.Fo = soundData.Fo';
    
    fileName = fullfile('input', 'nose.wav');
    [soundData.N, freq(6)] = audioread(fileName);
    soundData.N = soundData.N';
    
    fileName = fullfile('input', 'cheek.wav');
    [soundData.C, freq(7)] = audioread(fileName);
    soundData.C = soundData.C';

    fileName = fullfile('input', 'tongue.wav');
    [soundData.To, freq(8)] = audioread(fileName);
    soundData.To = soundData.To';

    fileName = fullfile('input', 'lips.wav');
    [soundData.L, freq(9)] = audioread(fileName);
    soundData.L = soundData.L';

    
    %%
    if length(unique(freq)) > 1
        error ('Sounds dont have the same sampling frequency');
    else
        freq = unique(freq);
    end

    cfg.soundData = soundData;
    cfg.audio.fs = freq;
    
end