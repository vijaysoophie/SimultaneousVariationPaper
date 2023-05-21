% This script makes the data table for figure 5 (psychometric function for 
% all observers). The script requires Palamedes_1.9.0 toolbox. 
%
% Aug 14 2021: Vijay Singh wrote this.
%
%%
clear; close all;
%% Load .csv file
dataFile = importfileForFigure10('../ObserverData/Experiment8/proportionComparisonChosen.csv');
data = table2array(dataFile);

thresholdU = 0.7604;
thresholdL = 0.2396;
%% Read LRF Levels
LRFLevels = data(2:end,1);
yLimits = [-0.05 1.05];
xLimits = [(min(LRFLevels) - min(diff(LRFLevels))/2) ...
    (max(LRFLevels)+ min(diff(LRFLevels))/2)];

%% Plot a vertical line indicating the standard

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
yy = zeros(1000, 73);
psePal = zeros(1, 73);
threshPal = zeros(1, 73);

for ii = 2:127
%% Get data for this subplot

proportionCorrect = data(2:end,ii);
totalTrial  = data(1,2)*ones(size(proportionCorrect));

%%

[paramsValues] = PAL_PFML_Fit(...
    LRFLevels, proportionCorrect, totalTrial, ...
    paramsValues0,paramsFree,PF, ...
    'lapseLimits',lapseLimits,'guessLimits',[],'searchOptions',options,'gammaEQlambda',true);
yy(:, ii) = PF(paramsValues,xx');
psePal(1, ii) = PF(paramsValues,0.5,'inverse');
threshPal(1, ii) = PF(paramsValues,0.7602,'inverse') - psePal(1, ii);

end

