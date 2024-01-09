addpath('C:\Users\Trinh\Documents\MATLAB\Useful functions');
[fn, dname] = uigetfile('*.arf', 'MultiSelect', 'on');
extensions = {'fig','jpeg','svg'};
if class(fn) == 'char', nfile = 1; else,  nfile = numel(fn); end

for f = 1:nfile
    if nfile > 1
        [~,name,ext] = fileparts(fn{f});
    elseif nfile == 1
        [~,name,ext] = fileparts(fn);
    else 
        return;
    end
    close all;
    Tone = []; thresholds =[];
    mkdir([dname name]); % make a folder to save results
    % Analysis
    [abrTrace, info] = loadToneABR([dname name ext]);
    freq = unique(info.freq); 
    dB = sort(unique(info.toneI), 'descend');
    nFreq = numel(freq); nI = numel(dB);
    
    for i = 1:nFreq
        startIdx = (i-1)*nI+1;
        endIdx   = i*nI;
        
        [T, noiseFig, wfFig] = abrThresholdTones(abrTrace(startIdx:endIdx),...
                                         info);
        
        Tone = [Tone; freq(i)]; thresholds = [thresholds; T];
        % Saving figures
        tempFigName = sprintf('Noise Figure %d',freq(i));
        set(noiseFig, 'Name', tempFigName);
        savefn = fullfile([dname name], tempFigName); 
        saveasMulti(noiseFig,savefn,extensions);
        tempFigName = sprintf('Water Fall Figure %d',freq(i));
        set(wfFig, 'Name', tempFigName);
        savefn = fullfile([dname name], tempFigName); 
        saveasMulti(wfFig,savefn,extensions);
        close all;
    end

    
    resultTable = table(Tone ,thresholds);
    tempFigName = sprintf('%s.xlsx', name);
    writetable(resultTable,[dname tempFigName]);
end

close all
