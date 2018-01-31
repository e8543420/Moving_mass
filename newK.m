%% calculate the new stiffness matrix of joints
% calculate the sensitivity of joint parameter alpha and beta
function [K, M, dK_dalpha, dK_dbeta, dM_dalpha, dM_dbeta] = newK(Ke,Me, alpha, beta, NodeLocation, p)
% Ke - original stiffness of element
% alpha - offset1
% beta - offset2
% NodeLocation - 'a', 'b', 'c', location of the node on a joint
% p - 1 - the node with small node number
%     0 - the node with big node number
ndof0 = 6;

Ca = [1     0     0     0     0     -alpha;
      0     1     0     0     0     beta;
      0     0     1     alpha -beta 0;
      0     0     0     1     0     0;
      0     0     0     0     1     0;
      0     0     0     0     0     1];
  
Cb = [1     0     0     0     0     alpha;
      0     1     0     0     0     beta;
      0     0     1    -alpha -beta 0;
      0     0     0     1     0     0;
      0     0     0     0     1     0;
      0     0     0     0     0     1];

% partial derivative
dCa_dalpha = sparse([1,3],[6,4],[-1,1],6,6);
dCa_dbeta = sparse([2,3],[6,5],[1,-1],6,6);
dCb_dalpha = sparse([1,3],[6,4],[1,-1],6,6);
dCb_dbeta = sparse([2,3],[6,5],[1,-1],6,6);


if p == 1 % This node is the one with small node number
    Ca = [Ca zeros(6,6); zeros(6,6) eye(6)];
    Cb = [Cb zeros(6,6); zeros(6,6) eye(6)];
    dCa_dalpha = [dCa_dalpha zeros(6,6); zeros(6,6) zeros(6,6)];
    dCa_dbeta = [dCa_dbeta zeros(6,6); zeros(6,6) zeros(6,6)];
    dCb_dalpha = [dCb_dalpha zeros(6,6); zeros(6,6) zeros(6,6)];
    dCb_dbeta = [dCb_dbeta zeros(6,6); zeros(6,6) zeros(6,6)];
elseif p == 0 % This node is the one with big node number
    Ca = [eye(6) zeros(6,6); zeros(6,6) Ca];
    Cb = [eye(6) zeros(6,6); zeros(6,6) Cb];
    dCa_dalpha = [zeros(6,6) zeros(6,6); zeros(6,6) dCa_dalpha];
    dCa_dbeta = [zeros(6,6) zeros(6,6); zeros(6,6) dCa_dbeta];
    dCb_dalpha = [zeros(6,6) zeros(6,6); zeros(6,6) dCb_dalpha];
    dCb_dbeta = [zeros(6,6) zeros(6,6); zeros(6,6) dCb_dbeta];
end

% transform matrix from joint connection coordinate to node a b element coordinate
T = [0 1 0; 1 0 0; 0 0 -1];
T = [T, zeros(3,3); zeros(3,3), T];
T = [T, zeros(6,6); zeros(6,6), T];
Ca = T' * Ca * T;
Cb = T' * Cb * T;
dCa_dalpha = T' * dCa_dalpha * T;
dCa_dbeta = T' * dCa_dbeta * T;
dCb_dalpha = T' * dCb_dalpha * T;
dCb_dbeta = T' * dCb_dbeta * T;

% transform matrix from normal joint coordinate to reverse coordinate
% for the joint with reverse node order
% T1 = [-1 0 0;0 1 0;0 0 -1];
T1 = [-1 0 0; 0 -1 0; 0 0 1];
% T1 = [0 -1 0; -1 0 0; 0 0 -1]; % transform matrix from joint connection
% coordinates to node a b element coordinates in reverse order joint
T1 = [T1, zeros(3,3); zeros(3,3), T1];
T1 = [T1, zeros(6,6); zeros(6,6), T1];

if NodeLocation == 'a'
    K = Ca' * Ke * Ca;
    M = Ca' * Me * Ca;
    dK_dalpha = Ca' * Ke * dCa_dalpha + (Ca' * Ke * dCa_dalpha)';
    dK_dbeta = Ca' * Ke * dCa_dbeta + (Ca' * Ke * dCa_dbeta)';
    dM_dalpha = Ca' * Me * dCa_dalpha + (Ca' * Me * dCa_dalpha)';
    dM_dbeta = Ca' * Me * dCa_dbeta +(Ca' * Me * dCa_dbeta)';
elseif NodeLocation == 'b'
    K = Cb' * Ke * Cb;
    M = Cb' * Me * Cb;
    dK_dalpha = Cb' * Ke * dCb_dalpha + (Cb' * Ke * dCb_dalpha)';
    dK_dbeta = Cb' * Ke * dCb_dbeta + (Cb' * Ke * dCb_dbeta)';
    dM_dalpha = Cb' * Me * dCb_dalpha + (Cb' * Me * dCb_dalpha)';
    dM_dbeta = Cb' * Me * dCb_dbeta + (Cb' * Me * dCb_dbeta)';
elseif NodeLocation == 'ar'
    Ca = T1' * Ca * T1;
    dCa_dalpha = T1' * dCa_dalpha * T1;
    dCa_dbeta = T1' * dCa_dbeta * T1;
    K = Ca' * Ke * Ca;
    M = Ca' * Me * Ca;
    dK_dalpha = Ca' * Ke * dCa_dalpha + (Ca' * Ke * dCa_dalpha)';
    dK_dbeta = Ca' * Ke * dCa_dbeta + (Ca' * Ke * dCa_dbeta)';
    dM_dalpha = Ca' * Me * dCa_dalpha + (Ca' * Me * dCa_dalpha)';
    dM_dbeta = Ca' * Me * dCa_dbeta + (Ca' * Me * dCa_dbeta)';
elseif NodeLocation == 'br'
    Cb = T1' * Cb * T1;
    dCb_dalpha = T1' * dCb_dalpha * T1;
    dCb_dbeta = T1' * dCb_dbeta * T1;
    K = Cb' * Ke * Cb;
    M = Cb' * Me * Cb;
    dK_dalpha = Cb' * Ke * dCb_dalpha + (Cb' * Ke * dCb_dalpha)';
    dK_dbeta = Cb' * Ke * dCb_dbeta + (Cb' * Ke * dCb_dbeta)';
    dM_dalpha = Cb' * Me * dCb_dalpha + (Cb' * Me * dCb_dalpha)';
    dM_dbeta = Cb' * Me * dCb_dbeta + (Cb' * Me * dCb_dbeta)';
elseif NodeLocation == 'c'
    K = Ke;
    M = Me;
    dK_dalpha = zeros(2*ndof0,2*ndof0);
    dK_dbeta = zeros(2*ndof0,2*ndof0);
    dM_dalpha = zeros(2*ndof0,2*ndof0);
    dM_dbeta = zeros(2*ndof0,2*ndof0);
elseif NodeLocation == ''
    K = Ke;
    M = Me;
    dK_dalpha = zeros(2*ndof0,2*ndof0);
    dK_dbeta = zeros(2*ndof0,2*ndof0);
    dM_dalpha = zeros(2*ndof0,2*ndof0);
    dM_dbeta = zeros(2*ndof0,2*ndof0);
else
    disp('NodeLocation can be ''a'' or ''b''.');
    K = []; M = [];
end

K = (K + K')* 0.5; % remove numerical error
M = (M + M')* 0.5;
end