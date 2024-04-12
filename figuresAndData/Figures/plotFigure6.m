% This script plots Figure 6 the spectra of illumination spectra, their 
% CIE xy chromaticity, and their sRGB renderings.
%
%
% Unknown date: Vijay Singh wrote this.
% April 12 2024: Vijay Singh modified this to write comments.
%
%%

clear;
% Load presimulate data. This data can be generated using the function 
% generateIlluminant_xyY_data.m. The function requires some functions and
% datasets from the virtualworldcolorconstancy repository.

load('Illuminant_data.mat');

%%
fig=figure;
set(fig,'Position', [100, 100, 600, 1400]);
FS = 10;
FSTitle = 10;

%% Plot figures
for iterScale = 1:7
    newIlluminance = squeeze(illuminant_data(iterScale, :,:));
    IlluminantxyY = squeeze(chromaticity_data(iterScale, :,:));
    theIlluminationImage = squeeze(illuminantColor_data(iterScale, :,:,:));
    FS = 10;
    FSTitle = 10;
    
    subplot(7, 3, (iterScale-1)*3+1);
    box on; axis square; hold on;
    for ii = 1 : size(newIlluminance,2)
        rescaledFig2 = plot(SToWls(S),newIlluminance(:,ii),'k');
        rescaledFig2.Color(4)=0.2;
    end
    ylim([0 2]);
    yticks([0 0.5 1 1.5 2]);
    yticklabels({'0.0' '0.5' '1.0' '1.5' '2.0'});
    xlabel('Wavelength (nm)','FontSize',FS);
    ylabel('Normalized Irradiance','FontSize',FS)
    set(gca,'FontSize',FS);
    axis square;
    title(['\delta = ', num2str(delta_values(iterScale))]);
    
    subplot(7, 3, (iterScale-1)*3+2);
    hold on; box on;
    %     plot(IlluminantxyYGranada(1,:),IlluminantxyYGranada(2,:),'k.');
    plot([1:100],sort(IlluminantxyY(3,:)),'r.','MarkerSize',10);
    xlabel('sorted index','FontSize',FS);
    ylabel('CIE Y chromaticity','FontSize',FS);
    %     xlim([0.15, 0.55]);
    ylim([15, 30]);
    set(gca,'FontSize',FS);
    axis square;
    title(['\delta = ', num2str(delta_values(iterScale))]);
    
    subplot(7, 3, (iterScale-1)*3+3);
    image(theIlluminationImage);
    set(gca,'FontSize',FS);
    axis square;
    %     axis off;
    box on;
    title(['\delta = ', num2str(delta_values(iterScale))]);
end

save2pdf('Figure6.pdf', gcf, 300);