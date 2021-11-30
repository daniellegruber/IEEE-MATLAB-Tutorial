%% Setup
addpath(genpath('Helper Scripts'))
% save_dir = 'Lab 4 — Diodes and Transistors';

%% Figure settings
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex'); 

%% Circuit a

% Set parameters
max_mul_pi = 6;

Vpp_in = 6;
% V_out will lose 0.7 because of the diode
V_out = Vpp_in/2 - 0.7;

f = 60;
w = 2 * pi * f;
T = 1/f;

%% YOUR CODE HERE: Set the time range

% t is a vector of 100 evenly-spaced points that start at 0 and end at 
% max_mul_pi * pi

% YOUR CODE HERE
% t = linspace( ... );

%% YOUR CODE HERE: Create the figure
waveforms_a = figure('units','normalized','outerposition',[0 0 0.6 0.9]);

% Use the command that ensures any new plots are added to the same axes

% YOUR CODE HERE
% ...

%% YOUR CODE HERE: Set title, x label, y label
% Set title to be Theoretical Waveforms, Circuit A with font size 50
% Set x label to be $\omega t$ (latex format)
% Set y label to be Voltage $(V)$ (latex format)

% YOUR CODE HERE
% title( ... )
% xlabel( ... )
% ylabel( ... )

set(gca,'FontSize',20)
set(gcf,'color','w')

% y_ticks is a zero vector of length 4
% y_ticks is an empty cell of dimension 1 by 4

% YOUR CODE HERE
% y_ticks = zeros( ... );
% y_tick_labels = cell( ... );

% V_S
V_S = Vpp_in/2 * sin(t);
plot(t,V_S)
y_ticks(3:4) = [-Vpp_in/2,Vpp_in/2];
y_tick_labels(3:4) = cellstr(string([-Vpp_in/2,Vpp_in/2]));

% V_R
V_R = zeros(1,length(t));


for i = 0:2:max_mul_pi
    
    % pos_idx is where t is greater than pi * i and less than pi * (i + 1)
    % Don't use find(), just use logical operators
    
    % YOUR CODE HERE
    % pos_idx = ... 
    
    % Now fill the elements of V_R corresponding to this idx with the
    % values corresponding to V_out * sin(t(pos_idx))
    
    % YOUR CODE HERE
    % V_R( ... ) = ...  
end

%% YOUR CODE HERE: Shift down graph of V_R by 8 for plot

% YOUR CODE HERE
% shift = ... 
% V_R = ...  


%% YOUR CODE HERE: Plot V_R vs t

% YOUR CODE HERE
% plot( ... )


%% YOUR CODE HERE: Set y ticks and y tick labels

y_ticks(1:2) = [0, V_out] + shift;
y_tick_labels(1:2) = cellstr(string([0,V_out]));

% YOUR CODE HERE
% yticks( ... )
% yticklabels( ... )

legend({'$V_S$','$V_{out}$'})

%% YOUR CODE HERE: Set x ticks and x tick labels

% x_nums is a range that starts at 0, ends at max_mul_pi, and incremements
% by 1
% x_ticks is the x_nums vector multiplied by pi
% x_tick_labels is an empty cell array of dimension 1 by length(x_nums)

% YOUR CODE HERE
% x_nums = ... 
% x_ticks = ... 
% x_tick_labels = cell( ... );

for i = 1:length(x_nums)
    if i == 1
        x_tick_labels{i} = '0';
    elseif i == 2
        x_tick_labels{i} = '$\pi$';
    else
        x_tick_labels{i} = [num2str(x_nums(i)), '$\pi$'];
    end
end

% YOUR CODE HERE
% xticks( ... )
% xticklabels( ... )

xlim([t(1), t(end) + 1])

% Export figure 
% export_fig([save_dir, filesep, 'Waveforms Circuit A'], '-png', waveforms_a)

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

        %% YOUR CODE HERE: Find idx of positive half of waveform
        % By only filling in the positive idx you cut off the negative
        % half of the waveform
        
        curr_zero = (pi * 2*i - phi)/w; 
        next_zero = (pi * (2*i + 1) - phi)/w;
        
        % Hint: positive values occur between curr_zero and next_zero
        
        % YOUR CODE HERE
        % pos_idx = find( ... );
        
        % Now fill the elements of V_R corresponding to this idx with the
        % values corresponding to V_out * sin(w * t(pos_idx) + phi)
        
        % YOUR CODE HERE
        % V_R( ... ) =  ... 
 
         
        %% YOUR CODE HERE: Find idx of discharge period
        
        % Find idx of positive peak in V_R
        curr_peak = ((pi/2) * (4*i - 3) - phi)/w;
        
        % Hint: discharge period starts at curr_peak and ends at curr_peak
        % + discharge_period
        
        % YOUR CODE HERE
        % discharge_idx = find( ... );
        
        % Now get rid of any elements in discharge_idx greater than the
        % length of t
        
        % YOUR CODE HERE
        % discharge_idx( ... ) = [];
        

        if any(discharge_idx)
            
            % Point at which capacitor discharge begins is just after
            % voltage across resistor begins to fall 
            discharge_begin = t(t > curr_peak);
            discharge_begin = discharge_begin(1);
        
            % Shift t to make exp curve start from ~0 and look as it should
            t_shift = t(discharge_idx);
            t_shift = t_shift - discharge_begin;
            V_R(discharge_idx) = V_out * exp(-t_shift/(R*C));
        end
        
    end
    
    %% YOUR CODE HERE: Create a subplot
    
    % Create a 2x2 subplot and let the iteration variable c be the subplot
    % position (see MATLAB documentation)
    
    % YOUR CODE HERE
    % subplot( ... )
    
    % Plot V_R vs t and set the xticks to x_ticks and xticklabels to
    % x_tick_labels
    
    % YOUR CODE HERE
    % plot( ... )
    % xticks( ... )
    % xticklabels( ... )
    
    title(titles{c},'FontSize',30)
    set(gca,'FontSize',20)
end

% Special functions for subplot titles and labels
sgtitle(['Theoretical Waveforms for Circuit B by Capacitance, $V_{pp} = ',...
    num2str(Vpp_in),'$ V'],'FontSize',30)
suplabel('$\omega t$','x', 30)
suplabel('Voltage $(V)$','y', 30)
axis_prunelabels('xy', waveforms_b_vary_c)

% Export figure 
% export_fig([save_dir, filesep, 'Waveforms Circuit B by Capacitance'], '-png',waveforms_b_vary_c)

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

%% YOUR CODE HERE: Get Vpp titles for plot
 
% titles is an empty cell of dimension 1 by the length of Vpp_in_test
% YOUR CODE HERE
% titles = cell( ... );

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
        
        %% YOUR CODE HERE: Find idx of positive half of waveform
        % By only filling in the positive idx you cut off the negative
        % half of the waveform
        
        curr_zero = (pi * 2*i - phi)/w; 
        next_zero = (pi * (2*i + 1) - phi)/w;
        
        % Hint: positive values occur between curr_zero and next_zero
        
        % YOUR CODE HERE
        % pos_idx = find( ... );
        
        
        % Now fill the elements of V_R corresponding to this idx with the
        % values corresponding to V_out * sin(w * t(pos_idx) + phi)
        
        % YOUR CODE HERE
        % V_R( ... ) =  ...  
        
        %% YOUR CODE HERE: Find idx of discharge period
        
        % Find idx of positive peak in V_R
        curr_peak = ((pi/2) * (4*i - 3) - phi)/w;
        
        
        % Hint: discharge period starts at curr_peak and ends at curr_peak
        % + discharge_period
        
        % YOUR CODE HERE
        % discharge_idx = find( ... );
        
        % Now get rid of any elements in discharge_idx greater than the
        % length of t
        
        % YOUR CODE HERE
        % discharge_idx( ... ) = [];
        
        
        if any(discharge_idx)
            
            % Point at which capacitor discharge begins is just after
            % voltage across resistor begins to fall 
            discharge_begin = t(t > curr_peak);
            discharge_begin = discharge_begin(1);
        
            % Shift t to make exp curve start from ~0 and look as it should
            t_shift = t(discharge_idx);
            t_shift = t_shift - discharge_begin;
            V_R(discharge_idx) = V_out * exp(-t_shift/(R*C));
        end
        
    end
    
    %% YOUR CODE HERE: Create a subplot
    
    % Create a 2x2 subplot and let the iteration variable v be the subplot
    % position (see MATLAB documentation)
    
    % YOUR CODE HERE
    % subplot( ... )
    
    % Plot V_R vs t and set the xticks to x_ticks and xticklabels to
    % x_tick_labels
    
    % YOUR CODE HERE
    % plot( ... )
    % xticks( ... )
    % xticklabels( ... )
    
    title(titles{v},'FontSize',30)
    set(gca,'FontSize',20)
end

C_label = num2str(round(change_order_mag(C, get_order_mag(C)-new_order),2));

% Special functions for subplot titles and labels
sgtitle(['Theoretical Waveforms for Circuit B by by $V_{pp}$, $C = ',...
    C_label, ' \hspace{3pt}', latex_label, '$F'],'FontSize',30)

suplabel('$\omega t$','x', 30)
suplabel('Voltage $(V)$','y', 30)
axis_prunelabels('xy', waveforms_b_vary_vpp)

% Export figure 
% export_fig([save_dir, filesep, 'Waveforms Circuit B by Vpp'], '-png',waveforms_b_vary_vpp)

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

discharge_period = discharge_end - discharge_begin;
end