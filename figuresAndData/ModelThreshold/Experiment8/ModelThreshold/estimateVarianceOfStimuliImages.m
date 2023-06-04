function curve = estimateVarianceOfStimuliImages(surroundValueTemp, valueOfCPrime)
% Image row/col nPixels
nPixels = 51;
% RF center size
rfCenterRadiusPixels = 10;

RF = repmat(reshape(make2DRF(nPixels, rfCenterRadiusPixels, [1, surroundValueTemp]),[],1),3,1);


load('Experiment8/LMSImages/BKG_CovSca_1_IllScale_0_7_to_1_3.mat');
Sigma_e0 = cov(LMSImage');
r1 = (RF'*Sigma_e0*RF)/(valueOfCPrime.^2);

load('Experiment8/LMSImages/BkgFixedIlluminantScale_0_70_to_1_30.mat');
Sigma_e0 = cov(LMSImage');
r2 = (RF'*Sigma_e0*RF)/(valueOfCPrime.^2);

load('Experiment8/LMSImages/StimuliCondition2_covScaleFactor_1_00_NoReflection.mat');
Sigma_e0 = cov(LMSImages');
r3 = (RF'*Sigma_e0*RF)/(valueOfCPrime.^2);


close;

