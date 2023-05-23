% This script plots the threshold for individual observers for Experiment 6.
%
% In this figure we plot log threshold squared vs log sigma squared for the
% mean observer. The data is then fit by Signal Detection Theory (SDT)
% model and the Linear Receptive Field (Linear RF) model. The figure is
% saved in the folder LightnessConstancy/AnalyzeExperiment6/Figures as
% Figure5.pdf.
%
% Unknown date: Vijay Singh wrote this.
% May 02, 2021: Vijay Singh modified and added comments.
% Apr 27 2023: Vijay Singh modified this from equivalnet noise paper script.
% May 17 2023: Vijay Singh modified this added Simultaneous Constancy paper folder.
% May 23 2023: Vijay Singh modified for all observers.
%
%%

clear; close all;
%% Load .csv file
dataFile = importfileForFigure7('../ObserverData/Experiment6/subjectThreshold.csv');
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

subjectName = {'0003', 'Bagel', 'Committee', 'Content', 'Observer', 'Revival'};

ThresholdMeanSubjectAll = [ThresholdSubject0003; ThresholdSubjectBagel; ...
    ThresholdSubjectCommittee; ThresholdSubjectContent; ...
    ThresholdSubjectObserver; ThresholdSubjectRevival];

%% Model covariance scales and thresholds
covScaleModel = [eps 0.01 0.03 0.1 0.3 1 0.3 0.3 1.0]';
covScaleModelForMarkers = [0.0001 0.01 0.03 0.1 0.3 1 0.1 0.3 1.0]';

% Model thresholds obtained through simulations. The
% estimateModelThresholds.m file in the folder ModelThreshold was used to
% obtain these values.
ModelThresholds = [0.0261    0.0259    0.0264    0.0278    0.0292    0.0344    0.0275    0.0314    0.0353]; %decision noise 19118 surround value -0.1006
ModelThresholdSTD = [0.0014    0.0014    0.0010    0.0009    0.0013    0.0012    0.0015    0.0014    0.0020]; %decision noise 19118 surround value -0.1006

%% Plot thresholds
hFig = figure;
set(hFig,'units','pixels', 'Position', [1 1 1000 500]);

colorIndex = [1 2 3 5 6 8];
grayIndex = [4 7 9];

for iterSubject = 1:6
    ThresholdMeanSubject = ThresholdMeanSubjectAll((iterSubject-1)*3+[1:3],:);
    subplot(2,3,iterSubject);
    hold on; box on
    errorbar(log10(covScaleForMarkers(colorIndex)),mean((log10(ThresholdMeanSubject(:,colorIndex).^2))), std(log10(ThresholdMeanSubject(:,colorIndex).^2))/sqrt(size(ThresholdMeanSubject,1)),'o','MarkerFaceColor', [1 0.3 0.3],'MarkerSize',8,'LineWidth',2, 'color', [1 0.3 0.3]);
    errorbar(log10(covScaleForMarkers(grayIndex)*0.9),mean((log10(ThresholdMeanSubject(:,grayIndex).^2))), std(log10(ThresholdMeanSubject(:,grayIndex).^2))/sqrt(size(ThresholdMeanSubject,1)),'D','MarkerFaceColor',[0.5 0.5 0.5],'MarkerSize',8,'LineWidth',2 , 'color', [0.5 0.5 0.5]);
    
%     errorbar(log10(covScaleModelForMarkers(1:6)*1.2),log10(ModelThresholds(1:6).^2), log10((ModelThresholds(1:6)+ModelThresholdSTD(1:6)).^2) - log10(ModelThresholds(1:6).^2), 'bs','MarkerFaceColor','b','MarkerSize',8,'LineWidth',2);
    
    %%
    lFitLabel{1} = 'Chromatic Background';
    lFitLabel{2} = 'Achromatic Background';
    
    % Threshold for computational observer
    hold on; box on;
%     lFitLabel{3} = ['LINRF $\{\sigma_{in}, \sigma_{ex}\} = \{0.026, 0.039\}$'];
    
    legend(lFitLabel,'interpreter','latex','location','best','Fontsize',10);
    set(gca, 'Fontsize',15);
    xlabel('log_{10}(\sigma^2)');
    ylabel('$\left<\log_{10}(T^2)\right> \pm \rm{SEM}$', 'interpreter', 'latex');
    xlim([-4.5 0.5]);
    ylim([-3.6 -2.6]);
    xticks([-4 -2 -1.5 -1 -0.5 0]);
    xticklabels({'-Inf', '-2', '-1.5', '-1', '-0.5', '0'});
    title(subjectName{iterSubject});
end
save2pdf('Figure7_SI.pdf', gcf, 600);
close;
