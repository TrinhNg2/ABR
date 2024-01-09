%% Plot the thresholds of two different groups as audiograms 

%% 
%Update the following section. 'Groups' or thresholds to plot should 
%    first be loaded as variables in the workspace. 

% Tones - !!! this should be a variable type 'double' with individual
% animals in rows and frequencies in columns !!!

Thresh_tones_cntrl=Tones('M01tone.csv')
Thresh_tones_cntrl=[Thresh_tones_cntrl;Tones('F02tone.csv')]
Thresh_tones_KO=Tones('F01tone.csv')

G1_tones = Thresh_tones_cntrl;%Group 1 tone thresholds (e.g., controls)
G2_tones = Thresh_tones_KO;%Group 2 tone thresholds (e.g., KOs or manipulated group)

Cntrl_click_thresh=abrThresholdClick(load20msClick('M01click.csv'))
Cntrl_click_thresh=[Cntrl_click_thresh;abrThresholdClick(load20msClick('F02click.csv'))]
KO_click_thresh=abrThresholdClick(load20msClick('F01click.csv'))

%Click thresholds - this should also be a 'double' 
G1_click = Cntrl_click_thresh; 
G2_click = KO_click_thresh; 

Freqs = [4 8 16 24 32];% Tone frequencies that will be plotted
close all

%% plot with individual animals
set(0,'defaultAxesFontSize',18,'DefaultAxesFontName','Arial','DefaultFigureWindowStyle','normal')
figure, title('ABR')
hold on
for i = 1:size(G1_tones,1)
    plot(Freqs,G1_tones(i,:),'Color',[0.8 0.8 0.8],'LineWidth',0.5)
end
WTave = nanmean(G1_tones,1);
h1 = plot(Freqs,WTave,'Color','k','LineWidth',2,'DisplayName','C57');
for i = 1:size(G2_tones,1)
    plot(Freqs,G2_tones(i,:),'Color',[1 0.6 0.78],'LineWidth',0.5)
end
CastAve = nanmean(G2_tones,1);
h2 = plot(Freqs,CastAve,'Color','r','LineWidth',2,'DisplayName','Cast/EiJ')
ylabel('Threshold (dB SPL)') 
xlabel('Tone Frequency (kHz)')
xticks([4 8 16 24 32])
xticklabels([4 8 16 24 32]) 
xlim([0 36]);
legend([h1 h2],{'Control ','1000mg/kg Kanamycin + 400mg/kg Furosemide'})

%% plot with SEM
lt_org = [255, 166 , 38]/255;
dk_org = [0.85 0.33 0.1];
lt_prl = [234 213 254]/255; 
dk_prl = [194 140 246]/255; 
lt_blue = [50, 175, 242]/255;
dk_blue = [0 0.45 0.74];
figure, hold on 
title('ABR')
WT_SEM = nanstd(G1_tones,1)/sqrt(size(G1_tones,1));
WT_Mean = nanmean(G1_tones,1); 
A = flipud(WT_Mean);
D1high = A + flipud(WT_SEM);
D1low = A - flipud(WT_SEM);
plot(Freqs,D1high,'-','Color',[0.8 0.8 0.8])
plot(Freqs,D1low,'-','Color',[0.8 0.8 0.8])
patch([Freqs fliplr(Freqs)], [D1high fliplr(D1low)],[0.8 0.8 0.8],'EdgeColor','none','FaceAlpha',.3)

KO_SEM = nanstd(G2_tones,1)/sqrt(size(G2_tones,1));
KO_Mean = nanmean(G2_tones,1); 
B = flipud(KO_Mean);
D2high = B + flipud(KO_SEM);
D2low = B - flipud(KO_SEM);
plot(Freqs,D2high,'-','Color',lt_blue)
plot(Freqs,D2low,'-','Color',lt_blue)
patch([Freqs fliplr(Freqs)], [D2high fliplr(D2low)],lt_blue,'EdgeColor','none','FaceAlpha',.3)
hold on 
h1 = plot(Freqs,WT_Mean,'Color','k','LineWidth',2,'DisplayName','C57')
h2 = plot(Freqs,KO_Mean,'Color',dk_blue,'LineWidth',2,'DisplayName','Cast/EiJ')
ylabel('Threshold (dB SPL)') 
xlabel('Tone Frequency (kHz)')
xticks([4 8 16 24 32])
xticklabels([4 8 16 24 32]) 
ylim([0 100])
legend([h1 h2],{'Group 1','Group 2'})
%% Add click threshold to tone threshold plot
%plot box and points
hold on 
notBoxPlot(G1_click,42.5,5)
hold on
boxplot(G1_click,'Position',42.5,'Widths',[5,5],...
    'BoxStyle','filled','Colors','k')
notBoxPlot(G2_click,52.5,5)
hold on 
boxplot(G2_click,'Position',52.5,'Widths',[5,5],...
    'BoxStyle','filled','Colors',dk_blue)
% 'clean up' by hiding SEM and mean - comment this section out if you want
% them included in the plot
g = gca;
set(g.Children([3:5 8:10]),'Visible','off')

%update lebels 
xlabel('Tone Frequency (kHz)')
xticks([4 8 16 24 32 47.5])
xticklabels({'4','8','16','24','32','Click'}) 
legend([h1 h2],{'Group 1','Group 2'})

% %change box width
% a = get(gca,'children');   % Get the handles of all the objects
% t = get(a,'tag');   % List the names of all the objects 
% idx=strcmpi(t,'box');  % Find Box objects
% boxes=a(idx);          % Get the children you need
% set(boxes,'linewidth',20); % Set width

clear CData NData i CAve NAve


