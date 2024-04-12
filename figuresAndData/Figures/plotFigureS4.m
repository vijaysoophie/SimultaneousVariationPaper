% This script plots Figure S4 comparison of Experiment 6 and Experiment 3.
% Experiment 3 was the experiment reported in Singh, Burge, Brainard 2022.
%
% In this figure we plot log threshold squared vs log sigma squared for the
% mean observer. The data is then fit by Signal Detection Theory (SDT) 
% model and the Linear Receptive Field (Linear RF) model. The figure is
% saved in the folder LightnessConstancy/AnalyzeExperiment6/Figures as 
% Figure5.pdf.
%
% June 12 2023: Vijay Singh modified this from Fig 9 of Simultaneous
%       Variation paper.
%
%%

clear; close all;
%% Load .csv file
dataFile = importfileForFigure9('../ObserverData/Experiment6/subjectThreshold.csv');
data = table2array(dataFile);

%% Get the covariance scales and subject thresholds
covScale = [eps data(4:end,1)']'; % Covariance scales used for plotting. eps is used for covariance scale zero for calculations.
covScaleForMarkers = [0.0001 data(4:end,1)']'; % Zero covariance scale is replaced by 0.000001 for plotting.

nCovScalarsPlot = 100; % Number of points used in plot for the smooth curves.
covScalarsPlot = logspace(log10(covScaleForMarkers(1)),log10(covScaleForMarkers(end)),nCovScalarsPlot);

ThresholdSubject0003 = data(3:end, 2:4)';
ThresholdSubjectBagel = data(3:end, 5:7)';
ThresholdSubjectCommittee = data(3:end, 8:10)';
ThresholdSubjectContent = data(3:end, 11:13)';
ThresholdSubjectObserver = data(3:end, 14:16)';
ThresholdSubjectRevival = data(3:end, 17:19)';

ThresholdMeanSubject = [ThresholdSubject0003; ThresholdSubjectBagel; ...
    ThresholdSubjectCommittee; ThresholdSubjectContent; ...
    ThresholdSubjectObserver; ThresholdSubjectRevival];

%% Plot thresholds
figure;
hold on; box on;
colorIndex = [1 2 3 5 6 8];
grayIndex = [4 7 9];
errorbar(log10(covScaleForMarkers(colorIndex)),mean((log10(ThresholdMeanSubject(:,colorIndex).^2))), std(log10(ThresholdMeanSubject(:,colorIndex).^2))/sqrt(size(ThresholdMeanSubject,1)),'o','MarkerFaceColor', [1 0.3 0.3],'MarkerSize',8,'LineWidth',2, 'color', [1 0.3 0.3]);
errorbar(log10(covScaleForMarkers(grayIndex)*0.9),mean((log10(ThresholdMeanSubject(:,grayIndex).^2))), std(log10(ThresholdMeanSubject(:,grayIndex).^2))/sqrt(size(ThresholdMeanSubject,1)),'D','MarkerFaceColor',[0.5 0.5 0.5],'MarkerSize',8,'LineWidth',2 , 'color', [0.5 0.5 0.5]);

%% Plot Experiment 3 Data
Experiment3Data = [    -4.0000   -2.0000   -1.5229   -1.0000   -0.5229         0;
   -3.2609   -3.2988   -3.1246   -3.0874   -2.9596   -2.8773;
    0.0411    0.0310    0.0463    0.0418    0.0511    0.0601];

errorbar(Experiment3Data(1,:)+0.08,Experiment3Data(2,:), Experiment3Data(3,:), 'bs','MarkerFaceColor','b','MarkerSize',8,'LineWidth',2);

%%
lFitLabel{1} = 'Chromatic Background';
lFitLabel{2} = 'Achromatic Background';
lFitLabel{3} = ['{Singh, Burge, Brainard 2022}'];

legend(lFitLabel,'interpreter','latex','location','northwest');
set(gca, 'Fontsize',20);
xlabel('log_{10}(\sigma^2)');
ylabel('$\left<\log_{10}(T^2)\right> \pm \rm{SEM}$', 'interpreter', 'latex');
xlim([-4.5 0.5]);
ylim([-3.35 -2.6]);
xticks([-4 -2 -1.5 -1 -0.5 0]);
xticklabels({'-Inf', '-2', '-1.5', '-1', '-0.5', '0'});

save2pdf('FigureS4.pdf', gcf, 600);
close;
