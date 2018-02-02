%%% This program is used to train the Kriging surrogate model for 
%%% the moving mass truss structure.
%%% Author: Zhaoxu Yuan
clear;
clc;
addpath './dace';


mesh_bound=[50, 89, 2e7*0.6, 2.594e10*0.6, 2.594e10*0.6;...
               71, 110, 2e7*1.4, 2.594e10*1.4, 2.594e10*1.4];
default_parm=[61,100,2e7,2.594e10,2.594e10];
X = gridsamp(mesh_bound, 8);
% X = lhsamp(1000,5); 
Y = zeros(length(X),618)
for i=1:length(X)
  Y(i,:)=truss_model_func_5parm(X(i,1), X(i,2), X(i,3), X(i,4), X(i,5));
  display(strcat('Progress: ',num2str(i),'/',num2str(length(X))));
end

save('train_data_0202.mat','X','Y')
