function [abrTrace, info] = loadToneABR(fi)
% DEFINITION
% Updated date: 1/8/2024 - TN - Bergles Lab - JHU
% Inputs: 
%          fi   - 
% Outputs:
%          abrTrace - 
%          info     - 
    
    dataStruct = arfread(fi);
    info.nrecs = dataStruct.RecHead.nrecs;
    info.recDuration_ms = dataStruct.groups.recs(1).dur_ms;
    info.npts = dataStruct.groups.recs(1).npts;
    info.freq = [dataStruct.groups.recs(:).Var1];
    info.toneI = [dataStruct.groups.recs(:).Var2];
    for i = 1:info.nrecs
        abrTrace(i).trace = dataStruct.groups.recs(i).data; 
        abrTrace(i).levelS2N = dataStruct.groups.recs(i).Var2; 
    end

end