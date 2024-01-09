function [threshold] = abrThreshold(fname)
y = numel(fname);
for v = 1:y
    % peak to peak in first 10ms = 1:245 samples
    p1(v) = max(fname(v).trace(1:245));
    n1(v) = min(fname(v).trace(1:245)); 
    % peak to peak in last 6 ms = 343:489 samples
    bp1(v) = max(fname(v).trace(342:488)); 
    bn1(v) = min(fname(v).trace(342:488));
    bck = 2*std(fname(v).trace(342:488));
end

% plot signal vs noise levels
% figure
% plot([fname(:).levelS2N],(p1-n1),'b')
% hold on
% plot([fname(:).levelS2N],(bp1-bn1)+bck,'r')
% hold off

% plot waterfall
maxTime = 19.9885; % milliseconds
interval = maxTime/488; % 488 samples per interval
time = [interval:interval:maxTime];
figure
hold on
yl = [];
for x = 1:2:y
    if x == 1 
    plot(time, fname(x).trace*1E6-10*(x-1),'k')
    else
    plot(time, fname(x).trace*1E6-10*(x-1),'k')
    end
    yl = [yl fname(x).levelS2N];
end
dim =[1.75,3];
xlim([0 20]);
xlabel('time (ms)');
ylabel('dB');
handle = gcf;
figQuality(gcf,gca,dim);
yticks(-160:20:0);
yticklabels(flip(yl))
ylim([-170 10])
hold off

% Determine threshold -lowest value still above noise
flag = 0;
for v = 1:y
    if (p1(v)-n1(v)) <= (bp1(v)-bn1(v)+bck) && flag == 0
        flag = 1;
        if v == 1
            threshold = 100; % not detectable at 90
        else
            threshold = (fname(v).levelS2N);
        end
    else
    end
    
end


