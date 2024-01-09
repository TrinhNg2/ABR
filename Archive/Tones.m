function [thresholds] = Tones(fname)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

levelNum=8;
freqNum=5;
d=load20msTones(fname);
freq=[4000 8000 16000 24000 32000];

for i=1:freqNum
    thresholds(i)=abrThresholdTones(d((((i-1)*(levelNum))+1):(i*levelNum)))
end

%close all

end

