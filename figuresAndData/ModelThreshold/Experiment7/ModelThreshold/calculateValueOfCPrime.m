
surroundValue = -0.2057;

nPixels = 51;
rfCenterRadiusPixels = 10;
newFilter = repmat(reshape(make2DRF(nPixels, rfCenterRadiusPixels, [1, surroundValue]),[],1),3,1);

pathToStimulus = fullfile('Experiment7/LMSImages/BkgFixedIlluminantScale_1_00_to_1_00.mat');
stimulusFile = load(pathToStimulus);

% Initialize LMS images set
LMSImages = stimulusFile.LMSImages;
XEstimate = LMSImages'*newFilter;

CPrime = XEstimate - XEstimate(6);
CPrime = CPrime./([0.35:0.01:0.45]-0.4)';
CPrime = nanmean(CPrime);
