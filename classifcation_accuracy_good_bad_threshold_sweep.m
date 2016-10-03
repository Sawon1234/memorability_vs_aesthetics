% -------------------------------------------------------------------------
% This file computes the classification accuracy between good and bad
% aesthetic images with a sweeping threshold. 
% -------------------------------------------------------------------------
clc; clear; close all; 

%% Load the necessary files 
load ('predictedScores_aesthetics.mat'); % Loads predictedScores
load ('testSet.mat'); % Loads testSetImageLabels

%% Configuration Settings 
thresholdStepSize  = 0.05; 

%% Do for a sweeping threshold 
% Printing the header 
fprintf ('\n Full Accuracy \t Good Accuracy \t Bad Accuracy \t Threshold value'); 

% Find good and bad images in the ground truth 
getOrigGoods = find (testSetImageLabels == 2); 
getOrigBads = find (testSetImageLabels == 0); 

count = 1; 
for tau = 0:thresholdStepSize:1
    % Match and compute the classification score 
    temp1 = 0; 
    for i = 1:1:length(getOrigGoods)
        if (predictedScores(getOrigGoods(i)) >= tau)
            temp1 = temp1 + 1; 
        end
    end
    
    temp2 = 0; 
    for i = 1:1:length(getOrigBads)
        if (predictedScores(getOrigBads(i)) < tau)
            temp2 = temp2 + 1; 
        end
    end
    
    classificationScore(count,1) = (temp1 + temp2) / (length(getOrigGoods) + length(getOrigBads));
    classificationScore(count,2) = temp1 / length(getOrigGoods);
    classificationScore(count,3) = temp2 / length(getOrigBads);
    
    % Printing
    fprintf ('\n %d \t %d \t %d \t %d',classificationScore(count,1) * 100, ...
        classificationScore(count,2) * 100, classificationScore(count,3) * 100, tau); 
    
    count = count + 1; 
end


