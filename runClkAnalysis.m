addpath('C:\Users\Trinh\Documents\MATLAB\Useful functions');
[fn, dname] = uigetfile('*.arf', 'MultiSelect', 'on');
extensions = {'fig','jpeg','svg'};
if class(fn) == 'char', nfile = 1; else,  nfile = numel(fn); end

fileName = {}; thresholds =[];
for f = 1:nfile
    if nfile > 1
        [~,name,ext] = fileparts(fn{f});
    elseif nfile == 1
        [~,name,ext] = fileparts(fn);
    else 
        return;
    end
    close all;
    mkdir([dname name]); % make a folder to save results
    
    % Analysis
    [abrTrace, info] = loadClkABR([dname name ext]);
    [T, noiseFig, wfFig] = abrThresholdClk(abrTrace, info);
    
    % Saving figures
    savefn = fullfile([dname name], '1_Noise Figure'); 
    saveasMulti(noiseFig,savefn,extensions);
    savefn = fullfile([dname name], '2_Water Fall Figure'); 
    saveasMulti(wfFig,savefn,extensions);
    
    fileName{end+1} = name; thresholds = [thresholds; T];
end
resultTable = table(fileName',thresholds);
writetable(resultTable,[dname 'clickResultTable.xlsx']);

close all
