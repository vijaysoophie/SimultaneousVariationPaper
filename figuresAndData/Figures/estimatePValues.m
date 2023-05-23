% Estimate p-value of the quantities reported in the Simultaneous variation
% paper.

%% Background reflectance variation
% Show that the chromatic and achromatic variation thresholds are similar
% to each other.

% % Load thresholds
% clear; close all;
% %% Load .csv file
% dataFile = importfileForFigure7('../ObserverData/Experiment6/subjectThreshold.csv');
% data = table2array(dataFile);
% 
% %% Get the covariance scales and subject thresholds
% covScale = [eps data(4:end,1)']'; % Covariance scales used for plotting. eps is used for covariance scale zero for calculations.
% covScaleForMarkers = [0.0001 data(4:end,1)']'; % Zero covariance scale is replaced by 0.000001 for plotting.
% 
% nCovScalarsPlot = 100; % Number of points used in plot for the smooth curves.
% covScalarsPlot = logspace(log10(covScaleForMarkers(1)),log10(covScaleForMarkers(end)),nCovScalarsPlot);
% 
% ThresholdSubject0003 = data(3:end, 2:4)';
% ThresholdSubjectBagel = data(3:end, 5:7)';
% ThresholdSubjectCommittee = data(3:end, 8:10)';
% ThresholdSubjectContent = data(3:end, 11:13)';
% ThresholdSubjectObserver = data(3:end, 14:16)';
% ThresholdSubjectRevival = data(3:end, 17:19)';
% 
% ThresholdMeanSubject = [ThresholdSubject0003; ThresholdSubjectBagel; ...
%     ThresholdSubjectCommittee; ThresholdSubjectContent; ...
%     ThresholdSubjectObserver; ThresholdSubjectRevival];
% 
% % Estimate p-value for chromatic and acrhomatic at covariance scalar 0.03
% p_value_0_03 = anova1(ThresholdMeanSubject(:,[3 4]));
% p_value_0_30 = anova1(ThresholdMeanSubject(:,[6 7]));
% p_value_1_00 = anova1(ThresholdMeanSubject(:,[8 9]));

%%
%
%
%
% Simultaneous variation
clear; close all;

%% Load .csv file
dataFile = importfileForFigure11('../ObserverData/Experiment8/subjectThreshold.csv');
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

%% Compare chromatic and achromatic for Background and Simultaneous conditions
p_value_BKG = anova1(ThresholdMeanSubject(:,[4 6]));
p_value_SIM = anova1(ThresholdMeanSubject(:,[5 7]));

%% Compare Simultaneous threshold with Sum of thresholds
p_value_sum_chrom = anova1([ThresholdMeanSubject(:,4) + ThresholdMeanSubject(:,3) - 2*ThresholdMeanSubject(:,2) ThresholdMeanSubject(:,5)- ThresholdMeanSubject(:,2)]);
p_value_sum_achrom = anova1([ThresholdMeanSubject(:,6) + ThresholdMeanSubject(:,3)- 2*ThresholdMeanSubject(:,2) ThresholdMeanSubject(:,7)- ThresholdMeanSubject(:,2)]);
