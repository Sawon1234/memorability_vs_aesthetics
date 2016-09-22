% -------------------------------------------------------------------------
% This file computes the aesthetics scores and measures pairwise ranking
% ratio in comparison to the ground truth !!
% -------------------------------------------------------------------------
clc; clear; close all; 

%% Add Paths 
addpath('/home/sukrit/Desktop/caffe-master/matlab');

% -------------------------------------------------------------------------
%% Configuation Settings 
% Set the GPU Mode 
caffe.set_mode_gpu();          
caffe.set_device(0); % We will use the first gpu

% Load the model and the deploy file
net_weights = 'initModel.caffemodel'; 
net_model = 'initModel.prototxt'; 
meanImg = 'mean_AADB_regression_warp256.binaryproto';
mean_file = caffe.io.read_mean(meanImg);
phase = 'test'; % phase = 'train' will do dropout (random with a prob of 0.5)

% Image Dimensions
IMAGE_DIM = 256;
CROPPED_DIM = 227;

% Folder for accessing the images
inputFolder = '../../../DATASETS/eyeEM/dataset_aesthetics_resized_change_ar_jpg/'; 

% Ranking Points - In the groundtruth 
rankPoints = [0,1,2]; % Do in ascending order 

% Compute ranking accuracy only 
computeRankingAccuracyDirectly = 0; 

% -------------------------------------------------------------------------
%% Get the test set image names 
if (computeRankingAccuracyDirectly == 0)
    count = 1; 
    fid = fopen ('testSet.txt','a+'); 
    tline = fgets(fid); 
    while ischar(tline)
        temp = strsplit (tline, ' ');
        testSetImageNames{count} = temp{1}; 
        testSetImageLabels(count) = str2num(temp{2}); 
        count = count + 1; 
        clear temp; 

        tline = fgets(fid);
    end
    fclose(fid); 
    save ('testSet.mat','testSetImageNames','testSetImageLabels'); 
end

% -------------------------------------------------------------------------
%% Do the inference over the dataset  
if (computeRankingAccuracyDirectly == 0)
    % Load the Net 
    net = caffe.Net(net_model, net_weights, phase);

    for i = 1:1:length(testSetImageNames)
        % Prepare the input
        im = imread(strcat(inputFolder,char(testSetImageNames{i})));
        
        % Do the following for the mean instead of this
        % input_data = {prepare_image(im,IMAGE_DIM,CROPPED_DIM,mean_file.image_mean)}; 
        if numel(size(im)) == 2
            im = repmat(im, [1,1,3]);
        end
        im = imresize(im, [CROPPED_DIM CROPPED_DIM]);
        im = im(:, :, [3, 2, 1]); % convert from RGB to BGR
        im = permute(im, [2, 1, 3]); % permute width and height
        im = single(im); % convert to single precision
        input_data = {single(im) - mean_file(15:241,15:241,:)};    % subtract mean

        % We do inference with images (instead of the LMDB - Due to croppin
        % differences, the output probabilities migth differ a bit)
        scores = net.forward(input_data);
        predictedScoresAll(i,:) = scores'; 
        scores = scores{1};
        scores = mean(scores, 2);  % take average scores over 10 crops
        if (scores > 1)
            scores = 1;
        elseif (scores < 0)
            scores = 0;
        end

        % Store the predicted scores 
        predictedScores(i) = scores; 

        % Print the progress
        fprintf ('Predicting Scores - Image %d \n',i); 

        % Clear the variables 
        clear im input_data scores; 
    end

    % Save the predicted scores 
    save ('predictedScores.mat','predictedScores','predictedScoresAll'); 
end

% -------------------------------------------------------------------------
%% Calculate the accuracy (ranking)
load ('predictedScores.mat'); % Loads predictedScores
load ('testSet.mat'); % testSetImageNames, testSetImageLabels

% We do it in a computational efficient manner 
% We have the predictedScores and testSetImageLabels
% For all combinations in the rankPoints 
totalOrderings = 0; 
correctOrderings = 0; 
for i = 1:1:length(rankPoints)
    for j = i+1:1:length(rankPoints)
        temp = find (testSetImageLabels == rankPoints(i));
        lowerRankArray_labels = testSetImageLabels(temp);
        lowerRankArray_predictions = predictedScores(temp); 
        clear temp; 
        
        temp = find (testSetImageLabels == rankPoints(j));
        higherRankArray_labels = testSetImageLabels(temp); 
        higherRankArray_predictions = predictedScores(temp); 
        clear temp; 
        
        % Call the function that calculates the correct number of orderings
        [totalOrderingsComb,correctOrderingsComb] = findCorrectOrderings(...
            lowerRankArray_predictions,higherRankArray_predictions); 
        
        % Total ordering cases 
        totalOrderings = totalOrderings + totalOrderingsComb; 
        
        % Correct ordering cases
        correctOrderings = correctOrderings + correctOrderingsComb; 
        
        % Clear the variables
        clear lowerRankArray_labels  lowerRankArray_predictions  ...
            higherRankArray_labels  higherRankArray_predictions; 
        
        % Print the progress
        fprintf ('\n Done order counting for rankPoints combination [%d, %d] ---- Combination Accuracy = %d / %d = %f',...
            i,j,correctOrderingsComb,totalOrderingsComb,correctOrderingsComb / totalOrderingsComb); 
    end
end

% -------------------------------------------------------------------------
%% Compute the total accuracy 
accuracy = correctOrderings / totalOrderings; 
fprintf ('\n -----------------------------------------------------'); 
fprintf ('\n The total accuracy = [%d / %d] = %f',correctOrderings,totalOrderings,accuracy); 
fprintf ('\n -----------------------------------------------------'); 











