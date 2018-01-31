%% generate node and element maps

%% useful parameter
bt = 0.0047; % half beam thickness

%% Node_Def % definition of node number and position
% nodes on the mainframe
%      [node_number y_position  z_position]
Node_Def_MF = [ 1   bt          bt+a_L; % corner
                2   bt          0.1;
                3   bt          0.2;
                4   bt          0.3;
                5   bt          0.4-a_T2; % mid
                6   bt          0.4+a_T2; % mid
                7   bt          0.5; 
                8   bt          0.6;
                9   bt          0.7;
                10  bt          0.8-bt-a_L; % corner
                11  bt+b_L      0.8-bt; % corner
                12  0.1         0.8-bt;
                13  0.2         0.8-bt;
                14  0.3-a_T2    0.8-bt; % top joint
                15  0.3+a_T2    0.8-bt; % top joint
                16  0.4-bt-b_L  0.8-bt; % corner
                17  0.4-bt      0.8-bt-a_L; % corner
                18  0.4-bt      0.7;
                19  0.4-bt      0.6;
                20  0.4-bt      0.5;
                21  0.4-bt      0.4+a_T2; % mid
                22  0.4-bt      0.4-a_T2; % mid
                23  0.4-bt      0.3;
                24  0.4-bt      0.2;
                25  0.4-bt      0.1;
                26  0.4-bt      bt+a_L; % corner
                27  0.4-bt-b_L  bt; % corner
                28  0.35        bt; % base link % 0.35
                29  0.3         bt;
                30  0.2         bt;
                31  0.1+a_T2    bt; % bottom joint
                32  0.1-a_T2    bt; % bottom joint
                33  0.05        bt; % base link % 0.05
                34  bt+b_L      bt; % corner
                35  bt+b_T2     0.4; % mid
                36  0.1-a_T1    0.4; % mid joint
                37  0.1+a_T1    0.4; % mid joint
                38  0.2         0.4;
                39  0.3-a_T1    0.4; % mid joint
                40  0.3+a_T1    0.4; % mid joint
                41  0.4-bt-b_T2 0.4]; % mid

% nodes on the lower vertical inner beam
% [node_number y_position z_position]
Node_Def_IB1 = [[42 0.1 0.0+bt+b_T2]; 
                [(43:79)' 0.1*ones(37,1) (0.02:0.01:0.38)'];
                [80 0.1 0.4-b_T1]]; 
% nodes on the higher vertical inner beam
% [node_number y_position z_position]
Node_Def_IB2 = [[81 0.3 0.4+b_T1]; 
                [(82:118)' 0.3*ones(37,1) (0.42:0.01:0.78)'];
                [119 0.3 0.8-bt-b_T2]];
            
% assemble node list
Node_Def = [Node_Def_MF;
            Node_Def_IB1;
            Node_Def_IB2];

            
%% Frame_Def % definition of beam connections
% elements on the mainframe
% [elem_num 1st_node 2nd_node]
Elem_Def_MF = [1   1   2; % right vertical - ET1
             2   2   3;
             3   3   4;
             4   4   5;
             5   6   7;
             6   7   8;
             7   8   9;
             8   9   10; % right vertical - ET1
             9   11  12; % top horizontal - ET2
             10  12  13;
             11  13  14;
             12  15  16; % top horizontal - ET2
             13  17  18; % left vertical - ET3
             14  18  19;
             15  19  20;
             16  20  21;
             17  22  23;
             18  23  24;
             19  24  25;
             20  25  26; % left vertical - ET3
             21  27  28; % bottom horizontal - ET4
             22  28  29;
             23  29  30;
             24  30  31;
             25  32  33;
             26  33  34; % bottom horizontal - ET4
             27  35  36; % middle horizontal - ET2
             28  37  38;
             29  38  39;
             30  40  41]; % middle horizontal - ET2
         
% elements on lower vertical inner beam
% [elem_num 1st_node 2nd_node]
Elem_Def_IB1 = [(31:68)' (42:79)' (43:80)']; % ET1
% elements on higher vertical inner beam
Elem_Def_IB2 = [(69:106)' (81:118)' (82:119)']; % ET1

% assemble element list
Elem_Def = [Elem_Def_MF;
            Elem_Def_IB1;
            Elem_Def_IB2];

%% node joint info matrix
% node info of the nodes on the mainframe
% {node_num joint_type node_location node_c alpha beta}
node_info_MF = { 1   'L'   'a'  34  a_L  b_L;
                 2   ''    ''   ''  0    0;
                 3   ''    ''   ''  0    0;
                 4   ''    ''   ''  0    0;
                 5   'T2'  'b'  35  a_T2 b_T2;
                 6   'T2'  'a'  35  a_T2 b_T2;
                 7   ''    ''   ''  0    0;
                 8   ''    ''   ''  0    0;
                 9   ''    ''   ''  0    0;
                 10  'L'   'b'  11  a_L  b_L;
                 11  'L'   'c'  ''  a_L  b_L;
                 12  ''    ''   ''  0    0;
                 13  ''    ''   ''  0    0;
                 14  'T2'  'b'  119 a_T2 b_T2;
                 15  'T2'  'a'  119 a_T2 b_T2;
                 16  'L'   'c'  ''  a_L  b_L;
                 17  'L'   'a'  16  a_L  b_L;
                 18  ''    ''   ''  0    0;
                 19  ''    ''   ''  0    0;
                 20  ''    ''   ''  0    0;
                 21  'T2'  'b'  41  a_T2 b_T2;
                 22  'T2'  'a'  41  a_T2 b_T2;
                 23  ''    ''   ''  0    0;
                 24  ''    ''   ''  0    0;
                 25  ''    ''   ''  0    0;
                 26  'L'   'b'  27  a_L  b_L;
                 27  'L'   'c'  ''  a_L  b_L;
                 28  ''    ''   ''  0    0;
                 29  ''    ''   ''  0    0;
                 30  ''    ''   ''  0    0;
                 31  'T2'  'b'  42  a_T2 b_T2;
                 32  'T2'  'a'  42  a_T2 b_T2;
                 33  ''    ''   ''  0    0;
                 34  'L'   'c'  ''  a_L  b_L;
                 35  'T2'  'c'  ''  a_T2 b_T2;
                 36  'T1'  'b'  80  a_T1 b_T1;
                 37  'T1'  'a'  80  a_T1 b_T1;
                 38  ''    ''   ''  0    0;
                 39  'T1'  'ar' 81  a_T1 b_T1; % the middle T-joint with reverse node order 
                 40  'T1'  'br' 81  a_T1 b_T1; % the middle T_joint with reverse node order
                 41  'T2'  'c'  ''  a_T2 b_T2};

% node info of nodes on the lower vertical inner beam
node_info_IB1 = [42 'T2'    'c' {''}  a_T2 b_T2;
    num2cell((43:79)'), cell(size((43:79)',1),3), num2cell(zeros(size((43:79)',1),2));
    80  'T1'    'c' {''}  a_T1 b_T1];
% node info of nodes on the higher vertical inner beam
node_info_IB2 = [81 'T1'    'c' {''}  a_T1 b_T1;
    num2cell((82:118)'), cell(size((82:118)',1),3),num2cell(zeros(size((82:118)',1),2));
    119  'T2'    'c' {''}  a_T2 b_T2];

% assemble node info list
node_info = [node_info_MF; 
             node_info_IB1; 
             node_info_IB2];
         