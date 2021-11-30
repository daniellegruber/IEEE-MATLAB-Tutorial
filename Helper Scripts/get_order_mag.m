function order = get_order_mag(x, base)
%GET_ORDER_MAG Returns order of magnitude of input for given base. Default is
%base 10.
%   Inputs
%   ----------
%   x: scalar or array to get order of
%
%   base: scalar, base to use
%
%   Outputs
%   ----------
%   n: order of magnitude, will have same dimension as input

if nargin < 2
    base = 10;
end
order = floor(log(abs(x))./log(base));