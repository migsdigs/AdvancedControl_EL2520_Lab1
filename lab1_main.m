%% Setup
s = tf('s');

%% 4.1 Basics
%% 4.1.1

G = 3*(-s+1)/((5*s+1)*(10*s+1));

% Lead Compensation
% Need Pm = 30 deg at wc = 0.4 rad/s
Beta = 0.56; % Approx
w_c = 0.4;   % rad/s

tau_D = 1/(w_c*sqrt(Beta));
F_lead = (tau_D*s + 1)/(Beta*tau_D*s + 1);

% Solve for K
gain = evalfr(G*F_lead,w_c*1i);
K = 1/norm(gain);

F_lead = K*F_lead;

% Plot Bode for Lead Compensated System
% [Gm, Pm, wp, wc] = margin(F_lead*G);
% margin(F_lead*G)
sys = F_lead*G;
figure(1);
step(sys)

% Lag Compensation
gamma = 0.2;
tau_I = 10/w_c;

F_lag = (tau_I*s+1)/(tau_I*s+gamma);

ol = F_lag*F_lead*G;
[Gm, Pm, wp, wc] = margin(ol);

figure(1);
margin(ol)

cl = ol/(1+ol);
figure(2);
step(cl);

%% 4.1.2 
% Bandwidth
bw = bandwidth(cl);

% Resonance Peak M_T
M_T = getPeakGain(cl);
M_T_dB = mag2db(M_T);

%% 4.1.3
% Lead Compensation
% Need Pm = 30 deg at wc = 0.4 rad/s
Beta = 0.26; % Approx
w_c = 0.4;   % rad/s

tau_D = 1/(w_c*sqrt(Beta));
F_lead = (tau_D*s + 1)/(Beta*tau_D*s + 1);

% Solve for K
gain = evalfr(G*F_lead,w_c*1i);
K = 1/norm(gain);

F_lead = K*F_lead;

% Plot Bode for Lead Compensated System
% [Gm, Pm, wp, wc] = margin(F_lead*G);


sys = F_lead*G;
figure(1);
step(sys)

% Lag Compensation
F_0 = 5;
gamma = 0.2;
tau_I = 10/w_c;

F_lag = (tau_I*s+1)/(tau_I*s+gamma);

ol = F_lag*F_lead*G;
[Gm, Pm, wp, wc] = margin(ol);

figure(1);
margin(ol)

cl = ol/(1+ol);
figure(2);
step(cl);

% Determine Bandwidth and Resonance Peak
bw = bandwidth(cl);

M_T = getPeakGain(cl);
M_T_dB = mag2db(M_T);

