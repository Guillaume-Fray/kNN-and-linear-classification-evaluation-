function min_error = best_k()
%To determine the best possible k for the kNN model
tic
iris_data = load('fisheriris.mat');
X = iris_data.meas;
Y = iris_data.species;
%Mean folds error of ALL folds for one particular model
global e;
e = 0;

% STEP 1: Choose outer split like in main
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


% STEP 2: Choose p for inner split like in Main
p = input('Choose p for the inner split p/(n-p):  \n');
fprintf('\n ');


%1000 folds for each k, to find out which k value works best for kNN algorithm
arr_errors_k = zeros(25,1);
for k = 1:25
    for i = 1:1000
        [trainSet,validSet] = make_training_sets(xTrainingMeas,yTrainingSpecies,n,p);
        model = fitcknn(trainSet(:,1:4),trainSet(:,5),'NumNeighbors',k);
        yPred = predict(model,validSet(:,1:4));
        e = e + fold_error(yPred, validSet(:,5));
    end
    e = e/1000;
    arr_errors_k(k) = e;
    fprintf('\n k: %.4f % \n', k);
    fprintf('\n error: %.4f % \n', e);
    fprintf('\n  ');    
end
[min_error,bestK] = min(arr_errors_k);

fprintf('\n The best possible k for this particular model is: %.4f % \n', bestK);
fprintf('\n  ');

fprintf('\n The minimum average validation error is: %.4f % \n', min_error);
fprintf('\n  ');

toc
end

