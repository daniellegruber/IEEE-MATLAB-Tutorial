function [x_scaled, new_order, plot_label, console_label] = scientific_rescale(x)
%SCIENTIFIC_RESCALE Rescales an input to the closest scientific order.
%   Inputs
%   ----------
%   x: double, scalar or array to be rescaled
%
%   Outputs
%   ----------
%   x_scaled: x, rescaled to new order
%
%   latex_label: label associated with new order, formatted for a plot that
%   uses latex interpreter
%
%   console_label: label associated with new order, formatted for printing
%   to console

% Set orders of units
orders = [-6, -3, 0, 3, 6];
latex_labels = {'\mu','m','','k','M'};
console_labels = {'u','m','','k','M'};

% Get order and rescale to closest scientific order
order = floor(log(abs(x))./log(10));
curr_order = median(order);
for i = 1:length(orders)-1
    if curr_order >= orders(i) && curr_order < orders(i+1)
        x_scale_idx = i;
        new_order = orders(i);
    end
end

plot_label = latex_labels{x_scale_idx};
console_label = console_labels{x_scale_idx};
x_scaled = x * 10^(-orders(x_scale_idx));
end

