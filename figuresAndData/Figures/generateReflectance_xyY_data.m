% What do I want to do
% 1. Assemeble all the reflectance and illumination datasets
% 2. Generate figures
%
% Clear
clear;

% Desired wl sampling
nSurfaces = 100;

S = [400 5 61];
theWavelengths = SToWls(S);
% Munsell surfaces
load sur_nickerson
sur_nickerson = SplineSrf(S_nickerson,sur_nickerson,S);

% Vhrel surfaces
load sur_vrhel
sur_vrhel = SplineSrf(S_vrhel,sur_vrhel,S);

% Put them together
sur_all = [sur_nickerson sur_vrhel];
sur_mean=mean(sur_all,2);
sur_all_mean_centered = bsxfun(@minus,sur_all,sur_mean);

%% Analyze with respect to a linear model
B = FindLinMod(sur_all_mean_centered,6);
sur_all_wgts = B\sur_all_mean_centered;
mean_wgts = mean(sur_all_wgts,2);
cov_wgts = cov(sur_all_wgts');
covScaleFactor = [0 0.01 0.03 0.10 0.30 1.00];
otherObjectReflectancesGray = 0;

reflectance_data = zeros (6, 61, 100);
chromaticity_data = zeros (6, 3, 100);
surfaceColor_data = zeros (6, 10, 10, 3);

for iterCovScaleFactor = 1:6
    cov_wgts_loop = cov_wgts*covScaleFactor(iterCovScaleFactor);
    
    %% Generate some new surfaces
    newSurfaces = zeros(S(3),nSurfaces);
    newIndex = 1;
    
    % makeOtherObjectReflectance(nOtherObjectSurfaceReflectance,otherObjectFolder,'covScaleFactor', covScaleFactor, 'otherObjectReflectancesGray', otherObjectReflectancesGray);
    
    for i = 1:nSurfaces
        OK = false;
        while (~OK)
            ran_wgts = mvnrnd(mean_wgts',cov_wgts_loop)';
            ran_sur = B*ran_wgts+sur_mean;
            if (all(ran_sur >= 0) & all(ran_sur <= 1))
                if otherObjectReflectancesGray
                    ran_sur = mean(ran_sur)*ones(size(ran_sur));
                end
                newSurfaces(:,newIndex) = ran_sur;
                newIndex = newIndex+1;
                OK = true;
            end
        end
    end
    
    %% Load in the T_xyz1931 data for luminance sensitivity
    theXYZData = load('T_xyz1931');
    theLuminanceSensitivity = SplineCmf(theXYZData.S_xyz1931,theXYZData.T_xyz1931,theWavelengths);
    theLuminanceSensitivityIll = SplineCmf(theXYZData.S_xyz1931,theXYZData.T_xyz1931,theWavelengths);
    
    %% Compute XYZ
    SurfaceXYZ = theLuminanceSensitivityIll*newSurfaces;
    SurfacexyY = XYZToxyY(SurfaceXYZ);
    XYZsurAll = theLuminanceSensitivity*sur_all;
    xyYSurall = XYZToxyY(XYZsurAll);
    
    %% Convert to linear SRGB
    SRGBPrimaryIll = XYZToSRGBPrimary(SurfaceXYZ);% Primary Illuminance
    SRGBPrimaryNormIll = SRGBPrimaryIll/24.7413;
    SRGBIll = SRGBGammaCorrect(SRGBPrimaryNormIll,false)/255;
    
    
    %% Reshape the matrices for plotting as squares
    for ii =1 :10
        for jj= 1:10
            theSurfaceImage(ii,jj,:)=SRGBIll(:,(ii-1)*10+jj);
        end
    end
    reflectance_data(iterCovScaleFactor, :, :)  = newSurfaces;
    chromaticity_data(iterCovScaleFactor, :, :) = SurfacexyY;
    surfaceColor_data(iterCovScaleFactor, :, :,:) = theSurfaceImage;
end

if otherObjectReflectancesGray
save('Reflectance_data_gray.mat', 'S', 'covScaleFactor', 'otherObjectReflectancesGray', ...
    'reflectance_data', 'chromaticity_data', 'surfaceColor_data');
else
    save('Reflectance_data.mat', 'S', 'covScaleFactor', 'otherObjectReflectancesGray', ...
    'reflectance_data', 'chromaticity_data', 'surfaceColor_data', 'xyYSurall');
end