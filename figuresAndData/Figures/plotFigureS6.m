% This script plots Figure S6 (psychometric function all observers) for Experiment 8.
% The script requires Palamedes_1.9.0 toolbox. 
%
% The figure is saved in the folder 
% LightnessConstancy/AnalyzeExperiment6/Figures as Figure4.pdf.
%
% Aug 14 2021: Vijay Singh wrote this.
% Aug 15 2021: Vijay Singh modified this to change names.
% Apr 27 2023: Vijay Singh modified this from equivalnet noise paper script.
% May 17 2023: Vijay Singh modified this added Simultaneous Constancy paper folder.
%
%%
clear; close all;
makeDataForFigure10;

conditionOrder = [1 2 4 6 3 5 7];
conditionName = {'No Variation \newline   Practice';... % Condition Order 1
             'No Variation';                     ... % Condition Order 2
             'Backgroung Variation \newline          Chromatic';... % Condition Order 6
             'Backgroung Variation \newline         Achromatic';... % Condition Order 5
             'Light Intensity \newline    Variation';... % Condition Order 4
             'Simultaneous Variation \newline         Chromatic';... % Condition Order 3
             'Simultaneous Variation \newline        Achromatic'};   % Condition Order 7}

NConditions = 7;
NAcquisition = 3;
%% Plot Figure
hFig = figure();
set(hFig,'units','pixels', 'Position', [100 100 1600 1200]);

for rowSubplot = 1:6
    for colSubplot = 1:NConditions
        subplot(6, NConditions, (rowSubplot - 1)*NConditions + colSubplot)
        hold on; box on;
        %% Plot a vertical line indicating the standard
        lStdY = plot([LRFLevels(6) LRFLevels(6)], yLimits,':r','LineWidth', 1);

        covNumber = conditionOrder(colSubplot);
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
                    text(0.19, 0.5, 'Observer 0003', 'Fontsize', 20);
                case 2
                    text(0.19, 0.5, 'Observer Bagel', 'Fontsize', 20);
                case 3
                    text(0.19, 0.5, 'Observer Content', 'Fontsize', 20);
                case 4
                    text(0.19, 0.5, 'Observer Oven', 'Fontsize', 20);
                case 5
                    text(0.19, 0.5, 'Observer Manos', 'Fontsize', 20);
                case 6
                    text(0.19, 0.5, 'Observer Revival', 'Fontsize', 20);
            end
        end
        
        % Subplot x-Label
        if (rowSubplot == 1)
            xlabel('Comparison LRF', 'Fontsize', 10);
        end
        
        % Subplot y-Label
        if (colSubplot == 1)
            ylabel('Proportion Chosen', 'Fontsize', 10);
        end

        % Subplot legend
        legend([lData1 lData2 lData3],{num2str(threshPal(indexToplot(1)),2), ...
            num2str(threshPal(indexToplot(2)),2), num2str(threshPal(indexToplot(3)),2)},...
            'Location','Southeast','FontSize',6);
        
        % Subplot Title
        if (rowSubplot == 1)
            switch colSubplot
                case 1
                    title(conditionName(colSubplot), 'Fontsize', 10);
                case 2
                    title(conditionName(colSubplot), 'Fontsize', 10);
                case 3
                    title(conditionName(colSubplot), 'Fontsize', 10);
                case 4
                    title(conditionName(colSubplot), 'Fontsize', 10);
                case 5
                    title(conditionName(colSubplot), 'Fontsize', 10);
                case 6
                    title(conditionName(colSubplot), 'Fontsize', 10);
                case 7
                    title(conditionName(colSubplot), 'Fontsize', 10);
            end
        end
        
    end
end


save2pdf('FigureS6.pdf',gcf,600);
close;