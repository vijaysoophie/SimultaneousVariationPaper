% This script plots figure 8 (psychometric function) for Experiment 6.
% The script requires Palamedes_1.9.0 toolbox.
%
% The figure is saved in the folder
% LightnessConstancy/AnalyzeExperiment6/Figures as Figure8.pdf.
%
% Aug 14 2021: Vijay Singh wrote this.
% Aug 15 2021: Vijay Singh modified this to change names.
% Apr 27 2023: Vijay Singh modified this from equivalnet noise paper script.
%
%%
clear; close all;
makeDataForFigure8;

NConditions = 10;
NAcquisition = 3;

subjectNames = {'0003', 'bagel', 'committee', 'content', 'observer', 'revival'};

for subjectNumber = 1:6
    %% Plot Figure
    hFig = figure();
    set(hFig,'units','pixels', 'Position', [100 100 1600 400]);
    for covNumber = 1:NConditions
        for iterAcquisition = 1:NAcquisition
            acquisitionNumber = iterAcquisition;
            indexToplot(iterAcquisition) = (subjectNumber-1)*NConditions*NAcquisition + (covNumber - 1)*NAcquisition + acquisitionNumber + 1;
        end
        
        %%
        % Subplot Title
            switch covNumber
                case 1
                    subplot(2, 6, 1);
                    hold on; box on;
                    ylabel('Proportion Chosen', 'Fontsize', 10);
                    title('\sigma^2 = 0.00 Practice', 'Fontsize', 10);
                    text(0.29, -1, ['Observer: ', subjectNames{subjectNumber}], 'Fontsize', 20, 'rotation', 90);    
                case 2
                    subplot(2, 6, 7);
                    hold on; box on;
                    ylabel('Proportion Chosen', 'Fontsize', 10);
                    title('\sigma^2 = 0.00', 'Fontsize', 10);                    
                case 3
                    subplot(2, 6, 8);
                    hold on; box on;
                    title('\sigma^2 = 0.01', 'Fontsize', 10);
                case 4
                    subplot(2, 6, 9);
                    hold on; box on;
                    title('\sigma^2 = 0.03', 'Fontsize', 10);
                case 5
                    subplot(2, 6, 3);
                    hold on; box on;
                    title('\sigma^2 = 0.03 Achromatic', 'Fontsize', 10);
                case 6
                     subplot(2, 6, 10);
                    hold on; box on;
                   title('\sigma^2 = 0.10', 'Fontsize', 10);
                case 7
                    subplot(2, 6, 11);
                    hold on; box on;
                    title('\sigma^2 = 0.30', 'Fontsize', 10);
                case 8
                    subplot(2, 6, 5);
                    hold on; box on;
                    title('\sigma^2 = 0.30 Achromatic', 'Fontsize', 10);
                case 9
                    subplot(2, 6, 12);
                    hold on; box on;
                    title('\sigma^2 = 1.00', 'Fontsize', 10);
                case 10
                    subplot(2, 6, 6);
                    hold on; box on;
                    title('\sigma^2 = 1.00 Achromatic', 'Fontsize', 10);
            end

        
        
        %% Plot Data
        % Plot a vertical line indicating the standard
        lStdY = plot([LRFLevels(6) LRFLevels(6)], yLimits,':r','LineWidth', 1);
        
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
        
        xlabel('Comparison LRF', 'Fontsize', 10);
                
        % Subplot legend
        legend([lData1 lData2 lData3],{num2str(threshPal(indexToplot(1)),2), ...
            num2str(threshPal(indexToplot(2)),2), num2str(threshPal(indexToplot(3)),2)},...
            'Location','Southeast','FontSize',10);
        
    end
    if subjectNumber == 1
        save2pdf(['Figure8.pdf'],gcf,600);
    end
        save2pdf(['PsychometricFunctions/Experiment6/Exp6_',subjectNames{subjectNumber},'.pdf'],gcf,600);
    close;
end

