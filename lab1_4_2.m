%% 4.2 Disturbance Attenuation
% Setup
s = tf('s');
G = 20/((s+1)*((s/20)^2 + s/20 +1));
G_d = 10/(s+1);

[Gm,Pm,Wcg,Wcp] = margin(G_d);

%% 4.2.1
% Improper Design
F_y_1 = G^-1 * ((Wcp)/s);

% Proper Design
% Pole to make it proper
pole_place = 10*Wcp;
F_y_2 = F_y_1*(pole_place^2/(s+pole_place)^2);
ol = F_y_2*G;

margin(ol);

d_to_y = G_d/(1+F_y_2*G);

figure(1);
margin(d_to_y);

figure(2);
step(d_to_y)

%% 4.2.2
% Improper Design
wI = Wcp;
F_y_3 = ((s+wI)/s) * G_d/G;

ol_3 = F_y_3*G;
cl_3 = G_d/(1+ol_3);


% Proper Design (need to add two poles)
pole_placement = 10*wI;
F_y_4 = F_y_3 * (pole_placement)^2/(s+pole_placement)^2;

ol_4 = F_y_4 * G;

cl_4 = G_d / (1+ol_4);

clf();
figure(1);
step(cl_4);

figure(2);
margin(ol_4)


%% 4.2.3
tau = 0.135;
Fr = 1/(1+tau*s);

Fy = F_y_4;
G = G;
Gd = G_d;

ol = Fy*G;

%lead compensation

wc_desired = 12;
pm_desired = 60;

beta = 0.85;
tau_d = 1/(wc_desired*sqrt(beta));

F_lead = (tau_d*s + 1)/(beta*tau_d*s + 1);

% Solve for K
gain = evalfr(G*F_lead*Fy,wc_desired*1i);
K = 1/norm(gain);
% K = 0.75;

F_lead = K*F_lead;

Fy_lead = F_lead*Fy;

% end lead compensation

ol = Fy_lead*G;
cl = Fr*(ol)/(1+ol);

S = 1/(1+ol);
T = 1-S;
u_r = Fy_lead*Fr*S;
u_d = Fy_lead*Gd*S;


clf('reset');

% Check specs for r -> y
figure(1);
step(cl); grid on;
title('Step Response of Output due to Reference'); xlabel('Time'); ylabel('y'); grid on;

figure(2);
margin(ol);

stepinfo(cl)

% Check specs for u -> y
[step_u_r,time_r] = step(u_r, 10);
[step_u_d,time_d] = step(u_d, 10);
step_u_rd = step_u_r + step_u_d;
time = time_r;

figure(3);
hold on
plot(time_r,step_u_r,'b');
plot(time_d,step_u_d,'r');
plot(time,step_u_rd,'k');
hold off
title('Step Response of Input');
xlabel('Time'); ylabel('u'); ylim([0,1.2]); xlim([0,1]); grid on;
legend('Response to Reference Step of 1', 'Response to Disturbance Step of -1', 'Response to Reference & Disturbance Steps of 1 & -1')

% Check specs for d -> y
figure(4);
d_to_y = Gd/(1+ol);
step(d_to_y)
hold on
title('Step Response of Output due to Disturbance');
xlabel('Time');
ylabel('y');
grid on;
hold off

% Check Sensitivity and Complementary Sensitivity
figure(5);
hold on;
bode(S);
bode(T);
hold off;
title('Bode Diagram of S and T');
legend('Sensitivity, S', 'Complementary Sensitivity, T')

[Gm_pls,Pm_pls,Wcg_pls,Wc_pls] = margin(S);
Wc_pls



