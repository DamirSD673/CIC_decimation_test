clear; close all; clc

%% Specification

fs = 1e6; % (High) Sampling freq in Hz before decimation
L = 1000; % number of samples ~ 1000 ms
t = (0:L-1)/fs; % time grid

R = 128; %% Decimation factor
N = 5; %% Number of stages
D = 1; %% Differential delay

%% Generate Coefficient Bank

% number of decimations coeffs
num_dec_coeffs = 6;
R_vals = 2.^(2:num_dec_coeffs+1);

% each filter length: final filter length (L_filter*num_dec_coeefs)
filter_order = 2^8; %% Filter order; must be even
filter_length = filter_order + 1;

coeff_bank       = zeros(num_dec_coeffs*filter_length, 1);
coeff_bank_fixed = zeros(num_dec_coeffs*filter_length, 1);

for curr_R = 1:num_dec_coeffs

    R = R_vals(curr_R);

    B = 23; %% Coeffi. Bit-width
    Fc = 1*fs/(2*R); %% Pass band edge in Hz

    % ------- fir2.m parameters -----
    Fo = R*Fc/fs; %% Normalized Cutoff freq; 0<Fo<=0.5/M;

    p = 2e3;                      % Granularity
    s = 0.25/p;                   % Step size
    fp = 0:s:Fo;                  % Pass band frequency samples
    f_stop = (Fo+s):s:0.5;        % Stop band frequency samples
    f = [fp f_stop] * 2;          % Normalized frequency samples; 0<=f<=1
    Mp = ones(1, length(fp));     % Pass band response; Mp(1)=1
    Mp(2:end) = abs(D * R * sin(pi * fp(2:end) / R)./sin(pi * D * fp(2:end))).^N;
    Mf = [Mp zeros(1, length(f_stop))];
    f(end) = 1;
    h = fir2(filter_order, f, Mf);      % Filter length L+1

    h = h/max(h);                 % Floating point coefficients
    hz = round(h * power(2, B-1)-1); % Fixed point coefficients

    coeff_bank( (curr_R-1)*filter_length + 1 : curr_R*filter_length ) = h;
    coeff_bank_fixed( (curr_R-1)*filter_length + 1 : curr_R*filter_length ) = hz;
end

integer = 0;
filename = sprintf(['FIR_', 'R_%d', '.coe'], R);

if integer
    write_coe(coeff_bank_fixed, 23, filename)
else
    write_coe(coeff_bank, 23, filename)
end