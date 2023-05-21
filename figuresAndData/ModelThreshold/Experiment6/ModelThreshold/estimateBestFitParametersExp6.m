% This script calcautes the root mean squared error (RMSE) between the 
% thresholds of the mean human subject and the LINRF model. The RMSE is fit
% by a quadratic polynomial in two variables. The polynomial is minimized 
% to get the parameters that give lowest RMSE.
% 
% The same process was repeated for individual subjects to get the best
% fit parametes of the individual subjects. To do this, remove the
% appropriate lines from the thresholdAllSubjects matrix in the section below.
%
% May 02 2021 Vijay Singh wrote this.
%
%%
% Load human subject threholds 
clear;
dataFile = importfileForFigure5('../ObserverData/subjectThreshold.csv');
data = table2array(dataFile);

thresholdAllSubjects = [data([3:5 7:8 10],2:end)];
thresholdAllSubjectsGrayCombined = [data([3:4],2:end); ...
     mean(data([5:6],2:end)); data(7,2:end); ...
     mean(data([8:9],2:end)); mean(data([10:11],2:end))];

load('modelThresholds.mat');
%% Create a 3D matrix of the threshold of the mean human subject.

% Calcuate the mean threshold of all subjects
thresholdMeanSubject = mean(thresholdAllSubjectsGrayCombined,2)';

% Reorganize the thresholds to create a 3D matrix.
thresholdMeanSubject = repmat(thresholdMeanSubject, size(modelThresholds, 2),1);
thresholdMeanSubject3D = zeros(size(modelThresholds, 1), size(modelThresholds, 2), 6);

for ii = 1:size(modelThresholds, 1)
    thresholdMeanSubject3D(ii, :, :) = thresholdMeanSubject;
end

%% Calculate the root mean squared error between human and model threhsolds
RMSE = sum((squeeze(mean(modelThresholds,3)) - thresholdMeanSubject3D).^2,3);
figure;
surf(decisionSigma, surroundValue, RMSE);
xlabel( 'decisionSigma', 'Interpreter', 'none' );
ylabel( 'surroundValue', 'Interpreter', 'none' );
zlabel( 'RMSE', 'Interpreter', 'none' );
title( 'RMSE', 'Interpreter', 'none' );
view([0 90]);

%% Fit RMSE with a second order polynomial of two variables.
% Since the landscape is not entirely convex, we have chosen a region
% around the minima to do this fit.

[xData, yData, zData] = prepareSurfaceData( decisionSigma(7:15), surroundValue(7:15), RMSE(7:15, 7:15));

% Set up fittype and options.
ft = fittype( 'poly22' );

% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft );

% Plot fit with data.
figure( 'Name', 'RMSE between mean human subject and computational model' );
h = plot( fitresult, [xData, yData], zData );
legend( h, 'Fit of quadratic polynomial in two variables', 'RMSE vs. decisionSigma, surroundValue', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'decisionSigma', 'Interpreter', 'none' );
ylabel( 'surroundValue', 'Interpreter', 'none' );
zlabel( 'RMSE', 'Interpreter', 'none' );
grid on;
view([0 90]);

%% Parameters that give minimum RMSE
% These parameters that give the lowest RMSE can be obtained by first
% differentiating the fit polynomial by x and y, settting the corresponding
% equations to zero and solving the coupled set of equations. The solutions
% are below:

decisionSigmaMin = -((2*fitresult.p02*fitresult.p10 - fitresult.p01*fitresult.p11)/(-fitresult.p11^2 + 4*fitresult.p02*fitresult.p20));
surroundValueMin = -((fitresult.p10*fitresult.p11 - 2*fitresult.p01*fitresult.p20)/(fitresult.p11^2 - 4*fitresult.p02*fitresult.p20));

% The corresponding value of minimum RMSE is:
fitresult([decisionSigmaMin, surroundValueMin]);



