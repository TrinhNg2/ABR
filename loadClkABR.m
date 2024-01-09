function [abrTrace, info] = loadClkABR(fi)
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
    for i = 1:info.nrecs
        abrTrace(i).trace = dataStruct.groups.recs(i).data; 
        abrTrace(i).levelS2N = dataStruct.groups.recs(i).Var1; 
    end

end
