function [threshold, noiseFig, wfFig] = abrThresholdClk(abrTrace, info)
% DEFINITION
% Adapted from the Bergles Lab's analysis pipeline  
% Updated date: 1/8/2024 - TN - Bergles Lab - JHU
%
% Inputs: 
%   
% Outputs:
%          

    nrecs = info.nrecs; % number of recordings 
    for v = 1:nrecs
        % peak to peak in first 10ms = 1:245 samples
        p1(v) = max(abrTrace(v).trace(1:245));
        n1(v) = min(abrTrace(v).trace(1:245)); 
        % peak to peak in last 6 ms = 343:489 samples
        bp1(v) = max(abrTrace(v).trace(342:488)); 
        bn1(v) = min(abrTrace(v).trace(342:488));
        bck(v) = 2*std(abrTrace(v).trace(342:488));
    end
    

    noise = (mean(bp1-bn1)+mean(bck));
    noiseVec = zeros(1,v)+noise;
    % plot signal vs noise levels
    noiseFig = figure; hold on
    plot([abrTrace(:).levelS2N],(p1-n1),'b');
    plot([abrTrace(:).levelS2N],(bp1-bn1)+bck,'r');
    plot([abrTrace(:).levelS2N],noiseVec,'k');
    legend({'p1-n1','(bp1-bn1)+bck','noiseVec'})
    
    % plot waterfall
    maxTime = info.recDuration_ms; % usually is 19.9885 ms
    interval = maxTime/info.npts; % interval time between sampling point
    time = [interval:interval:maxTime];
    wfFig = figure; hold on
    yl = [];
    for x = 1:2:nrecs % Change the spacing of ABR plot (dB)
        plot(time, abrTrace(x).trace*1E6-10*(x-1),'k');
        yl = [yl abrTrace(x).levelS2N];
    end
    dim =[1.75,3]*1.5;
    xlim([0 20]); xlabel('Time (ms)'); ylabel('dB');
    %handle = gcf;
    figQuality(gcf,gca,dim);
    ylim([-nrecs*10 10]); yticks(-((nrecs-1)*10):20:0);
    yticklabels(flip(yl));
    
    
    %% Determine threshold -lowest value still above noise
    flag = 0;
%     for v = 1:nrecs
%         if (p1(v)-n1(v)) <= (bp1(v)-bn1(v)+bck(v)) && flag == 0
%             flag = 1;
%             if v == 1
%                 threshold = 100; % not detectable at 90
%             else
%                 threshold = (abrTrace(v).levelS2N);
%             end
%         else
%     end
    for v = 1:nrecs
        if (p1(v)-n1(v)) <= (mean(bp1-bn1) + mean(bck)) && flag == 0
            flag = 1;
            if v == 1
                threshold = 95; % not detectable at 90 - not real threshold, but a placeholder
            else
                % linear interpolation
                slope = ((p1(v)-n1(v)) - (p1(v-1)-n1(v-1)))/(abrTrace(v).levelS2N-abrTrace(v-1).levelS2N);
                interPol = (mean(bp1(:)-bn1(:))+mean(bck(:)) - (p1(v)-n1(v)))/slope; % using mean noise level            
                threshold = (abrTrace(v).levelS2N) + interPol;
                if threshold > abrTrace(v-1).levelS2N
                    threshold = abrTrace(v-1).levelS2N; %fail-safe in case of overestimate of threshold
                end
            end
        
        end
    
    end
        
end


