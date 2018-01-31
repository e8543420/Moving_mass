%%% This program is used to train the Kriging surrogate model for 
%%% the moving mass truss structure.
%%% Author: Zhaoxu Yuan
clear;
clc;
addpath './dace';


mesh_bound=[50, 89, 2e7*0.6, 2.594e10*0.6;...
               71, 110, 2e7*1.4, 2.594e10*1.4];
default_parm=[61,100,2e7,2.594e10];
% X = gridsamp(mesh_bound, 8);
% X = lhsamp(1000,5); 
% for i=1:length(X)
%   Y(i,:)=truss_model_func(X(i,1), X(i,2), X(i,3), X(i,4));
% end

load 'train_data_3101.mat';

%Normalization
for i=1:length(default_parm)
  X(:,i)=X(:,i)/default_parm(i);
end;

theta = [10 10 10 10]; 
lob = 1e-1*ones(1,4); 
upb = 20*ones(1,4);

[dmodel, perf] = dacefit(X, Y, @regpoly0, @corrgauss, theta, lob, upb);

save('MM_kriging_norm.mat','dmodel','perf','mesh_bound','default_parm');