%% point mass of screws
mt1 = 12*0.003; % kg, T1-joint
mt2 = 3*0.0025; % kg, T2-joint
ml = 3*0.0025; % kg, L-joint
mb = 2*0.008; % kg, base connection
%         [node_number mass]
screw_m = [11 ml;
          16 ml;
          27 ml;
          28 mb;
          33 mb;
          34 ml;
          35 mt2;
          41 mt2;
          42 mt2;
          80 mt1;
          81 mt1;
          119 mt1];
      
