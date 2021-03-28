function e = fold_error(prediction, Y)
% Classification error function commonly used for linear classification
numY = height(Y);
global I;
I = 0;
for i = 1:numY
%     disp('prediction '),disp(i), disp('   '), disp(prediction(i)), ...
%         disp(' , real value: '),disp(Y(i));
    if prediction(i) ~= Y(i)
        I = I+1;    
    end
e = I/numY;

end
end