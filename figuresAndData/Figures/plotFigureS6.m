% This script plots Figure S6 for log threshold for Experiment 7. This is
% similar to Figure 11, but includes the thresholds of all observers. Figure
% 11 excludes the thresholds of one of the observer (Observer oven).
%
% In this figure we plot log threshold squared vs log sigma squared for the
% mean observer. The data is then fit by Signal Detection Theory (SDT) 
% model and the Linear Receptive Field (Linear RF) model. The figure is
% saved in the folder LightnessConstancy/AnalyzeExperiment6/Figures as 
% Figure5.pdf.
%
% Unknown date: Vijay Singh wrote this.
% May 02, 2021: Vijay Singh modified and added comments.
% Aug 15, 2021: Vijay Singh changed name to Figure5.
% Apr 27 2023: Vijay Singh modified this from equivalent noise paper script.
% May 17 2023: Vijay Singh moved this to Simultaneous Constancy folder.
%
%%

clear; % close all;
%% Load .csv file
dataFile = importfileForFigure11('../ObserverData/Experiment7/subjectThreshold.csv');
data = table2array(dataFile);

%% Get the covariance scales and subject thresholds
covScale = [eps data(4:end,1)']'; % Covariance scales used for plotting. eps is used for covariance scale zero for calculations.
covScaleForMarkers = [0.000001 data(4:end,1)']'; % Zero covariance scale is replaced by 0.000001 for plotting.

nCovScalarsPlot = 100; % Number of points used in plot for the smooth curves.
covScalarsPlot = linspace(covScaleForMarkers(1),covScaleForMarkers(end),nCovScalarsPlot);

ThresholdSubject0003 = data(3:end, 2:4)';
ThresholdSubjectBagel = data(3:end, 5:7)';
ThresholdSubjectContent = data(3:end, 8:10)';
ThresholdSubjectOven = data(3:end, 11:13)';
ThresholdSubjectPrimary = data(3:end, 14:16)';
ThresholdSubjectRevival = data(3:end, 17:19)';

ThresholdMeanSubject = [ThresholdSubject0003; ThresholdSubjectBagel; ...
    ThresholdSubjectContent; ThresholdSubjectOven; ...
    ThresholdSubjectPrimary; ThresholdSubjectRevival];

%% Model covariance scales and thresholds
covScaleModel = [eps 0.05 0.10 0.15 0.2 0.25 0.3]';
covScaleModelForMarkers = [0.000001  0.05 0.10 0.15 0.2 0.25 0.3]';
% Model thresholds obtained through simulations. The 
% estimateModelThresholds.m file in the folder ModelThreshold was used to
% obtain these values.

ModelThresholds = [0.0272    0.0278    0.0289    0.0298    0.0347    0.0372    0.0436]; %decision noise 18981 surround value -0.2057
ModelThresholdSTD = [0.0014    0.0018    0.0016    0.0023    0.0016    0.0010    0.0023]; %decision noise 18981 surround value -0.2057
%% Plot thresholds
figure;
hold on; box on;
errorbar(covScaleForMarkers-0.0025,mean((log10(ThresholdMeanSubject.^2))), std(log10(ThresholdMeanSubject.^2))/sqrt(size(ThresholdMeanSubject,1)),'o','MarkerFaceColor', [1 0.3 0.3],'MarkerSize',10,'LineWidth',2, 'color', [1 0.3 0.3]);
errorbar(covScaleModelForMarkers+0.0025,log10(ModelThresholds.^2),log10((ModelThresholds-ModelThresholdSTD).^2) - log10(ModelThresholds.^2),'bs','MarkerFaceColor','b','MarkerSize',10,'LineWidth',2);

%%
lFitLabel{1} = 'Light Variation Achromatic Background';

% Threshold for computational observer
hold on; box on;
lFitLabel{2} = ['LINRF $\{\sigma_{in}, \sigma_{ex}\} = \{0.028, 0.052\}$'];

legend(lFitLabel,'interpreter','latex','location','northwest');
set(gca, 'Fontsize',20);
xlabel('\delta');
ylabel('$\left<\log_{10}(T^2)\right> \pm \rm{SEM}$', 'interpreter', 'latex');
xlim([-0.02 0.32]);
ylim([-3.35 -2.6]);
xticks([0:0.05:0.3]);

save2pdf('FigureS6.pdf', gcf, 600);
close;
