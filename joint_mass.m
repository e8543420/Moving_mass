% joint centre mass
function jc_m = joint_mass(alpha,beta,rho)
bt = 0.0047; % m % half thickness of the beam
b = 0.06; % m
% joint centre mass is related to the offset a and b of the joint.
A_m = 2*bt*(2*alpha + beta - bt); % mass cross-section area
% bt is half thickness of the beam
jc_m = rho * b * A_m; % joint centre mass
% rho is the density
% b is the wideness of the beam
end