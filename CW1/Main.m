% Main File
% tic toc here is to measure the elapsed time for each program run in order
% to assess the performance
tic
iris_data = load('fisheriris.mat');
X = iris_data.meas;
Y = iris_data.species;
%Mean folds error of ALL folds for one particular model
global e;
e = 0;



% --- Draw all Iris points ---
% the sepal width has been taken out, but ONLY for the visualisation
% sepal_length = X(:,1);
% petal_length = X(:,3);
% petal_width = X(:,4);
% scatter3(sepal_length, petal_length, petal_width, 'MarkerEdgeColor', 'green'); 
% hold on;
% 
% xlabel('sepal length (cm)');
% ylabel('petal length (cm)');
% zlabel('petal width (cm)');
% title('Iris species prediction using knn and linear classification');



% ------------------------------- U.I. ------------------------------------

% STEP 1: Choose Outer split: n/(150-n)
%         Divide data set into Training-Validation data set and Test data set
%         n input entries for the training set, 150-n for the Test set
%         150-n and n must both be divisible by 3 because data divided in 3
%         species sets of 50 Iris each.
%         Possible values: n = 15,30,45,60,75,90,105,120,135
n = input('Choose n for the outer split n/(150-n):  \n');
fprintf('\n ');

% n input entries for the Training-Validation set
nTrain = n/3;
A = X(1:nTrain,:);
B = X(51:(50+nTrain),:);
C = X(101:(100+nTrain),:);
D = Y(1:nTrain,:);
E = Y(51:(50+nTrain),:);
F = Y(101:(100+nTrain),:);
%Note that this data set will be randomly shuffled
%Training-Validation Set:
xTrainingMeas = [A;B;C];
yTrainingSpecies = [D;E;F];

%150-n unused input entries for the final test set
nTest = (150-n)/3;
I = X((50-nTest+1):50,:);
J = X((100-nTest+1):100,:);
K = X((150-nTest+1):150,:);
L = Y((50-nTest+1):50,:);
M = Y((100-nTest+1):100,:);
N = Y((150-nTest+1):150,:);
%This data set will NOT be shuffled. It will only be used once at the end,
%to test the model
%Test Set:
xTestMeas = [I;J;K];
yTestRealVal = [L;M;N];
%The string values of this iris species test set (setosa, versicolor and
%virginica) are converted to the values 1,2 and 3 respectively
yTestRealVal = convert_to_ID(yTestRealVal);

% STEP 2: Inner split: p/(n-p)
%         Make new training sets & validation sets in a randomly manner 
%         for a given p/(n-p) split, where n was the value chosen for the
%         outer split and p is the value to be chosen for the inner split.
p = input('Choose p for the inner split  p/(n-p):  \n');
fprintf('\n ');

% STEP 3: choose number of training data folds
folds = input('How many times do you want to train your model? \n');
fprintf('\n ');

% STEP 4: pick your model
entry = input('Model: linear or knn?   ---> type 1 or 2 \n');
fprintf('\n ');
if entry == 2
    % STEP 4B: choose k
        k = input('Enter k:  \n');
        fprintf('\n ');
end
fprintf('\n ');

%--------------------------------------------------------------------------




% This for loop below is used for automation of the tests ONLY
% Please take out for better visualisation of the scatter plot
total_test_mean = 0;
total_validation_mean = 0;
for a = 1:10
    
    % --- Build different random sets for each fold ---
    % Transform the meas/species data split into a training/validation data split
    for i = 1:folds
        [trainSet,validSet] = make_training_sets(xTrainingMeas,yTrainingSpecies,n,p);
        % Training sets and Validation sets visualisation
    %     disp('training set'), disp('      X1        X2        X3        X4         Y');
    %     disp([trainSet(:,1),trainSet(:,2),trainSet(:,3),trainSet(:,4), trainSet(:,5)]);
    % 
    %     disp('validation set'), disp('      X1        X2        X3        X4         Y');
    %     disp([validSet(:,1),validSet(:,2),validSet(:,3),validSet(:,4),validSet(:,5)]);
        % Chosen model
        if entry == 1
            model = fitcecoc(trainSet(:,1:4),trainSet(:,5));  
        else
            model = fitcknn(trainSet(:,1:4),trainSet(:,5),'NumNeighbors',k);
        end
        % Prediction
        yPred = predict(model,validSet(:,1:4));
        % add all mean classification errors from each run
    %     disp('The mean error for fold No'),disp(i),disp(' is: '), disp(fold_error(yPred, validSet(:,5)));
        e = e + fold_error(yPred, validSet(:,5));
    end
    %Calculate the mean folds error of all runs
    e = e/folds;




    % --- Test data prediction and final results ---
    yPred = predict(model,xTestMeas);
    eTest = fold_error(yPred, yTestRealVal); % real model error on new data
    
    fprintf('\n Run %.4f % \n', a);
    fprintf('\n The average validation error (AVE) for the training-validation data, for this particular model is: %.4f % \n', e);

    fprintf('\n The average test error (ATE) for the TEST data, for this particular model is: %.4f % \n', eTest);
    fprintf('\n  ');
    
    total_test_mean = total_test_mean + eTest; %for automation of the tests only
    total_validation_mean = total_validation_mean + e; %for automation of the tests only
end

    %for automation of the tests only
    fprintf('\n  ');
    fprintf('\n The total_test_mean for all runs is: %.4f % \n', total_test_mean/10);
    fprintf('\n  ');
    
    fprintf('\n The total_validation_mean for all runs is: %.4f % \n', total_validation_mean/10);
    fprintf('\n  ');
    
    
    

% --- Final visualisation of the test prediction ---
% the sepal width has been taken out but ONLY for the visualisation
Xtest_sepal_length = xTestMeas(:,1);
Ytest_petal_length = xTestMeas(:,3);
Ztest_petal_width = xTestMeas(:,4);

scatter3(Xtest_sepal_length(yPred == 1), Ytest_petal_length(yPred == 1), ...
        Ztest_petal_width(yPred == 1), ...
        'MarkerEdgeColor', 'magenta','LineWidth',2);%predicted setosa iris points
hold on;
scatter3(Xtest_sepal_length(yPred == 2), Ytest_petal_length(yPred == 2), ...
        Ztest_petal_width(yPred == 2), ...
        'MarkerEdgeColor', 'blue','LineWidth',2);%predicted versicolor iris points
hold on;
scatter3(Xtest_sepal_length(yPred == 3), Ytest_petal_length(yPred == 3), ...
        Ztest_petal_width(yPred == 3), ...
        'MarkerEdgeColor', 'red','LineWidth',2);%predicted virginica iris points
hold on;
scatter3(Xtest_sepal_length(yPred == yTestRealVal), Ytest_petal_length(yPred == yTestRealVal), ...
        Ztest_petal_width(yPred == yTestRealVal), ...
        'MarkerEdgeColor', 'black','Marker','*','LineWidth',0.5);%correct predictions
hold on;    


toc


