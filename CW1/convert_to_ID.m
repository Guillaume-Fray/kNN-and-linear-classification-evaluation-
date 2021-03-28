function [speciesID] = convert_to_ID(species)
%Convert species (setosa, versicolor & virginica) to IDs (1,2,3 respectively)
global type;
type = zeros(height(species),1);
for i = 1:height(species)
    if strcmp(species(i),'setosa')
        type(i) = 1;
    elseif strcmp(species(i),'versicolor')
        type(i) = 2;
    else
        type(i) = 3;
    end
end
speciesID = type;
end

