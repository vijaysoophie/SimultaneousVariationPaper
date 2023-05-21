This folder has the Matlab scripts to generate the thresholds of the LINRF model.

This requires the Palamedes toolbox: http://www.palamedestoolbox.org to be on your matlab path. 

estimateLINRFThresholds.m: This script generates the thresholds of the LINRF model for a range of values 
			   of the two parameters of the LINRF model. These parameters are the noise in the 
			   decision-making process and the surround value of the center-surround receptive field.
			   The thresholds are saved in Matlab file modelThresholds.mat.

estimateBestFitParameters.m: This script estimates the values of the two parameters of the LINRF model that 
			  give the lowest value of the root mean squared error (RMSE) between the threshold of 
			  the LINRF model and threshold of the subject. The RMSE data is fit with a polynomial 
			  of degree two in two variables. The polynomial is minimized to get the minimum RMSE 
			  parameters. 
			  This script generates these parameters for the mean subject. The file can be modified 
			  to get the parameters for individual subjects.

estimateLINRFThresholdsForMeanSubject.m : This file generates the thresholds of the mean subject at the 
			minimum RMSE parameters obtained using estimateBestFitParameters.m. The thresholds 
			are saved in the file modelThresholdsMeanSubject.mat.

modelThresholds.mat: This .mat file contains the thresholds of the LINRF model estimated for a range of values
			of the parameters decisionSigma and surroundValue. The thresholds are estimated at 
			different values of the covariance scalar used for generating the images.

modelThresholdsMeanSubject.mat: This .mat file contains the thresholds of the LINRF model estimated at the 
			minimum RMSE parameters for the mean subject. The thresholds are estimated at 
			different values of the covariance scalar used for generating the images.

subjectThresholds.mat: This file contains the thresholds of the individual subjects at six values of the 
			covariance scalar used in the experiment.
 