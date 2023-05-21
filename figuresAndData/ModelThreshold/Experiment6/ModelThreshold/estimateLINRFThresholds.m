% This file estimates the thresholds of the linear receptive field LINRF 
% model. 
%
% The LINRF model takes a dot product of the LMS cone response image with the
% receptive field and then adds a gaussian noise proportional to the mean
% response.
%
% The thresholds are calculated for a range of values of the two parameters
% of the model: variance of the internal noise (below called decisionSigma)
% and the value of the RF surround (below called surroundValue).
%
% After estimating the LINRF model thresholds, the root mean square error
% between the LINRF model threhshold and human subject threshold is
% estimated to get the parameters that give the best fit.
%
%
%% Initialize
clear; close all;

% Set parameters that controls scale of additive noise variance. We will 
% first estimate the threshold for a range of parameters and identify the
% best parameters by minimizing the error between the model threshold and
% human threshold.

decisionSigma = linspace(10000, 30000, 21);
surroundValue = linspace(-0.2, -0.02, 21);

% Average the full calculation 10 times
nAverage = 10;

% There are 11 comparison images and 100 per comparison
nComparisonPerLRF = 11;
nImagesPerComparison = 100;

% Image row/col nPixels
nPixels = 51;

% RF center size
rfCenterRadiusPixels = 10;


% Set labels for each of the covariance scalars to be loaded in
cov_factor = {'Cov_0_00','Cov_0_0001','Cov_0_0003','Cov_0_001','Cov_0_003','Cov_0_01','Cov_0_03','Cov_0_10','Cov_0_30','Cov_1_00'};

tic;

for iterSurroundValue = 1:length(surroundValue)
    for iterDecisionSigma = [1:length(decisionSigma)]
        [iterSurroundValue, iterDecisionSigma]
        for iterAverage = 1:nAverage
             toc;
            % Load the images to be analyzed
            
            for iterCovariance = 1:length(cov_factor)
                % Clear except for what we're carrying forward.  This can produce
                % weird bugs if you add a variable below that is not local to this loop,
                % but forget to add it to this list.
                clearvars -except cov_factor iterCovariance modelThresholds decisionSigma ...
                iterDecisionSigma iterAverage iterSurroundValue surroundValue ...
                nAverage nComparisonPerLRF nImagesPerComparison nPixels ...
                rfCenterRadiusPixels

                % Perform analysis
                
                % Initialize the filter and training set
                newFilter = repmat(reshape(make2DRF(nPixels, rfCenterRadiusPixels, [1, surroundValue(iterSurroundValue)]),[],1),3,1);
                
                if (iterCovariance == 1)
                    
                    % Load the images to be analyzed
                    pathToStimulus = ['LMSImages/',cov_factor{iterCovariance},'.mat'];
                    stimulusFile = load(pathToStimulus);

                    % Initialize LMS images set
                    LMSImages = stimulusFile.LMSImages;
                    
                    %% Get Estimates
                    XEstimate =[];
                    XEstimate = LMSImages'*newFilter;
                    XEstimate = reshape(repmat(XEstimate',nImagesPerComparison,1),[],1);
                    XEstimate = XEstimate +  normrnd(0,decisionSigma(iterDecisionSigma),size(XEstimate,1),1);
                else
                    
                    % Load the images to be analyzed
                    pathToStimulus = ['LMSImages/',cov_factor{iterCovariance},'.mat'];
                    stimulusFile = load(pathToStimulus);
                    
                    % Initialize LMS images set
                    LMSImages = stimulusFile.LMSImages;
                    
                    %% Get Estimates
                    XEstimate =[];                    
                    XEstimate = LMSImages'*newFilter;
                    meanXEstimates = reshape(repmat(mean(reshape(XEstimate,[],nComparisonPerLRF)),nImagesPerComparison,1),[],1);
                    XEstimate = XEstimate +  normrnd(0,decisionSigma(iterDecisionSigma),size(XEstimate,1),1);
                    
                end
                %% Make psychometric function
                
                % Pick nComparisonPerLRF*nSimulatedTrials points randomly 
                % from the 0.4 lightness level for standard image.
                % Pick nSimulatedTrials points randomly from each level for
                % comparison image.
                % Compare the estimated lightness of comparison with standard image
                % Draw the psychometric function
                
                nSimulatedTrials = 10000;
                Lightness = reshape(XEstimate(:,1), 100,11);
                cmpIndex = randi(nImagesPerComparison,nSimulatedTrials,nComparisonPerLRF);
                stdIndex = randi(nImagesPerComparison,nSimulatedTrials,nComparisonPerLRF);
                
                stdLightness = zeros(nSimulatedTrials,nComparisonPerLRF);
                cmpLightness = zeros(nSimulatedTrials,nComparisonPerLRF);
                
                for ii = 1:11
                    stdLightness(:,ii) = Lightness(stdIndex(:,ii),6);
                    cmpLightness(:,ii) = Lightness(cmpIndex(:,ii),ii);
                end
                
                cmpChosen = cmpLightness > stdLightness;
                modelThresholds(iterSurroundValue, iterDecisionSigma, iterAverage, iterCovariance) = returnThreshold(cmpChosen);
            end
        end
    end
end
covScalar = [0.0001, 0.0003, 0.001, 0.003, 0.01, 0.03, 0.10, 0.30, 1];
% save('modelThresholds.mat', 'covScalar', 'modelThresholds', 'decisionSigma', 'surroundValue');

%%
function threshPal = returnThreshold(cmpChosen)

% Psychometric function form
PF = @PAL_CumulativeNormal;         % Alternatives: PAL_Gumbel, PAL_Weibull, PAL_CumulativeNormal, PAL_HyperbolicSecant

% paramsFree is a boolean vector that determins what parameters get
% searched over. 1: free parameter, 0: fixed parameter
paramsFree = [1 1 1 1];

% Initial guess.  Setting the first parameter to the middle of the stimulus
% range and the second to 1 puts things into a reasonable ballpark here.
paramsValues0 = [0.4 10 0 0];

lapseLimits = [0 0.05];

% Set up standard options for Palamedes search
options = PAL_minimize('options');

% Fit with Palemedes Toolbox.  The parameter constraints match the psignifit parameters above.  Some thinking is
% required to initialize the parameters sensibly.  We know that the mean of the cumulative normal should be
% roughly within the range of the comparison stimuli, so we initialize this to the mean.  The standard deviation
% should be some moderate fraction of the range of the stimuli, so again this is used as the initializer.
xx = linspace(0.35, 0.45,1000);

[paramsValues] = PAL_PFML_Fit(...
    [0.35:0.01:0.45]',mean(cmpChosen)',ones(size(mean(cmpChosen)')), ...
    paramsValues0,paramsFree,PF, ...
    'lapseLimits',lapseLimits,'guessLimits',[],'searchOptions',options,'gammaEQlambda',true);

yy = PF(paramsValues,xx');
psePal = PF(paramsValues,0.5,'inverse');
threshPal = PF(paramsValues,0.7602,'inverse')-psePal;

end


