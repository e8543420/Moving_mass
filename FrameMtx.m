%% Main code for calculating eigenvulues and eigenvectors of the frame
clear;

%% useful parameters
a_T1 = 0.0047; % offset alpha of T1 joint
b_T1 = 0.0047; % beta T1

a_T2 = 0.0047; % alpha T2
b_T2 = 0.0047; % beta T2

a_L = 0.0047; % alpha L
b_L = 0.0047; % alpha L

k_b = 2e7; % base restrictions

%% material property
E = 6.9E10; % Pa
poisson = 0.33; % Poisson's ratio
G = E/2/(1+poisson); % shear modulus Pa
G_b = G; G_v = G;% Pa
rho = 2650; % kg/m^3 density
b = 0.06; % m, width of the beam
h = 0.0094; % m, thickness of the beam

%% joints info (information only, not code)
% % T1 joint nodes
% % T1a = [37 39];
% % T1b = [36 40];
% % T1c = [80 81];
% 
% % T2 joint nodes
% % T2a = [6 15 22 32];
% % T2b = [5 14 21 31];
% % T2c = [35 119 41 42];
%
% % L joint nodes
% % L1a = [1 17];
% % L1c = [34 16];
% % L2b = [10 26];
% % L2c = [11 27];

%% create node list, element list, node information list
run 'NodeElem'

%% plot elements
plot(Node_Def(:,2),Node_Def(:,3),'bx');hold on
for i = 1:size(Elem_Def,1)
    node1 = Elem_Def(i,2); node2 = Elem_Def(i,3);
    plot(Node_Def([node1 node2],2),Node_Def([node1 node2],3), 'k');
end
ylim([-0.1 0.9]);
% ylim([-0.1 1.1]);
axis equal;
xlabel('y'); ylabel('z');
legend('Nodes','Beam elements');

%% Assemble K and M.
nnode = size(Node_Def,1); % number of nodes before joint node reduction
nbeam = size(Elem_Def,1); % number of beams before joint node reduction
ndof0 = 6; % number of dof of each node
ndof = ndof0 * nnode; % number of dof before joint node reduction.
K = zeros(ndof,ndof);
M = zeros(ndof,ndof);
dK_dalpha_T1 = zeros(ndof, ndof);
dK_dbeta_T1 = zeros(ndof, ndof);
dM_dalpha_T1 = zeros(ndof, ndof);
dM_dbeta_T1 = zeros(ndof, ndof);
dK_dalpha_T2 = zeros(ndof, ndof);
dK_dbeta_T2 = zeros(ndof, ndof);
dM_dalpha_T2 = zeros(ndof, ndof);
dM_dbeta_T2 = zeros(ndof, ndof);
dK_dalpha_L = zeros(ndof, ndof);
dK_dbeta_L = zeros(ndof, ndof);
dM_dalpha_L = zeros(ndof, ndof);
dM_dbeta_L = zeros(ndof, ndof);

dK_dGb = zeros(ndof, ndof);
dM_dGb = zeros(ndof, ndof);
dK_dGv = zeros(ndof, ndof);
dM_dGv = zeros(ndof, ndof);

run 'TransformationMtx' % transformation matrices

for i = 1:nbeam % assemble system stiffness matrix
    n1 = Elem_Def(i,2); % node no. of one end of the beam
    n2 = Elem_Def(i,3); % node no. of the other end of the beam
    dof = [(n1-1)*ndof0+1:n1*ndof0 (n2-1)*ndof0+1:n2*ndof0];

    Le = sqrt((Node_Def(n2,2) - Node_Def(n1,2))^2 + (Node_Def(n2,3) - Node_Def(n1,3))^2);
    
    if i >= 21 && i <= 26 % change the shear modulus G of the BOTTOM BEAM
        G = G_b;
    elseif i <= 8 || (i >=13 && i <= 20)
        G = G_v;
    else 
        G = E/2/(1+poisson);
    end
    
%     [Ke Me] = ElemMtx(Le,E,poisson,rho,b,h);
    [Ke Me] = ElemMtx(Le,E,poisson,G,rho,b,h);
    
    % change node a node b to node c 
    for j = [n1 n2] 
        if isempty(node_info{j,2}) == 0 % the node is a joint node
            if node_info{j,2} == 'T1'
                alpha = a_T1; beta = b_T1;
                [Ke Me dKe_dalpha.mtx dKe_dbeta.mtx dMe_dalpha.mtx dMe_dbeta.mtx] = newK(Ke, Me, alpha,beta,node_info{j,3},j<n2);
                dKe_dalpha.joint = 1; dKe_dbeta.joint = 1;
                dMe_dalpha.joint = 1; dMe_dbeta.joint = 1;
            elseif node_info{j,2} == 'T2'
                alpha = a_T2; beta = b_T2;
                [Ke Me dKe_dalpha.mtx dKe_dbeta.mtx dMe_dalpha.mtx dMe_dbeta.mtx] = newK(Ke, Me, alpha,beta,node_info{j,3},j<n2);
                dKe_dalpha.joint = 2; dKe_dbeta.joint = 2;
                dMe_dalpha.joint = 2; dMe_dbeta.joint = 2;
            elseif node_info{j,2} == 'L'
                alpha = a_L; beta = b_L;
                [Ke Me dKe_dalpha.mtx dKe_dbeta.mtx dMe_dalpha.mtx dMe_dbeta.mtx] = newK(Ke, Me, alpha,beta,node_info{j,3},j<n2);
                dKe_dalpha.joint = 3; dKe_dbeta.joint = 3;
                dMe_dalpha.joint = 3; dMe_dbeta.joint = 3;
            end
        else % the node isn't a joint node
%             dKe_dalpha.mtx = zeros(2*ndof0,2*ndof0);
%             dKe_dbeta.mtx = zeros(2*ndof0,2*ndof0);
%             dMe_dalpha.mtx = zeros(2*ndof0,2*ndof0);
%             dMe_dbeta.mtx = zeros(2*ndof0,2*ndof0);
        end
    end
    
    % calculate the sensitivity of shear modulus G_b
    if i>=21 && i<=26
        dKe_dGb = sparse([4,4,10,10],[4,10,4,10],Ke(4,4)/G*[1,-1,-1,1],12,12); % use G and Ke
    end
    % calculate the sensitivity of shear modulus G_v
    if i <= 8 || (i >=13 && i <= 20)
        dKe_dGv = sparse([4,4,10,10],[4,10,4,10],Ke(4,4)/G*[1,-1,-1,1],12,12); % use G and Ke
    end
    
    % change element K M to frame co-ordinates
    if i<=8 || (i>=31 && i<=106) % first and middle vertical beams
        Ke = ET1' * Ke * ET1;
        Me = ET1' * Me * ET1;
        dKe_dalpha.mtx = ET1' * dKe_dalpha.mtx * ET1;
        dKe_dbeta.mtx = ET1' * dKe_dbeta.mtx * ET1;
        dMe_dalpha.mtx = ET1' * dMe_dalpha.mtx * ET1;
        dMe_dbeta.mtx = ET1' * dMe_dbeta.mtx * ET1;
        dKe_dGv = ET1' * dKe_dGv * ET1;
    elseif (i>=9 && i<=12) || (i>=27 && i<=30) % top and mid horizontal beams
        Ke = ET2' * Ke * ET2;
        Me = ET2' * Me * ET2;
        dKe_dalpha.mtx = ET2' * dKe_dalpha.mtx * ET2;
        dKe_dbeta.mtx = ET2' * dKe_dbeta.mtx * ET2;
        dMe_dalpha.mtx = ET2' * dMe_dalpha.mtx * ET2;
        dMe_dbeta.mtx = ET2' * dMe_dbeta.mtx * ET2;
    elseif i>=13 && i<=20 % second vertical beam
        Ke = ET3' * Ke * ET3;
        Me = ET3' * Me * ET3;
        dKe_dalpha.mtx = ET3' * dKe_dalpha.mtx * ET3;
        dKe_dbeta.mtx = ET3' * dKe_dbeta.mtx * ET3;
        dMe_dalpha.mtx = ET3' * dMe_dalpha.mtx * ET3;
        dMe_dbeta.mtx = ET3' * dMe_dbeta.mtx * ET3;
        dKe_dGv = ET3' * dKe_dGv * ET3;
    elseif i>=21 && i<= 26 % bottom horizontal beam
        Ke = ET4' * Ke * ET4;
        Me = ET4' * Me * ET4;
        dKe_dalpha.mtx = ET4' * dKe_dalpha.mtx * ET4;
        dKe_dbeta.mtx = ET4' * dKe_dbeta.mtx * ET4;
        dMe_dalpha.mtx = ET4' * dMe_dalpha.mtx * ET4;
        dMe_dbeta.mtx = ET4' * dMe_dbeta.mtx * ET4;
        dKe_dGb = ET4' * dKe_dGb * ET4;
    end
    
% assemble global K and M
    K(dof,dof) = K(dof,dof) + Ke; % frame K
    M(dof,dof) = M(dof,dof) + Me; % frame M
    
%     assemble global sensitivity matricies
    if dKe_dalpha.joint == 1
        dK_dalpha_T1(dof,dof) = dK_dalpha_T1(dof,dof) + dKe_dalpha.mtx;
        dK_dbeta_T1(dof,dof) = dK_dbeta_T1(dof,dof) + dKe_dbeta.mtx;
        dM_dalpha_T1(dof,dof) = dM_dalpha_T1(dof,dof) + dMe_dalpha.mtx;
        dM_dbeta_T1(dof,dof) = dM_dbeta_T1(dof,dof) + dMe_dbeta.mtx;
    elseif dKe_dalpha.joint == 2
        dK_dalpha_T2(dof,dof) = dK_dalpha_T2(dof,dof) + dKe_dalpha.mtx;
        dK_dbeta_T2(dof,dof) = dK_dbeta_T2(dof,dof) + dKe_dbeta.mtx;
        dM_dalpha_T2(dof,dof) = dM_dalpha_T2(dof,dof) + dMe_dalpha.mtx;
        dM_dbeta_T2(dof,dof) = dM_dbeta_T2(dof,dof) + dMe_dbeta.mtx;
    elseif dKe_dalpha.joint == 3
        dK_dalpha_L(dof,dof) = dK_dalpha_L(dof,dof) + dKe_dalpha.mtx;
        dK_dbeta_L(dof,dof) = dK_dbeta_L(dof,dof) + dKe_dbeta.mtx;
        dM_dalpha_L(dof,dof) = dM_dalpha_L(dof,dof) + dMe_dalpha.mtx;
        dM_dbeta_L(dof,dof) = dM_dbeta_L(dof,dof) + dMe_dbeta.mtx;
    end
    
    if i>=21 && i<= 26
        dK_dGb(dof,dof) = dK_dGb(dof,dof) + dKe_dGb;
    elseif i <= 8 || (i >=13 && i <= 20)
        dK_dGv(dof,dof) = dK_dGv(dof,dof) + dKe_dGv;
    end
end

% remove rows and columns belong to node a and node b
Kr = K; Mr = M;
removelist = 0;
for i = 1:nnode % merge joint matrix
    iab = (i-1)*ndof0+1:i*ndof0;
    if isempty(node_info{i,2}) == 0 % the node is a joint node        
        if isempty(node_info{i,4}) == 0 % the node is not a c node
            removelist(end+1) = i;
            ic = node_info{i,4}; % index of node c
            jointc = (ic-1)*ndof0+1:ic*ndof0; % index of 6 dof of node c
            C = eye(ndof0*nnode); C(jointc,iab) = eye(ndof0); % elementary matrix
            Kr = C * Kr * C'; % add rows and columns of node a b to node c
            Mr = C * Mr * C';
            dK_dalpha_T1 = C * dK_dalpha_T1 * C';
            dK_dbeta_T1 = C * dK_dbeta_T1 * C';
            dM_dalpha_T1 = C * dM_dalpha_T1 * C';
            dM_dbeta_T1 = C * dM_dbeta_T1 * C';
            dK_dalpha_T2 = C * dK_dalpha_T2 * C';
            dK_dbeta_T2 = C * dK_dbeta_T2 * C';
            dM_dalpha_T2 = C * dM_dalpha_T2 * C';
            dM_dbeta_T2 = C * dM_dbeta_T2 * C';
            dK_dalpha_L = C * dK_dalpha_L * C';
            dK_dbeta_L = C * dK_dbeta_L * C';
            dM_dalpha_L = C * dM_dalpha_L * C';
            dM_dbeta_L = C * dM_dbeta_L * C';
            dK_dGb = C * dK_dGb * C';
            dK_dGv = C * dK_dGv * C';
            clear C;
        end
    end
end
removelist = removelist(2:end); % a list of nodes to be removed
remainlist = 1:nnode; remainlist(removelist) = []; % list of nodes remained
for i = 1:length(remainlist) % index list of rows and columns to be remained
iremain((i-1)*ndof0+1:i*ndof0) = (remainlist(i)-1)*ndof0+1:remainlist(i)*ndof0;
end

% remove extra rows and columns
newKr = Kr(iremain,iremain); % Frame K without extra rows and columns
newMr = Mr(iremain,iremain); % Frame M without extra rows and columns
dK_dalpha_T1 = dK_dalpha_T1(iremain,iremain);
dK_dbeta_T1 = dK_dbeta_T1(iremain,iremain);
dM_dalpha_T1 = dM_dalpha_T1(iremain,iremain);
dM_dbeta_T1 = dM_dbeta_T1(iremain,iremain);
dK_dalpha_T2 = dK_dalpha_T2(iremain,iremain);
dK_dbeta_T2 = dK_dbeta_T2(iremain,iremain);
dM_dalpha_T2 = dM_dalpha_T2(iremain,iremain);
dM_dbeta_T2 = dM_dbeta_T2(iremain,iremain);
dK_dalpha_L = dK_dalpha_L(iremain,iremain);
dK_dbeta_L = dK_dbeta_L(iremain,iremain);
dM_dalpha_L = dM_dalpha_L(iremain,iremain);
dM_dbeta_L = dM_dbeta_L(iremain,iremain);
dK_dGb = dK_dGb(iremain,iremain);
dM_dGb = dM_dGb(iremain,iremain);
dK_dGv = dK_dGv(iremain,iremain);
dM_dGv = dM_dGv(iremain,iremain);

%% Base restrictions
% Method 1: add stiffness

% base link additional Ka
Ka = k_b * diag([1 1 1 1 1 1]); %

% add Ka to node 28 & 33
i = find(remainlist == 28);
dof28 = (i-1)*ndof0+1:i*ndof0;
newKr(dof28,dof28) = newKr(dof28,dof28) + Ka;
i = find(remainlist == 33);
dof33 = (i-1)*ndof0+1:i*ndof0;
newKr(dof33,dof33) = newKr(dof33,dof33) + Ka;
% partial derivatives
dK_dkb = sparse([dof28,dof33],[dof28,dof33],ones(1,2*ndof0),size(newKr,1),size(newKr,2));

% % Method 2: pin to ground
% newKr = newKr([1:102, 109:120, 127:end],[1:102, 109:120, 127:end]);
% newMr = newMr([1:102, 109:120, 127:end],[1:102, 109:120, 127:end]);
% i = find(remainlist == 28); remainlist(i) = [];
% i = find(remainlist == 33); remainlist(i) = [];
% % release theta_x theta_y
% newKr = newKr([1:102,106,107,109:120,127:end],[1:102,106,107,109:120,127:end]);
% newMr = newMr([1:102,106,107,109:120,127:end],[1:102,106,107,109:120,127:end]);

%% screw mass and joint mass
run 'screw_mass'
for i = 1: size(screw_m,1)
    j = find(remainlist == screw_m(i,1)); % the index of the node in K M
    dof = (j-1)*ndof0+1:j*ndof0;
    alpha = node_info{screw_m(i,1),5};
    beta = node_info{screw_m(i,1),6};
    newMr(dof,dof) = newMr(dof,dof) + (screw_m(i,2)+joint_mass(alpha,beta,rho))...
        *[eye(ndof0/2) zeros(ndof0/2); zeros(ndof0/2) zeros(ndof0/2)];
    % add point mass to node
end

%% mass blocks
% j = find(remainlist == 46); % 5cm
j = find(remainlist == 61); % 20cm
% j = find(remainlist == 76); % 35cm
dof = (j-1)*ndof0+1:j*ndof0;
newMr(dof,dof) = newMr(dof,dof) + diag([2.03 2.03 2.03 2*2.03*0.0117^2 0 2*2.03*0.0117^2]);
% j = find(remainlist == 85); % 5cm
j = find(remainlist == 100); % 20cm
% j = find(remainlist == 115); % 35cm
dof = (j-1)*ndof0+1:j*ndof0;
newMr(dof,dof) = newMr(dof,dof) + diag([2.03 2.03 2.03 2*2.03*0.0117^2 0 2*2.03*0.0117^2]);

%% calculate eigenvalues, eigenvectors, and frequencies in Hz

[eigenvectors,eigenvalues] = eig(newKr,newMr);
[eigenvalues,isort] = sort(diag(eigenvalues));
eigenvectors = eigenvectors(:,isort);
freqs_Hz = sqrt(eigenvalues)./(2*pi);
