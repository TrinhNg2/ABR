function [threshold] = Click(fname)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

d=load20msClick(fname);
threshold=abrThresholdClick(d);
name=strsplit(fname, '.')
saveas(gcf, strcat(name{1}, 'click_waterfall.tif'))
close
saveas(gcf, strcat(name{1}, 'click_noise.tif'))
close
end

