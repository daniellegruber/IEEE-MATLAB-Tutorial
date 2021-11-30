%% Setup
addpath(genpath('Helper Scripts'))
save_dir = 'Lab 4 — Diodes and Transistors';

%% Figure settings
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex'); 

%% Circuit a

% Set parameters
max_mul_pi = 6;
t = linspace(0,max_mul_pi*pi,100);

Vpp_in = 6;
% V_out will lose 0.7 because of the diode
V_out = Vpp_in/2 - 0.7;

f = 60;
w = 2 * pi * f;
T = 1/f;

waveforms_a = figure('units','normalized','outerposition',[0 0 0.6 0.9]);
hold on

title('Theoretical Waveforms, Circuit A','FontSize',50)
% title('Theoretical Half-Wave Rectifier Waveforms','FontSize',50)
xlabel('$\omega t$');
ylabel('Voltage $(V)$');

set(gca,'FontSize',20)
set(gcf,'color','w')

y_ticks = zeros(1,4);
y_tick_labels = cell(1,4);

% V_S
V_S = Vpp_in/2 * sin(t);
plot(t,V_S)
y_ticks(3:4) = [-Vpp_in/2,Vpp_in/2];
y_tick_labels(3:4) = cellstr(string([-Vpp_in/2,Vpp_in/2]));
% y_tick_labels(3:4) = {'$-V_S$','$V_S$'};

% V_R
V_R = zeros(1,length(t));

for i = 0:2:max_mul_pi
    pos_idx = t > pi*i & t < pi*(i+1);
    V_R(pos_idx) = V_out * sin(t(pos_idx));
end

% Shift down graph of V_D by 6 for plot
shift = -8;
V_R = V_R + shift;
plot(t,V_R)
y_ticks(1:2) = [0,V_out] + shift;
y_tick_labels(1:2) = cellstr(string([0,V_out]));
% y_tick_labels(1:2) = {'$0$','$V_{out}$'};

yticks(y_ticks)
yticklabels(y_tick_labels)

legend({'$V_S$','$V_{out}$'})

x_nums = 0:1:max_mul_pi;
x_ticks = x_nums * pi;
x_tick_labels = cell(1, length(x_nums));
for i = 1:length(x_nums)
    if i == 1
        x_tick_labels{i} = '0';
    elseif i == 2
        x_tick_labels{i} = '$\pi$';
    else
        x_tick_labels{i} = [num2str(x_nums(i)), '$\pi$'];
    end
end
xticks(x_ticks)
xticklabels(x_tick_labels)
xlim([t(1), t(end) + 1])
export_fig([save_dir, filesep, 'Waveforms Circuit A'], '-png', waveforms_a)

%% Subplots - vary capacitance

% Set parameters
max_mul_T = 6;
t = linspace(0,T*(max_mul_T/2),100);

% Vary C
C_test = [0.1, 1, 10,100] * 10^(-6);

Vpp_in = 6;
% V_out will lose 0.7 because of the diode
V_out = Vpp_in/2 - 0.7;

R = 4.7 * 10^3;

f = 60;
w = 2 * pi * f;
T = 1/f;

% Get C titles for plot
[C_scaled, new_order, latex_label, ~] = scientific_rescale(C_test);
titles = cell(1,length(C_scaled));
for c = 1:length(C_scaled)
    titles{c} = ['$C = ', num2str(round(C_scaled(c),2)), ' \hspace{3pt}', latex_label, '$F'];
end

% Create figure 
waveforms_b_vary_c = figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'color','w')

% For each C
for c = 1:length(C_test)
    
    % Find reactance and phase angle
    C = C_test(c);
    XC = 1/(2 * pi * f * C);
    phi = atan((-R/XC)) + pi;
    
    % Find capacitor discharge period
    discharge_period = find_discharge_period(V_out, w, phi, R, C, t);
    
    % Create waveform for V_R
    V_R = zeros(1,length(t));

    % For each multiple of the period T
    for i = 0:1:max_mul_T
        
        % Find idx of positive half of waveform
        curr_zero = (pi * 2*i - phi)/w; 
        next_zero = (pi * (2*i + 1) - phi)/w;
        
        % By only filling in the positive idx you cut off the negative
        % half of the waveform
        pos_idx = find(t >= curr_zero & t < next_zero);
        V_R(pos_idx) = V_out * sin(w * t(pos_idx) + phi);
 
        % Find idx of positive peak in V_R
        curr_peak = ((pi/2) * (4*i - 3) - phi)/w;
         
        % Find idx of discharge period
        discharge_idx = find(t >= curr_peak & t < (curr_peak + discharge_period));
        discharge_idx(discharge_idx > length(t)) = [];
        
        if any(discharge_idx)
            
            % Point at which capacitor discharge begins is just after
            % voltage across resistor begins to fall 
            discharge_begin = t(t > curr_peak);
            discharge_begin = discharge_begin(1);
%             discharge_begin = curr_peak;
        
            % Shift t to make exp curve start from ~0 and look as it should
            t_shift = t(discharge_idx);
            t_shift = t_shift - discharge_begin;
            V_R(discharge_idx) = V_out * exp(-t_shift/(R*C));
        end
        
    end
    
    subplot(2,2,c)
    plot(t,V_R)
    xticks(x_ticks)
    xticklabels(x_tick_labels)
    
    title(titles{c},'FontSize',30)
    set(gca,'FontSize',20)
end

sgtitle(['Theoretical Waveforms for Circuit B by Capacitance, $V_{pp} = ',...
    num2str(Vpp_in),'$ V'],'FontSize',30)
suplabel('$\omega t$','x', 30)
suplabel('Voltage $(V)$','y', 30)
axis_prunelabels('xy', waveforms_b_vary_c)
export_fig([save_dir, filesep, 'Waveforms Circuit B by Capacitance'], '-png',waveforms_b_vary_c)

%% Subplots - vary Vpp

% Set parameters
t = linspace(0,T*(max_mul_T/2),100);

% Vary Vpp_in
Vpp_in_test = [2, 4, 5, 6];

R = 4.7 * 10^3;
C = 1 * 10^(-6);
XC = 1/(2 * pi * f * C);
phi = atan((-R/XC)) + pi;

f = 60;
w = 2 * pi * f;
T = 1/f;

% Get Vpp titles for plot
titles = cell(1,length(Vpp_in_test));
for v = 1:length(Vpp_in_test)
    Vpp_in = Vpp_in_test(v);
    titles{v} = ['$V_{pp} = ', num2str(Vpp_in), '$ V'];
end

% Find capacitor discharge period
    discharge_period = find_discharge_period(V_out, w, phi, R, C, t);

% Create figure 
waveforms_b_vary_vpp = figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'color','w')

% For each Vpp_in
for v = 1:length(Vpp_in_test)
    Vpp_in = Vpp_in_test(v);
    
    % V_out will lose 0.7 because of the diode
    V_out = Vpp_in/2 - 0.7;
    
    % Create waveform for V_R
    V_R = zeros(1,length(t));

    % For each multiple of the period T
    for i = 0:1:max_mul_T
        
        % Find idx of positive half of waveform
        curr_zero = (pi * 2*i - phi)/w; 
        next_zero = (pi * (2*i + 1) - phi)/w;
        pos_idx = find(t >= curr_zero & t < next_zero);
        
        % By only filling in the positive idx you cut off the negative
        % half of the waveform
        V_R(pos_idx) = V_out * sin(w * t(pos_idx) + phi);
        
        % Find idx of positive peak in V_R
        curr_peak = ((pi/2) * (4*i - 3) - phi)/w;
        
        % Find idx of discharge period
        discharge_idx = find(t >= curr_peak & t < (curr_peak + discharge_period));
        discharge_idx(discharge_idx > length(t)) = [];
        
        if any(discharge_idx)
            
            % Point at which capacitor discharge begins is just after
            % voltage across resistor begins to fall 
            discharge_begin = t(t > curr_peak);
            discharge_begin = discharge_begin(1);
%             discharge_begin = curr_peak;
        
            % Shift t to make exp curve start from ~0 and look as it should
            t_shift = t(discharge_idx);
            t_shift = t_shift - discharge_begin;
            V_R(discharge_idx) = V_out * exp(-t_shift/(R*C));
        end
        
    end
    
    subplot(2,2,v)
    plot(t,V_R)
    xticks(x_ticks)
    xticklabels(x_tick_labels)
    
    title(titles{v},'FontSize',30)
    set(gca,'FontSize',20)
end

C_label = num2str(round(change_order_mag(C, get_order_mag(C)-new_order),2));
sgtitle(['Theoretical Waveforms for Circuit B by by $V_{pp}$, $C = ',...
    C_label, ' \hspace{3pt}', latex_label, '$F'],'FontSize',30)

suplabel('$\omega t$','x', 30)
suplabel('Voltage $(V)$','y', 30)
axis_prunelabels('xy', waveforms_b_vary_vpp)
export_fig([save_dir, filesep, 'Waveforms Circuit B by Vpp'], '-png',waveforms_b_vary_vpp)

%% Functions

function discharge_period = find_discharge_period(V_out, w, phi, R, C, t) 
% Finds capacitor discharge period
i = 2;
curr_peak = ((pi/2) * (4*i - 3) - phi)/w; 

search_low = ((pi/2) * (4*i - 1) - phi)/w; 
search_high = ((pi/2) * (4*(i+1) - 3) - phi)/w;

t_search = t(t >= search_low & t < search_high);
t_shift = t_search - search_low;
[~, idx] = min(abs(V_out * exp(-t_shift/(R*C)) - V_out * sin(w * t_search + phi)));
discharge_end = t_search(idx);

discharge_begin = t(t > curr_peak);
discharge_begin = discharge_begin(1);
% discharge_begin = curr_peak;

discharge_period = discharge_end - discharge_begin;
end