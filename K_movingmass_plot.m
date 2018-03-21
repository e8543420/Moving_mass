%%% This program is used to plot the output of the Kriging surrogate model
%%% of the moving mass truss structure.
%%% Author: Zhaoxu Yuan

clear;
clc;
addpath './dace';

%load 'MM_kriging_non_norm.mat';
load 'MM_kriging_norm.mat';
load 'train_data_3101.mat';

disp_i=[1,2];
mesh_num=40;
disp_out=6;
parameter_name=['pos1';'pos2';'k\_b';'G\_v'];
validate_parm=[62,101,2e7,2.594e10];
%Generate the default parameters
X_trail = zeros(mesh_num^2,length(default_parm));
for i=1:length(default_parm)
  X_trail(:,i)=ones(mesh_num^2,1)*validate_parm(i);
end;

%Genetrate and normalize the trail samples
X_trail(:,disp_i) = gridsamp(mesh_bound(:,disp_i), mesh_num);
for i=1:length(default_parm)
  X_trail(:,i)=X_trail(:,i)/default_parm(i);
end;

%Calculate
[Y_predict MSE] = predictor(X_trail, dmodel);

%Prepare the mesh plot matrix and denormalize
X1 = reshape(X_trail(:,disp_i(1)),mesh_num,mesh_num)*default_parm(disp_i(1)); 
X2 = reshape(X_trail(:,disp_i(2)),mesh_num,mesh_num)*default_parm(disp_i(2));
YX = reshape(Y_predict(:,disp_out), size(X1));

figure(1), mesh(X1, X2, YX);
xlabel(strcat('Parameter: ',parameter_name(disp_i(1),:),'(cm)'));
ylabel(strcat('Parameter: ',parameter_name(disp_i(2),:),'(cm)'));
zlabel(strcat('Frequency No.',num2str(disp_out),'(Hz)'));
xtk=[45,50,55,60,65,70,75];
ytk=[85,90,95,100,105,110,115];
xtk_label=[5,10,15,20,25,30,35,40,45];
ytk_label=[5,10,15,20,25,30,35,40,45];
set(gca,'xtick',xtk);set(gca,'xticklabel',xtk_label);
set(gca,'ytick',ytk);set(gca,'yticklabel',ytk_label);
hold on;
%Randomly pick some sample to validate the model

list_pick = randperm(length(X));
list_pick = [list_pick(1:10),4096];

X_validate = zeros(length(list_pick),length(default_parm));
for i=1:length(default_parm)
  X_validate(:,i)=ones(length(list_pick),1)*validate_parm(i);
end;

X_validate(:,disp_i)=X(list_pick,disp_i);

Y_validate=zeros(length(X_validate),rows(Y'));
for i=1:length(X_validate)
  Y_validate(i,:)=truss_model_func(X_validate(i,1), X_validate(i,2), X_validate(i,3), X_validate(i,4));
  %Y_validate(i,:)=predictor(X_validate(i,:)./default_parm, dmodel);
end

plot3(X(list_pick,disp_i(1)),X(list_pick,disp_i(2)),Y_validate(:,disp_out),'.k', 'MarkerSize',20);
hold off;
