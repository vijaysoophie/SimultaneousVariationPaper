
surroundValue = -0.1006;

nPixels = 51;
rfCenterRadiusPixels = 10;
newFilter = repmat(reshape(make2DRF(nPixels, rfCenterRadiusPixels, [1, surroundValue]),[],1),3,1);

pathToStimulus = fullfile('Experiment6/LMSImages/Cov_0_00.mat');
stimulusFile = load(pathToStimulus);

% Initialize LMS images set
LMSImages = stimulusFile.LMSImages;
XEstimate = LMSImages'*newFilter;

CPrime = XEstimate - XEstimate(6);
CPrime = CPrime./([0.35:0.01:0.45]-0.4)';
CPrime = nanmean(CPrime);
