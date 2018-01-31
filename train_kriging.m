%%% This program is used to train the Kriging surrogate model for 
%%% the moving mass truss structure.
%%% Author: Zhaoxu Yuan
clear;
clc;
addpath './dace';


X = gridsamp([50, 89, 2e7*0.6, 2.594e10*0.6;...
              71, 110, 2e7*1.4, 2.594e10*1.4], 8);
%X = lhsamp(1000,5); 
for i=1:length(X)
  Y(i,:)=truss_model_func(X(i,1), X(i,2), X(i,3), X(i,4));
end
