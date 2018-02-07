%%% This is a wraped function for the prediction of the moving mass structure
%%% with Kriging model predictor.
%%% Author: Zhaoxu Yuan

function Y_predict=K_movingmass_fun_5parm(parm)
% parm  --The input parm, normalized if using MM_kriging_norm.mat.
% Y_predict  --Modal frequencies predicted by the model.

addpath './dace';
%load 'MM_kriging_non_norm.mat';
load 'MM_kriging_norm_5parm_3rr.mat';
load 'train_data_0202.mat';


[Y_predict MSE] = predictor(parm, dmodel);

end