%% Setup
s = tf('s');

%% 4.1 Basics
% 4.1.1

G = 3*(-s+1)/((5*s+1)*(10*s+1));
[Gm, Pm, wp, wc] = margin(G);
margin(G);


% Need Pm = 30 deg at wc = 0.4 rad/s
phase_rec = 35;
Beta = 0.48; % Approx
w_c = 0.4;   % rad/s

tau_D = 1/(w_c*sqrt(Beta));
K = 1;

F = K*(tau_D*s + 1)/(Beta*tau_D + 1);
%%
margin(F*G)


%% 4.2 Disturbance Attenuation

F = 1000/(s^3 + 11*s^2 + 10*s);
margin(F)