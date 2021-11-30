function [scaled_output,curr_order] = change_order_mag(x, desired_order, base)
%GET_ORDER_MAG Scales input to desired order of magnitude for given base. 
%Default is base 10.
%   Inputs
%   ----------
%   x: scalar or array to get order of
%
%   base: scalar, base to use
%
%   Outputs
%   ----------
%   n: order of magnitude, will have same dimension as input

if nargin < 3
    base = 10;
end

curr_order = median(get_order_mag(x, base));
scaled_output = x * base^(desired_order - curr_order);