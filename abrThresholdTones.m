function [threshold, noiseFig, wfFig] = abrThresholdTones(abrTrace, info)
% DEFINITION
% Adapted from the Bergles Lab's analysis pipeline  
% Updated date: 1/8/2024 - TN - Bergles Lab - JHU
%
% Inputs: 
%        abrTrace - x by y matrix of ABRs for a single pure tone or frequency
% Outputs:
%    

    [x y] = size(abrTrace);
    for v = 1:y
        % peak to peak in first 10ms = 1:245 samples
        p1(v) = max(abrTrace(v).trace(1:245));
        n1(v) = min(abrTrace(v).trace(1:245)); 
        % peak to peak in last 6 ms = 343:489 samples
        bp1(v) = max(abrTrace(v).trace(342:488)); 
        bn1(v) = min(abrTrace(v).trace(342:488));
        bck(v) = 2*std(abrTrace(v).trace(342:488)); %%changed to 2 vs 1.5*std
    end
    noise = (nanmean(bp1-bn1)+nanmean(bck));
    noiseVec = zeros(1,y)+noise;
    % plot signal vs noise levels
    noiseFig = figure; hold on;
    plot([abrTrace(:).levelS2N],(p1-n1),'b');
    plot([abrTrace(:).levelS2N],((bp1-bn1)+bck),'r');
    plot([abrTrace(:).levelS2N],noiseVec,'k');
    legend({'p1-n1','(bp1-bn1)+bck','noiseVec'});
    
    % plot waterfall
    maxTime = info.recDuration_ms; % usually is 19.9885 ms
    interval = maxTime/info.npts; % interval time between sampling point
    time = [interval:interval:maxTime];
    wfFig = figure; hold on;
    yl = [];
    for i = 1:y
        plot(time, abrTrace(i).trace*1E6-5*(i-1),'k');
        yl = [yl abrTrace(i).levelS2N];
    end

    dim =[1.75,3]*1.5;
    xlim([0 20]); xlabel('Time (ms)'); ylabel('dB');
    figQuality(gcf,gca,dim);
    yticks([-35 -30 -25 -20 -15 -10 -5 0]);
    yticklabels([20 30 40 50 60 70 80 90]);
    ylim([-40 5]);
    
    % Determine threshold - highest level above noise, linear interpolation
    flag = 0;
    for v = 1:y
        if (p1(v)-n1(v)) <= (mean(bp1(:)-bn1(:)) + mean(bck(:))) && flag == 0
            flag = 1;
            if v == 1
                threshold = 95; % not detectable at 90 dB SPL
            else
                % linear interpolation
                slope = ((p1(v)-n1(v)) - (p1(v-1)-n1(v-1)))/(abrTrace(v).levelS2N-abrTrace(v-1).levelS2N); %signal drops below local boise
                interPol = (mean(bp1(:)-bn1(:))+mean(bck(:)) - (p1(v)-n1(v)))/slope; % using mean noise level
                threshold = (abrTrace(v).levelS2N) + interPol; %estimated based on mean noise during series
                if threshold > abrTrace(v-1).levelS2N
                    threshold = abrTrace(v-1).levelS2N; %fail-safe in case of overestimate of threshold 
                    % occurs with low local slope, high local noise
                end
            end
        end
    end
    %in case the interpolated threshold is below the measured level (eg, 20 dB)
    if flag == 0
        % linear interpolation
        slope = ((p1(v)-n1(v)) - (p1(v-1)-n1(v-1)))/(abrTrace(v).levelS2N-abrTrace(v-1).levelS2N); %signal drops below local boise
        interPol = (mean(bp1(:)-bn1(:))+mean(bck(:)) - (p1(v)-n1(v)))/slope; % using mean noise level
        threshold = (abrTrace(v).levelS2N) + interPol; % estimated based on mean noise during series
    end
end


