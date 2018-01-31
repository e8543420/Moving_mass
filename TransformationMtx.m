% co-ordinates transformation matrices
% u_elem = ET * u_global
% K_global = ET' * K_elem * ET
ET1 = [0 0 1 0 0 0;
       0 -1 0 0 0 0;
       1 0 0 0 0 0;
       0 0 0 0 0 1;
       0 0 0 0 -1 0;
       0 0 0 1 0 0];
ET1 = [ET1 zeros(ndof0);
       zeros(ndof0) ET1];
   
ET2 = [0 1 0 0 0 0;
       0 0 1 0 0 0;
       1 0 0 0 0 0;
       0 0 0 0 1 0;
       0 0 0 0 0 1;
       0 0 0 1 0 0];
ET2 = [ET2 zeros(ndof0);
       zeros(ndof0) ET2];
   
ET3 = [0 0 -1 0 0 0;
       0 1 0 0 0 0;
       1 0 0 0 0 0;
       0 0 0 0 0 -1;
       0 0 0 0 1 0;
       0 0 0 1 0 0];
ET3 = [ET3 zeros(ndof0);
       zeros(ndof0) ET3];
   
ET4 = [0 -1 0 0 0 0;
       0 0 -1 0 0 0;
       1 0 0 0 0 0;
       0 0 0 0 -1 0;
       0 0 0 0 0 -1;
       0 0 0 1 0 0];
ET4 = [ET4 zeros(ndof0);
       zeros(ndof0) ET4];