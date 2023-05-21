function curve = estimateVarianceOfStimuliImages(surroundValueTemp)
% Image row/col nPixels
nPixels = 51;
% RF center size
rfCenterRadiusPixels = 10;

RF = repmat(reshape(make2DRF(nPixels, rfCenterRadiusPixels, [1, surroundValueTemp]),[],1),3,1);


load('Experiment7/LMSImages/BkgFixedIlluminantScale_0_95_to_1_05.mat');
Sigma_e0 = cov(LMSImage');
r1 = (RF'*Sigma_e0*RF);

load('Experiment7/LMSImages/BkgFixedIlluminantScale_0_90_to_1_10.mat');
Sigma_e0 = cov(LMSImage');
r2 = (RF'*Sigma_e0*RF);

load('Experiment7/LMSImages/BkgFixedIlluminantScale_0_85_to_1_15.mat');
Sigma_e0 = cov(LMSImage');
r3 = (RF'*Sigma_e0*RF);

load('Experiment7/LMSImages/BkgFixedIlluminantScale_0_80_to_1_20.mat');
Sigma_e0 = cov(LMSImage');
r4 = (RF'*Sigma_e0*RF);

load('Experiment7/LMSImages/BkgFixedIlluminantScale_0_75_to_1_25.mat');
Sigma_e0 = cov(LMSImage');
r5 = (RF'*Sigma_e0*RF);

load('Experiment7/LMSImages/BkgFixedIlluminantScale_0_70_to_1_30.mat');
Sigma_e0 = cov(LMSImage');
r6 = (RF'*Sigma_e0*RF);


%% Fit the filter normalized variance to an exponential to get the noise
% when the delta is 1.

delta = [0.1 0.2 0.3 0.4 0.5 0.6];
curve = fit( delta',[r1 r2 r3 r4 r5 r6]', 'exp1');

hFig = figure; 
set(hFig,'units','pixels', 'Position', [100 100 800 300]);
subplot(1,2,1);
hold on; box on;
plot(delta, [r1 r2 r3 r4 r5 r6],'.b', 'Markersize', 20);
plot(delta, curve(delta'), 'r', 'Linewidth', 2);

xlabel('\delta');
title('linear y-scale');
ylabel('$R^T\cdot \Sigma \cdot R$', 'interpreter', 'latex');
set(gca, 'Fontsize', 20);
xlim([0.1, 0.6]);
legend({'$R^T\cdot \Sigma \cdot R$', ...
    ['(',num2str(curve.a,2),'$)\exp$(',num2str(curve.b,2),'$\delta$)']},...
    'interpreter', 'latex', 'location', 'southeast');

subplot(1,2,2);
hold on; box on;
plot(delta, [r1 r2 r3 r4 r5 r6],'.b', 'Markersize', 20);
plot(delta, curve(delta'), 'r', 'Linewidth', 2);

set(gca, 'yscale', 'log');
title('log y-scale');
xlabel('\delta');
ylabel('$R^T\cdot \Sigma \cdot R$', 'interpreter', 'latex');
set(gca, 'Fontsize', 20);
xlim([0.1, 0.6]);
legend({'$R^T\cdot \Sigma \cdot R$', ...
    ['(',num2str(curve.a,2),'$)\exp$(',num2str(curve.b,2),'$\delta$)']},...
    'interpreter', 'latex', 'location', 'southeast');

save2pdf('ExponentialFitToVarianceData.pdf',gcf,600);
close;

