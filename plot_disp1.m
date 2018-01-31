%% plot mode shapes with eigenvectors
% main frame only, no inner vertical beams

modei = 6; % input the index of mode

close all

i = find(remainlist == 34); % find the indices of node c(node 34)
dof1 = (i-1)*ndof0+1:i*ndof0;
i = find(remainlist == 35); % find the indices of node c(node 35)
dof2 = (i-1)*ndof0+1:i*ndof0;
i = find(remainlist == 11); % find the indices of node c(node 11)
dof3 = (i-1)*ndof0+1:i*ndof0;
i = find(remainlist == 119); % find the indices of node c(node 119)
dof4 = (i-1)*ndof0+1:i*ndof0;
i = find(remainlist == 16); % find the indices of node c(node 16)
dof5 = (i-1)*ndof0+1:i*ndof0;
i = find(remainlist == 41); % find the indices of node c(node 41)
dof6 = (i-1)*ndof0+1:i*ndof0;
i = find(remainlist == 27); % find the indices of node c(node 27)
dof7 = (i-1)*ndof0+1:i*ndof0;
i = find(remainlist == 42); % find the indices of node c(node 42)
dof8 = (i-1)*ndof0+1:i*ndof0;
i = find(remainlist == 80); % find the indices of node c(node 80)
dof9 = (i-1)*ndof0+1:i*ndof0;
i = find(remainlist == 81); % find the indices of node c(node 81)
dof10 = (i-1)*ndof0+1:i*ndof0;


displ = [eigenvectors(dof1,:); 
         eigenvectors(1:18,:);
         eigenvectors([dof2,dof2],:);
         eigenvectors(19:36,:);
         eigenvectors(dof3,:);
         eigenvectors(37:54,:);
         eigenvectors([dof4,dof4],:);
         eigenvectors(55:60,:);
         eigenvectors(dof5,:);
         eigenvectors(61:78,:);
         eigenvectors([dof6,dof6],:);
         eigenvectors(79:96,:);
         eigenvectors(dof7,:);
         eigenvectors(97:120,:);
         eigenvectors([dof8,dof8],:);

         eigenvectors(121:138,:);
         eigenvectors([dof9,dof9],:);
         eigenvectors(139:144,:);
         eigenvectors([dof10,dof10],:);
         eigenvectors(145:150,:)];
     
figure(1)
% plot(Node_Def(1:41,2)+displ(2:6:40*6+2,modei),Node_Def(1:41,3)+displ(3:6:40*6+3,modei),'-*');hold on
% plot outer beams
plot(Node_Def(1:34,2)+displ(2:6:33*6+2,modei),Node_Def(1:34,3)+displ(3:6:33*6+3,modei),'-*');hold on
% plot the middle horizontal beam
plot(Node_Def(35:41,2)+displ(34*6+2:6:40*6+2,modei),Node_Def(35:41,3)+displ(34*6+3:6:40*6+3,modei),'-*');
axis equal
xlabel('y'); ylabel('z');
figure(2)
% plot(zeros(41,1)+displ(1:6:40*6+1,modei),Node_Def(1:41,3)+displ(3:6:40*6+3,modei),'-*');hold on
% plot outer beams
plot(zeros(34,1)+displ(1:6:33*6+1,modei),Node_Def(1:34,3)+displ(3:6:33*6+3,modei),'-*');hold on
% plot the middle horizontal beam
plot(zeros(7,1)+displ(34*6+1:6:40*6+1,modei),Node_Def(35:41,3)+displ(34*6+3:6:40*6+3,modei),'-*');

axis equal
xlabel('x'); ylabel('z');