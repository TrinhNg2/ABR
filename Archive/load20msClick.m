function [avgABRclick] = load20msClick(fname)
%   UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    ABRrecord = readcell(fname);
    avgABR = struct();
    
    stimNum = 17; % # of levels of stimulation
    %stimNum = 11; % # of levels of stimulation
    
    for i = 2:stimNum+1
        avgABR(i-1).trace = [ABRrecord{i,49:end}]/1000;%convert to microvolts
        avgABR(i-1).level = ABRrecord{i,13};
        avgABR(i-1).levelS2N = 90-(5*(i-2));
    end
    
    avgABRclick = avgABR;
end

