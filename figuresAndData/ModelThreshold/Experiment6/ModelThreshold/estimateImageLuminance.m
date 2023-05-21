% Estimate average luminance of images and target objects used in the
% experiment. 
%
% This script estimates the average luminance of the standard image in the 
% simplest case (covariance scale factor zero). It also estimates the
% average luminance of the target object for all LRF values. 
%
% To estimate the luminance we first calculate the monitor settings values. 
% These correspond to the gamma corrected values of the primaries that 
% needs to be applied to the monitor for producing the required LMS 
% response for the standard observer. To do this we use the LMS struct that
% has the LMS images.
% We then use the tristimulus values of the 1931 standard observer and the 
% calibration struct to get the conversion matrix required to convert
% settings values to CIE-XYZ color coordiantes. The luminance is read as
% the Y coordinate.
%
% Sep 04, 2021: Vijay Singh wrote this.
% May 09, 2023: Vijay Singh modified this.
%%
clear;

% Scale factor used in the experiment
scaleFactor = 8;

%% Load the calibration struct from the saved data
pathToFile = fullfile('dataForLuminanceEstimation', 'CN_AT_0003_Condition_0_00_Iteration_1-1.mat');
load(pathToFile);
cal = data.cal;

%% Get the LMS struct for the simplest case cov_0.00
LMSStruct = data.LMSStruct;


%% Initialize calibration structure for the cones
calLMS = SetSensorColorSpace(cal, LMSStruct.T_cones, LMSStruct.S); % Fix the last option

%% Set Gamma Method
calLMS = SetGammaMethod(calLMS,0);

%% Convert LMS image to monitor settings image using calibration struct and scale factor
LMSImageInCalFormat = LMSStruct.LMSImageInCalFormat;
LMSImageInCalFormat = reshape(LMSImageInCalFormat, 3, []);
imageInSettings = SensorToSettings(calLMS, scaleFactor*LMSImageInCalFormat);


%% Convert from monitor settings to CIE-XYZ
load T_xyz1931
settingsToXYZConversionConstant = 683;
T_xyz = settingsToXYZConversionConstant*T_xyz1931; S_xyz = S_xyz1931;
calXYZ = SetSensorColorSpace(calLMS,T_xyz,S_xyz);

imagesInXYZ = calXYZ.M_device_linear*imageInSettings;

%% Cal format to image 
XYZImages = reshape(imagesInXYZ, 3, LMSStruct.cropImageSizeX, LMSStruct.cropImageSizeY, length(LMSStruct.luminanceLevels));

%% Mean luminance of standard image
indexForLuminance = 2; % Index of Y
NImagesPerLevel = length(LMSStruct.luminanceLevels)/11;
imagesInXYZ = reshape(imagesInXYZ,3,[],11*NImagesPerLevel);
stdImageIndex = 6; % Index of standard image
stdImageIndex = (stdImageIndex-1)*NImagesPerLevel+1:stdImageIndex*NImagesPerLevel;     % Index of standard image if there are more than one images per level
meanStandard = mean(mean(imagesInXYZ(indexForLuminance, : , stdImageIndex)));

%% Make a mask for the target
maskImage = zeros(LMSStruct.cropImageSizeX, LMSStruct.cropImageSizeY);
center = 101;
radius = 47;

for ii = 1:201
    for jj = 1:201
        if ((ii - center)^2 + (jj - center)^2 < radius^2)
            maskImage(ii, jj) = 1;
        end
    end
end

maskImage(maskImage ==0) = NaN;

%% Mean luminance of target objects in the images
YImagesOfTarget = squeeze(XYZImages(indexForLuminance,:,:,:)).*repmat(maskImage,1,1,11*NImagesPerLevel);

meanYOfTarget = mean(reshape(nanmean(nanmean(YImagesOfTarget)),NImagesPerLevel,11),1);

%% Display results
clc;
display(['Mean luminance of standard images in cd/m^2 is ', num2str(meanStandard, 4)]);
display(['Mean luminance of target objects in cd/m^2 are ', newline,num2str(meanYOfTarget, 4)]);