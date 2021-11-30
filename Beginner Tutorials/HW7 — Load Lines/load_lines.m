%% Setup
addpath(genpath('Helper Scripts'))
addpath(genpath('General Code'))
save_dir = 'HW7 — Load Lines';

%% Figure settings
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex'); 

%% Generate plots

% Part a
V_0 = 2;
R = 400;
V_D = linspace(0,V_0 * 1.05,4000);
I_D = diode_current(V_D);
I_R = resistor_current(V_D, V_0, R);
load_line_plot(V_D, I_D, I_R, 'Part a', save_dir)

% Part b
V_0 = 10;
R = 10 * 10^3;
V_D = linspace(0,V_0 * 1.05,4000);
I_D = diode_current(V_D);
I_R = resistor_current(V_D, V_0, R);
load_line_plot(V_D, I_D, I_R, 'Part b', save_dir)

% Part c
V_0 = 1;
R = 200;
V_D = linspace(0,V_0 * 1.05,4000);
I_D = diode_current(V_D);
I_R = resistor_current(V_D, V_0, R);
load_line_plot(V_D, I_D, I_R, 'Part c', save_dir)
%% Current functions

function I_D = diode_current(V_D)
    I_D = 10^(-14) * (exp(V_D / (26 * 10^(-3))) - 1);
end
function I_R = resistor_current(V_D, V_0, R)
    I_R = (V_0 - V_D) / R;
end
