% This script plots Figure 4 the spectra of chromatic surface reflectance
% functions, their CIE xy chromaticity, and their sRGB renderings.
%
%
% Unknown date: Vijay Singh wrote this.
% April 12 2024: Vijay Singh modified this to write comments.
%
%%

clear;
% Load presimulate data. This data can be generated using the function 
% generateReflectance_xyY_data.m. The function requires some functions and
% datasets from the virtualworldcolorconstancy repository.

load('Reflectance_data.mat');

%%
fig=figure;
set(fig,'Position', [100, 100, 600, 1400]);
FS = 10;
FSTitle = 10;

%% Plot figures
for iterCovScaleFactor = 1:6
    newSurfaces = squeeze(reflectance_data(iterCovScaleFactor, : , :));
    SurfacexyY = squeeze(chromaticity_data(iterCovScaleFactor, : , :));
    theSurfaceImage = squeeze(surfaceColor_data(iterCovScaleFactor, : , :, :));

    subplot(6, 3, (iterCovScaleFactor-1)*3 + 1);
    hold on;
    box on; axis square;
    for ii = 1 : size(newSurfaces,2)
        rescaledFig = plot(SToWls(S), newSurfaces(:,ii),'k','Linewidth', 0.1);
    end
    ylim([0 1]);
    yticks([0:0.2:1]);
    yticklabels({'0.0' '0.2' '0.4' '0.6' '0.8' '1.0'});
    xlabel('Wavelength (nm)','FontSize',FS);
    ylabel('Reflectance','FontSize',FS)
    set(gca,'FontSize',FS);
    set(gca,'FontSize',FS);
    title(['\sigma^2 = ', num2str(covScaleFactor(iterCovScaleFactor))]);
    
    %%
    subplot(6, 3, (iterCovScaleFactor-1)*3 + 2);
    hold on;
    box on; axis square;
    if iterCovScaleFactor == 6
        plot(xyYSurall(1,:),xyYSurall(2,:),'kx', 'Linewidth', 0.5, 'MarkerSize', 2);
    end
    plot(SurfacexyY(1,:),SurfacexyY(2,:),'r.','MarkerFaceColor','r');
    xlabel('CIE x chromaticity','FontSize',FS);
    ylabel('CIE y chromaticity','FontSize',FS)
    set(gca,'FontSize',FS);
    xlim([0.15, 0.55]);
    ylim([0.15, 0.55]);
    %     legend({'Natural reflectance','Random samples'}, 'Location', 'southeast','FontSize',10);
    axis square;
    title(['\sigma^2 = ', num2str(covScaleFactor(iterCovScaleFactor))]);
    
    %%
    subplot(6, 3, (iterCovScaleFactor-1)*3 + 3);
    hold on;
    axis square;
    image(theSurfaceImage);
    xlim([0.5 10.5]);
    ylim([0.5 10.5]);
    set(gca,'FontSize',FS);
    axis off;
    title(['\sigma^2 = ', num2str(covScaleFactor(iterCovScaleFactor),3)]);
    
end

save2pdf('Figure4.pdf', gcf, 300);
