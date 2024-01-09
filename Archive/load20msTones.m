function [avgABRtone] = load20msTones(fname)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


ABRrecord = readcell(fname);
avgABR = struct();

stimNum = 40; % # of levels of stimulation x tone sets (total) 

for i = 2:stimNum+1
    i == 1
    avgABR(i-1).trace = [ABRrecord{i,49:end}]/1000;% in microvolts
    avgABR(i-1).level = ABRrecord(i,14);
    avgABR(i-1).level = avgABR(i-1).level{1};
    avgABR(i-1).freq = ABRrecord(i,13);
    avgABR(i-1).freq = avgABR(i-1).freq{1};
    avgABR(i-1).levelS2N = avgABR(i-1).level;
end

avgABRtone = avgABR;
end

