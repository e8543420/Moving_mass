function [Ke Me] = ElemMtx(L,E,poisson,G,rho,b,h)

% intermediate constants
% G = E/2/(1+poisson);
% inertia
Iz = b*h^3/12;
Iy = b^3*h/12;
Ix = Iy + Iz; % polar moment of inertia
J = b * h^3 * (1/3 - 0.21*h/b*(1 - h^4/12/b^4)); % G*J is the torsional stiffness. axis of twist and the centroidal axis frequently do not coincide
A= b*h; % area

% element stiffness matrix
ux = E*A/L;        uy = 12*E*Iz/L^3;  uz = 12*E*Iy/L^3;
tx = G*J/L;        ty = 4*E*Iy/L;     tz = 4*E*Iz/L;
uzty = 6*E*Iy/L^2; uytz = 6*E*Iz/L^2;
%      ux     uy     uz     tx     ty     tz     ux     uy     uz     tx     ty     tz
Ke = [ ux      0      0      0      0      0    -ux      0      0      0      0      0;
        0     uy      0      0      0   uytz      0    -uy      0      0      0   uytz;
        0      0     uz      0  -uzty      0      0      0    -uz      0  -uzty      0;
        0      0      0     tx      0      0      0      0      0    -tx      0      0;
        0      0  -uzty      0     ty      0      0      0   uzty      0   ty/2      0;
        0   uytz      0      0      0     tz      0  -uytz      0      0      0   tz/2;
      -ux      0      0      0      0      0     ux      0      0      0      0      0;
        0    -uy      0      0      0  -uytz      0     uy      0      0      0  -uytz;
        0      0    -uz      0   uzty      0      0      0     uz      0   uzty      0;
        0      0      0    -tx      0      0      0      0      0     tx      0      0;
        0      0  -uzty      0   ty/2      0      0      0   uzty      0     ty      0;
        0   uytz      0      0      0   tz/2      0  -uytz      0      0      0     tz;];

% element mass matrix
Me = [140      0      0         0       0       0   70      0      0         0       0       0;
        0    156      0         0       0    22*L    0     54      0         0       0   -13*L;
        0      0    156         0   -22*L       0    0      0     54         0    13*L       0;
        0      0      0  140*Ix/A       0       0    0      0      0   70*Ix/A       0       0;
        0      0  -22*L         0   4*L^2       0    0      0  -13*L         0  -3*L^2       0;
        0   22*L      0         0       0   4*L^2    0   13*L      0         0       0  -3*L^2;
       70      0      0         0       0       0  140      0      0         0       0       0;
        0     54      0         0       0    13*L    0    156      0         0       0   -22*L;
        0      0     54         0   -13*L       0    0      0    156         0    22*L       0;
        0      0      0   70*Ix/A       0       0    0      0      0  140*Ix/A       0       0;
        0      0   13*L         0  -3*L^2       0    0      0   22*L         0   4*L^2       0;
        0  -13*L      0         0       0  -3*L^2    0  -22*L      0         0       0   4*L^2];
Me = rho*A*L/420*Me;
end