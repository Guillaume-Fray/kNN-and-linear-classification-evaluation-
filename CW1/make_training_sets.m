function [trainingSet,validationSet] = make_training_sets(meas,species,n,p)
%Return a training set and a validation set based on the input meas and species.

% The function merges the data from meas and species into one n by 5
% matrix. Then it shuffles all rows. Finally it divides the matrix into 2
% matrices:  
%           - Training Set = p by 5 matrix
%           - Validation Set = n-p by 5 matrix


%Convert species to numerical IDs (1,2,3 respectively) before appending 
%them to the meas matrix
type = convert_to_ID(species);

%Append the species data to the meas data so that we can divide the
%training-validation set into one training set and one valiadation set
X = [meas, type];

%randomly shuffle the whole iris data set for a better training and validation
X = X(randperm(size(X, 1)), :);

%p input entries for the Training Set 
trainingSet = X(1:p,:);

%n-p input entries for the Validation Set
validationSet = X((p+1):n,:);


end

