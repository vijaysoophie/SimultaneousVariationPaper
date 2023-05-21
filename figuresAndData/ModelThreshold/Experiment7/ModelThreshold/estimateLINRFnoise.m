% This script calculates the internal and external noise of the LINRF
% model.
%
% The internal and external noise for various observers are given below.
% The noise for the LINRF model was estimated using the formulae given the 
% main text of Equivalent Noise paper.
%
% May 15, 2023: Vijay Singh wrote this.
clear;
%% Parameters of the LINRF model for each subject.
% These values were calculated by minimizing the root mean-square error 
% between LINRF model thresholds and threshold of the subject. See 
% estimateLINRFThresholds.m in the folder figuresAndData/ModelThreshold of 
% the supplementary materials for details. Also, see Linear Receptive Field
% Model Fit in the Methods section of the main text.

noiseInLINRFGaussian = [24817 ;     % ObserverID
                        1.8981e+04];                    

% Value of surround pixels of the receptive field in the LINRF model. This 
% value was calculated by minimizing the root mean-square error between 
% LINRF model thresholds and threshold of the subject. See 
% estimateLINRFThresholds.m for details.
valueOfSurround      = [24817;     % ObserverID
                        -0.2057];
                    
% Value of C'. This parameter relates the receptive field response to the
% threshold. See sub-section Linear Receptive Field Model in the Methods 
% section of the main text.
valueOfCPrime        = [24817;      % ObserverID
                        6.8202e+05];                    

%% Estimate the internal and external noise of the LINRFModel

% Internal Noise
internalNoiseLINRF = noiseInLINRFGaussian(2,:)./valueOfCPrime(2,:);

% External Noise
for ii = 1:size(valueOfSurround,2)
    surroundValueTemp = valueOfSurround(2,ii);
    curve = estimateVarianceOfStimuliImages(surroundValueTemp);
    cPrimeTemp = valueOfCPrime(2,ii);
    externalNoiseLINRF(1,ii) = sqrt(curve(1)/(cPrimeTemp.^2));
end

%%
noiseEstimatedByLINRFModel = [24817 ; % ObserverID
                              internalNoiseLINRF;                      % Internal Noise
                              externalNoiseLINRF];                     % External Noise                                    

                           
