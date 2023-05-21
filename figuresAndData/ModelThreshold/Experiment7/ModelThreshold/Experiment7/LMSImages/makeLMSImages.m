clear;

folderName = {'BkgFixedIlluminantScale_0_95_to_1_05', 'BkgFixedIlluminantScale_0_90_to_1_10', ...
    'BkgFixedIlluminantScale_0_85_to_1_15', 'BkgFixedIlluminantScale_0_80_to_1_20', ...
    'BkgFixedIlluminantScale_0_75_to_1_25', 'BkgFixedIlluminantScale_0_70_to_1_30'};

for ii = 1:6
    stimulusFile = load(['/Volumes/G-DRIVE USB/VirtualWorldColorConstancy/', folderName{ii},'/stimulusAMA.mat']);
    LMSImage = reshape(stimulusFile.allDemosaicResponse, 151, 151, 3, 1100);
    LMSImage = LMSImage(1:3:end,1:3:end,:,:);
    LMSImage = reshape(LMSImage,[],1100);
    save(['/Volumes/G-DRIVE USB/Experiment7/LMSImages/', folderName{ii},'.mat'],'LMSImage');
end