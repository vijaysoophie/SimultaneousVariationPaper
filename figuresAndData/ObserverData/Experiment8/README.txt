This folder has two files
1. proportionComparisonChosen.csv
2. subjectThreshold.csv

1. proportionComparisonChosen.csv contain the response data for each observer.
The data is arranged according the name of the observer.
For each observer we provide the number of times the observer chose the 
comparison image to have the target with the higher lightness. 
The first column gives the lightness level of the comparison target in LRF.
The standard target was at 0.4 LRF.

The data was collected three times at each condition. There were 6 conditions and the subject selection condition, so a total of 7 conditions.

2. subjectThreshold.csv contains the threshold for each subject. 
The thresholds were obtained by fitting the proportion comparison chosen
data with a cumulative gaussian using the palamedes toolbox.
The first column gives the name of the condition.
Each row gives the subject threshold these conditions.
The three thresholds at each covariance scalar are for the three acquisitions.



