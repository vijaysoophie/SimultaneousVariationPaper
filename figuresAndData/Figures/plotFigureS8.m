% This script plots Figure S8 for Simultaneous Constancy (Experiment 8).
%
% In this figure we plot log threshold squared of the mean observer for the
% six conditions studied in Experiment 8. The data is then fit by the 
% Linear Receptive Field (Linear RF) model. The figure is
% saved in the folder LightnessConstancy/AnalyzeExperiment8/Figures as 
% Figure5.pdf.
%
% Unknown date: Vijay Singh wrote this.
% May 02, 2021: Vijay Singh modified and added comments.
% Aug 15, 2021: Vijay Singh changed name to Figure5.
% Apr 27 2023: Vijay Singh modified this from equivalnet noise paper script.
% May 17 2023: Vijay Singh modified this added Simultaneous Constancy paper folder.
%
%%

clear; close all;
%% Load .csv file
dataFile = importfileForFigure13('../ObserverData/Experiment8/subjectThreshold.csv');
dataString = table2array(dataFile);
for iRow = 1:8
    for iCol = 1:18
        data(iRow, iCol) = str2num(dataString(iRow, iCol+1));
    end
end

%% Get the covariance scales and subject thresholds

ThresholdSubject0003 = data(2:end, 1:3)';
ThresholdSubjectBagel = data(2:end, 4:6)';
ThresholdSubjectFun = data(2:end, 7:9)';
ThresholdSubjectOven = data(2:end, 10:12)';
ThresholdSubjectManos = data(2:end, 13:15)';
ThresholdSubjectRevival = data(2:end, 16:18)';

ThresholdMeanSubject = [ThresholdSubject0003; ThresholdSubjectBagel; ...
    ThresholdSubjectFun; ThresholdSubjectOven; ...
    ThresholdSubjectManos; ThresholdSubjectRevival];

%% Plot thresholds
figure;
hold on; box on;
% 1    "No Var Select"
% 2    "No Var "
% 3    "Light Var"
% 4    "Bkg Var"
% 5    "Lig Bkg Var"
% 6    "Bkg Var Gray"
% 7    "Lig Bkg Var Gray"

colorIndex  = [2 3 4 5];
xColorValue = [1 3 2 4];
grayIndex   = [6 7];
xGrayValue  = [2.1 4.1];

l1 = errorbar(xColorValue, mean((log10(ThresholdMeanSubject(:,colorIndex).^2))), std(log10(ThresholdMeanSubject(:,colorIndex).^2))/sqrt(size(ThresholdMeanSubject,1)),'ro','MarkerFaceColor', [1 0.3 0.3],'MarkerSize',10,'LineWidth',2, 'color', [1 0.3 0.3]);
l2 = errorbar(xGrayValue, mean((log10(ThresholdMeanSubject(:,grayIndex).^2))), std(log10(ThresholdMeanSubject(:,grayIndex).^2))/sqrt(size(ThresholdMeanSubject,1)),'D','MarkerFaceColor', [0.5 0.5 0.5], 'MarkerEdgeColor', [0.5 0.5 0.5], 'MarkerSize',10,'LineWidth',2, 'color', [0.5 0.5 0.5]);


%% Model covariance scales and thresholds
ModelThresholds = [0.0257    0.0675    0.0360    0.0658    0.0354    0.0618]; %decision noise 19118 surround value -0.1006
ModelThresholdStd = [0.0013    0.0019    0.0023    0.0027    0.0009    0.0020]; %decision noise 19118 surround value -0.1006

l3 = errorbar(xColorValue-0.05, log10(ModelThresholds(colorIndex-1).^2), ...
    log10((ModelThresholds(colorIndex-1)+ModelThresholdStd(colorIndex-1)).^2) - log10(ModelThresholds(colorIndex-1).^2), ...
    'bs','MarkerFaceColor','b','MarkerSize',8,'LineWidth', 1.5);
errorbar(xGrayValue+0.05, log10(ModelThresholds(grayIndex-1).^2), ...
    log10((ModelThresholds(grayIndex-1)+ModelThresholdStd(grayIndex-1)).^2) - log10(ModelThresholds(grayIndex-1).^2), ...
    'bs','MarkerFaceColor','b','MarkerSize',8,'LineWidth', 1.5);

%% Model covariance scales and thresholds
ModelThresholds = [0.0277    0.0435    0.0641    0.0632    0.0661    0.0704]; %decision noise 1.8981e+04 surround value -0.2057
ModelThresholdStd = [0.0012    0.0023    0.0024    0.0033    0.0028    0.0043]; %decision noise 1.8981e+04 surround value -0.2057

l4 = errorbar(xColorValue-0.05, log10(ModelThresholds(colorIndex-1).^2), ...
    log10((ModelThresholds(colorIndex-1)+ModelThresholdStd(colorIndex-1)).^2) - log10(ModelThresholds(colorIndex-1).^2), ...
    'kv','MarkerFaceColor','k','MarkerSize',8,'LineWidth', 1.5);
errorbar(xGrayValue+0.05, log10(ModelThresholds(grayIndex-1).^2), ...
    log10((ModelThresholds(grayIndex-1)+ModelThresholdStd(grayIndex-1)).^2) - log10(ModelThresholds(grayIndex-1).^2), ...
    'kv','MarkerFaceColor','k','MarkerSize',8,'LineWidth', 1.5);

%%
lFitLabel{1} = 'Chromatic Background';
lFitLabel{2} = 'Achromatic Background';
lFitLabel{3} = ['LINRF $\{\sigma_{in,B}, \sigma_{ex,B}\} = \{0.026, 0.039\}$'];
lFitLabel{5} = ['LINRF $\{\sigma_{in,L}, \sigma_{ex,L}\} = \{0.028, 0.052\}$'];
% Threshold for computational observer
hold on; box on;


legend([l1, l2, l3, l4], {lFitLabel{1:3}, lFitLabel{5}},'interpreter','latex','location','southeast');
set(gca, 'Fontsize',20);
xlabel('Type of Variation');
ylabel('$\left<\log_{10}(T^2)\right> \pm \rm{SEM}$', 'interpreter', 'latex');
xlim([0.6 4.5]);
ylim([-3.35 -2.3]);
xticks([1:4]);
xticklabels({'None', 'Background', 'Light', 'Simultaneous'});

% save2pdf('FigureS8.pdf', gcf, 600);
% close;

