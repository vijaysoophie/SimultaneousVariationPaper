% This script plots Figure 2 psychometric functions for Experiment 6.
% The script requires Palamedes_1.9.0 toolbox. The figure is
% saved in the folder LightnessConstancy/AnalyzeExperiment6/Figures as 
% Figure2.pdf.
%
% Unknown date: Vijay Singh wrote this.
% May 02 2021: Vijay Singh updated this.
% Apr 27 2023: Vijay Singh modified this from equivalnet noise paper script.
% May 17 2023: Vijay Singh modified this added Simultaneous Constancy paper folder.
%
%%
clear; close all;
%% Load .csv file
dataFile = importfileForFigure2('../ObserverData/Experiment6/proportionComparisonChosen.csv');
data = table2array(dataFile);

thresholdU = 0.7604;
thresholdL = 0.2396;
%% Get data for psychometric function

LRFLevels = data(2:end,1);
proportionCorrect = data(2:end,6);
totalTrial  = data(1,2)*ones(size(proportionCorrect));

%% Plot Figure

hFig = figure();
yLimits = [-0.05 1.05];
xLimits = [(min(LRFLevels) - min(diff(LRFLevels))/2) ...
    (max(LRFLevels)+ min(diff(LRFLevels))/2)];
set(hFig,'units','pixels', 'Position', [1 1 600 500]);
hold on; box on;

%% Plot a vertical line indicating the standard

lStdY = plot([LRFLevels(6) LRFLevels(6)], yLimits,':r','LineWidth', 2);

% Psychometric function form
PF = @PAL_CumulativeNormal;         % Alternatives: PAL_Gumbel, PAL_Weibull, PAL_CumulativeNormal, PAL_HyperbolicSecant

% paramsFree is a boolean vector that determins what parameters get
% searched over. 1: free parameter, 0: fixed parameter
paramsFree = [1 1 1 1];  

% Initial guess.  Setting the first parameter to the middle of the stimulus
% range and the second to 1 puts things into a reasonable ballpark here.
paramsValues0 = [mean(LRFLevels) 1/((max(LRFLevels)-min(LRFLevels))) 0 0];

lapseLimits = [0 0.05];

% Set up standard options for Palamedes search
options = PAL_minimize('options');

%% Fit with Palemedes Toolbox.  The parameter constraints match the psignifit parameters above.  Some thinking is
% required to initialize the parameters sensibly.  We know that the mean of the cumulative normal should be 
% roughly within the range of the comparison stimuli, so we initialize this to the mean.  The standard deviation
% should be some moderate fraction of the range of the stimuli, so again this is used as the initializer.
xx = linspace(xLimits(1), xLimits(2),1000);
%%

[paramsValues] = PAL_PFML_Fit(...
    LRFLevels, proportionCorrect, totalTrial, ...
    paramsValues0,paramsFree,PF, ...
    'lapseLimits',lapseLimits,'guessLimits',[],'searchOptions',options,'gammaEQlambda',true);
yy = PF(paramsValues,xx');
psePal = PF(paramsValues,0.5,'inverse');
threshPal = PF(paramsValues,0.7602,'inverse')-psePal;

text(min(LRFLevels),0.475,...
        ['PSE = ', num2str(psePal,3)],...
        'FontSize', 20); % Test to indicate the stimulusIntensities of 75% marker

text(min(LRFLevels),0.55,...
        ['Threshold = ', num2str(threshPal,3)],...
        'FontSize', 20); % Test to indicate the stimulusIntensities of 75% marker

%% Plot Fit Line
lTh = plot(xx, yy,'k', 'LineWidth', 4);

% Plot Raw Data % comparison
lData = plot(LRFLevels,proportionCorrect./totalTrial,'r.','MarkerSize',40);
%%
% Indicate 75% threshold
thresholdIndex = find(yy > thresholdU, 1); % find threshold
if ~isempty(thresholdIndex)
    plot([xx(1)-1 xx(thresholdIndex)],[yy(thresholdIndex) yy(thresholdIndex)],'--b', 'LineWidth', 2); % Horizontal line
    plot([xx(thresholdIndex) xx(thresholdIndex)],[yLimits(1) yy(thresholdIndex)],'--b', 'LineWidth', 2); % Vertical line
    lThMk = plot(xx(thresholdIndex),yy(thresholdIndex),'.k','MarkerSize',20); % 75% co-ordiante marker
    
    text(min(LRFLevels),0.7,...
        ['(' num2str(xx(thresholdIndex),3) ',' num2str(round(thresholdU*100)) '%)'],...
        'FontSize', 20); % Test to indicate the stimulusIntensities of 75% marker
end
thresholds.U = xx(thresholdIndex);

% Indicate 25% threshold
thresholdIndex = find(yy > thresholdL, 1); % find threshold
if ~isempty(thresholdIndex)
    plot([xx(1)-1 xx(thresholdIndex)],[yy(thresholdIndex) yy(thresholdIndex)],'--b', 'LineWidth', 2); % Horizontal line
    plot([xx(thresholdIndex) xx(thresholdIndex)],[yLimits(1) yy(thresholdIndex)],'--b', 'LineWidth', 2); % Vertical line
    lThMk = plot(xx(thresholdIndex),yy(thresholdIndex),'.k','MarkerSize',20); % 25% co-ordiante marker

    text(min(LRFLevels),0.3,...
        ['(' num2str(xx(thresholdIndex),3) ',' num2str(round(thresholdL*100)) '%)'],...
        'FontSize', 20); % Test to indicate the stimulusIntensities of 75% marker
end
thresholds.L = xx(thresholdIndex);

legend([lData lTh lStdY],...
    {'Observation', 'Cumulative Gaussian', 'Standard LRF'},...
    'Location','Northwest','FontSize',18);


xlabel('Comparison LRF');
ylabel(['Proportion Comparison Chosen (N = 30)']);
% title(sprintf('%s-%d', subjectName, fileNumber),'interpreter','none');
xlim(xLimits);
ylim(yLimits);
xticks(LRFLevels);
hAxis = gca;

set(hAxis,'FontSize',20);
hAxis.XTickLabelRotation = 90;

save2pdf('Figure2.pdf',gcf,600);