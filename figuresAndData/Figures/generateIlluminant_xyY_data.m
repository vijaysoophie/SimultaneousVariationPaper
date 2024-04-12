% Illuminance Generation example

% Clear
clear; close all;

% Desired wl sampling
nIlluminances = 100;
bMakeD65 = 1;
scaling = 1;
maxMeanIlluminantLevel = [1, 1.05, 1.10, 1.15, 1.20, 1.25, 1.3];
minMeanIlluminantLevel = [1, 0.95, 0.90, 0.85, 0.80, 0.75, 0.7];
covScaleFactor = 0;
delta_values = [0, 0.05, 0.10, 0.15, 0.20, 0.25, 0.30];

illuminant_data = zeros (7, 61, 100);
chromaticity_data = zeros (7, 3, 100);
illuminantColor_data = zeros (7, 10, 10, 3);

%%
S = [400 5 61];
theWavelengths = SToWls(S);
%% Load Granada Illumimace data
load daylightGranadaLong
daylightGranadaOriginal = SplineSrf(S_granada,daylightGranada,S);

% Rescale spectrum by its mean
meanDaylightGranada = mean(daylightGranadaOriginal);
daylightGranadaRescaled = bsxfun(@rdivide,daylightGranadaOriginal,meanDaylightGranada);

%% Center the data for PCA
meandaylightGranadaRescaled = mean(daylightGranadaRescaled,2);
daylightGranadaRescaledMeanSubtracted = bsxfun(@minus,daylightGranadaRescaled,meandaylightGranadaRescaled);

%% Get D65
theIlluminantData = load('spd_D65');
D65Illuminant = SplineSpd(theIlluminantData.S_D65,theIlluminantData.spd_D65,theWavelengths);
D65Illuminant = D65Illuminant/mean(D65Illuminant);

%% Analyze with respect to a linear model
B = FindLinMod(daylightGranadaRescaledMeanSubtracted,6);
ill_granada_wgts = B\daylightGranadaRescaledMeanSubtracted;
mean_wgts = mean(ill_granada_wgts,2);
cov_wgts = cov(ill_granada_wgts');
cov_wgts = cov_wgts*covScaleFactor;

%% Mean to be added
if (bMakeD65)
    meanIlluminant = D65Illuminant;
else
    meanIlluminant = meandaylightGranadaRescaled;
end

for iterScale = 1:7
    %% Generate scales
    nNewIlluminaces = nIlluminances;
    if scaling
        scales = generateLogUniformScales(nNewIlluminaces, ...
            maxMeanIlluminantLevel(iterScale), minMeanIlluminantLevel(iterScale));
    end
    
    %% Generate some new illuminants
    
    newIlluminance = zeros(S(3),nNewIlluminaces);
    newIndex = 1;
    
    for i = 1:nNewIlluminaces
        OK = false;
        while (~OK)
            ran_wgts = mvnrnd(mean_wgts',cov_wgts)';
            ran_ill = B*ran_wgts+meanIlluminant;
            if (all(ran_ill >= 0))
                newIlluminance(:,newIndex) = ran_ill*scales(newIndex);
                
                newIndex = newIndex+1;
                OK = true;
            end
        end
        %     filename = sprintf('illuminance_%03d.spd',i);
        %     fid = fopen(fullfile(folderToStore,filename),'w');
        %     fprintf(fid,'%3d %3.6f\n',[theWavelengths,newIlluminance(:,i)]');
        %     fclose(fid);
    end
    
    %%
    wgts_New=B'*bsxfun(@minus,newIlluminance,meandaylightGranadaRescaled);
    %% Load in the T_xyz1931 data for luminance sensitivity
    theXYZData = load('T_xyz1931');
    theLuminanceSensitivity = SplineCmf(theXYZData.S_xyz1931,theXYZData.T_xyz1931,theWavelengths);
    theLuminanceSensitivityIll = SplineCmf(theXYZData.S_xyz1931,theXYZData.T_xyz1931,theWavelengths);
    
    %% Compute XYZ
    IlluminantXYZ = theLuminanceSensitivityIll*newIlluminance;
    IlluminantxyY = XYZToxyY(IlluminantXYZ);
    IlluminantXYZGranada = theLuminanceSensitivity*daylightGranadaRescaled;
    IlluminantxyYGranada = XYZToxyY(IlluminantXYZGranada);
    
    %% Convert to linear SRGB
    SRGBPrimaryIll = XYZToSRGBPrimary(IlluminantXYZ); % Primary Illuminance
    SRGBPrimaryNormIll = SRGBPrimaryIll/27.6557;
    SRGBIll = SRGBGammaCorrect(SRGBPrimaryNormIll,false)/255;
    
    %% Reshape the matrices for plotting as squares
    
    for ii =1 :10
        for jj= 1:10
            theIlluminationImage(ii,jj,:)=SRGBIll(:,(ii-1)*10+jj);
        end
    end
    
    illuminant_data(iterScale, :,:) = newIlluminance;
    chromaticity_data(iterScale, :,:)  = IlluminantxyY;
    illuminantColor_data(iterScale, :,:,:)  = theIlluminationImage;
end

% save('Illuminant_data.mat', 'S', 'delta_values', ...
%     'illuminant_data', 'chromaticity_data', 'illuminantColor_data');