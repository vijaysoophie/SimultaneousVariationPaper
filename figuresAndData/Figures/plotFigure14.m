% This script plots threshold for Experiment 8.
%
% In this figure we plot log threshold squared for the six conditions
% studied in Experiement 8. We also plot the increase in thresholds from
% the no variation condition and compare this when two sources of
% variations are presented together.
%
% Apr 30 2023: Vijay Singh wrote this.
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

MeanThresholdSquared = mean(((ThresholdMeanSubject.^2)));
StdThresholdSquared = std(((ThresholdMeanSubject.^2)));

%% Plot thresholds
fig = figure;
set(fig, 'Position', [100 100 800 500]);

hold on; box on;
% 1    "No Var Select"
% 2    "No Var "
% 3    "Light Var"
% 4    "Bkg Var"
% 5    "Lig Bkg Var"
% 6    "Bkg Var Gray"
% 7    "Lig Bkg Var Gray"

colorIndex  = [2 3 4 5];
xColorValue = [1 3 1.9 4.1];
grayIndex   = [6 7];
xGrayValue  = [2.1 5.1];

% Plot no variation baseline
plot([0 6], MeanThresholdSquared(2)*[1 1], 'b:', 'LineWidth', 2);

% Plot background variation above baseline
plot([1.9 1.9], [MeanThresholdSquared(2) MeanThresholdSquared(4)], 'color', [1 0.3 0.3], 'LineWidth', 20);
plot([2.1 2.1], [MeanThresholdSquared(2) MeanThresholdSquared(6)], 'color', [0.5 0.5 0.5], 'LineWidth', 20);


% Plot light variation above baseline
plot([3 3], [MeanThresholdSquared(2) MeanThresholdSquared(3)], 'color', [0.3 0.3 1], 'LineWidth', 20);

% Plot sum of individual variation above baseline
plot([3.9 3.9], [MeanThresholdSquared(2) MeanThresholdSquared(4)+MeanThresholdSquared(3)-MeanThresholdSquared(2)], 'color', [1 0.3 0.3], 'LineWidth', 20);
plot([4.9 4.9], [MeanThresholdSquared(2) MeanThresholdSquared(6)+MeanThresholdSquared(3)-MeanThresholdSquared(2)], 'color', [0.5 0.5 0.5], 'LineWidth', 20);

% Show the part that corresponds to light variation
plot([3.9 3.9], [MeanThresholdSquared(2) MeanThresholdSquared(3)], 'color', [0.3 0.3 1], 'LineWidth', 20);
plot([4.9 4.9], [MeanThresholdSquared(2) MeanThresholdSquared(3)], 'color', [0.3 0.3 1], 'LineWidth', 20);

% Show the combined variation
bColor = plot([4.1 4.1], [MeanThresholdSquared(2) MeanThresholdSquared(5)], 'color', [1 0.3 0.3], 'LineWidth', 20);
bGray = plot([5.1 5.1], [MeanThresholdSquared(2) MeanThresholdSquared(7)], 'color', [0.5 0.5 0.5], 'LineWidth', 20);


% Show the error bars
errorbar(xColorValue, mean(((ThresholdMeanSubject(:,colorIndex)).^2)), std((ThresholdMeanSubject(:,colorIndex)).^2)/sqrt(size(ThresholdMeanSubject,1)),'ko','MarkerFaceColor','k','MarkerSize',10,'LineWidth',2);
errorbar(xGrayValue, mean(((ThresholdMeanSubject(:,grayIndex)).^2)), std((ThresholdMeanSubject(:,grayIndex)).^2)/sqrt(size(ThresholdMeanSubject,1)),'ko','MarkerFaceColor','k','MarkerSize',10,'LineWidth',2);

errorbar([3.9 4.9], [MeanThresholdSquared(4)+MeanThresholdSquared(3)-MeanThresholdSquared(2) ...
    MeanThresholdSquared(6)+MeanThresholdSquared(3)-MeanThresholdSquared(2)], ...
    [sqrt(sum(StdThresholdSquared([2 3 4]).^2)/18) sqrt(sum(StdThresholdSquared([2 3 6]).^2)/18)], ...
    'ko','MarkerFaceColor','k','MarkerSize',10,'LineWidth',2);

%%
lFitLabel{1} = 'Chromatic Background';
lFitLabel{2} = 'Achromatic Background';
% Threshold for computational observer
hold on; box on;


legend([bColor bGray],lFitLabel,'interpreter','latex','location','northwest');
set(gca, 'Fontsize',20);
xlabel('Type of Variation');
ylabel('$\left<T^2\right> \pm \rm{SEM} $ ', 'interpreter', 'latex');
xlim([0.6 5.5]);
% ylim([-3.2 -2.1]);
xticks([1:5]);
xticklabels({'None', 'Background', 'Light', 'Simultaneous \newline Chromatic', 'Simultaneous \newline Achromatic',});

% save2pdf('Figure14.pdf', gcf, 600);

