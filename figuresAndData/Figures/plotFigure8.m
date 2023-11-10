% This script plots figure 8 (psychometric function) for Experiment 7.
% The script requires Palamedes_1.9.0 toolbox. 
%
% The figure is saved in the folder 
% LightnessConstancy/AnalyzeExperiment6/Figures as Figure4.pdf.
%
% Aug 14 2021: Vijay Singh wrote this.
% Aug 15 2021: Vijay Singh modified this to change names.
% Apr 27 2023: Vijay Singh modified this from equivalent noise paper script.
% May 17 2023: Vijay Singh moved this to Simultaneous Constancy folder.
%
%%
clear; close all;
makeDataForFigure8;

NConditions = 8;
NAcquisition = 3;
%% Plot Figure
hFig = figure();
set(hFig,'units','pixels', 'Position', [100 100 1000 400]);

for rowSubplot = 1
    for colSubplot = 1:NConditions
        subplot(2, NConditions/2, (rowSubplot - 1)*NConditions + colSubplot)
        hold on; box on;
        %% Plot a vertical line indicating the standard
        lStdY = plot([LRFLevels(6) LRFLevels(6)], yLimits,':r','LineWidth', 1);

        covNumber = colSubplot;
        subjectNumber = rowSubplot;
        for iterAcquisition = 1:NAcquisition
            acquisitionNumber = iterAcquisition;
            indexToplot(iterAcquisition) = (subjectNumber-1)*NConditions*NAcquisition + (covNumber - 1)*NAcquisition + acquisitionNumber + 1;       
        end
        
        %% Plot Data 
        
        % Plot proportion comparison
        lData1 = plot(LRFLevels,data(2:end,indexToplot(1))./totalTrial,'r.','MarkerSize',10);
        lData2 = plot(LRFLevels,data(2:end,indexToplot(2))./totalTrial,'gs','MarkerSize',5, 'MarkerFaceColor', 'g');
        lData3 = plot(LRFLevels,data(2:end,indexToplot(3))./totalTrial,'b*','MarkerSize',5);
        
        % Plot Fit Line
        lTh1 = plot(xx, yy(:, indexToplot(1)),'r', 'LineWidth', 1);
        lTh2 = plot(xx, yy(:, indexToplot(2)),'g', 'LineWidth', 1);
        lTh3 = plot(xx, yy(:, indexToplot(3)),'b', 'LineWidth', 1);

        %% Make Figure Pretty
        % Set Limits
        xlim(xLimits);
        ylim(yLimits);
        xticks(LRFLevels);
        hAxis = gca;
        set(hAxis,'FontSize',10);
        hAxis.XTickLabelRotation = 90;

        % Subplot Title
        if (colSubplot == 1)
            switch rowSubplot
                case 1
                    text(0.29, -1.0, 'Observer: 0003', 'Fontsize', 20, 'rotation', 90);
            end
        end        
        
        % Subplot x-Label
        if (colSubplot > 4)
            xlabel('Comparison LRF', 'Fontsize', 10);
        end
        
        % Subplot y-Label
        if (colSubplot == 1 || colSubplot == 5)
            ylabel('Proportion Chosen', 'Fontsize', 10);
        end

        % Subplot legend
        legend([lData1 lData2 lData3],{num2str(threshPal(indexToplot(1)),2), ...
            num2str(threshPal(indexToplot(2)),2), num2str(threshPal(indexToplot(3)),2)},...
            'Location','Southeast','FontSize',10);
        
        % Subplot Title
        if (rowSubplot == 1)
            switch colSubplot
                case 1
                    title('\delta = 0.00 Practice', 'Fontsize', 10);
                case 2
                    title('\delta = 0.00', 'Fontsize', 10);
                case 3
                    title('\delta = 0.05', 'Fontsize', 10);
                case 4
                    title('\delta = 0.10', 'Fontsize', 10);
                case 5
                    title('\delta = 0.15', 'Fontsize', 10);
                case 6
                    title('\delta = 0.20', 'Fontsize', 10);
                case 7
                    title('\delta = 0.25', 'Fontsize', 10);
                case 8
                    title('\delta = 0.30', 'Fontsize', 10);
            end
        end
        
    end
end

save2pdf('Figure8.pdf',gcf,600);
close;