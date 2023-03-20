clear; close all

[m_path, m_name] = fileparts(mfilename('fullpath'));


fs = 1e6; % sampling frequency
L = 1000; % number of samples ~ 1 ms

t = (0:L-1)/fs; % time grid

f_span = linspace(0, fs/10, L);
x_chirp = sin(2*pi*f_span.*t)';

x_chirp_scaled = (2^15-1)*x_chirp/max(x_chirp);
x_chirp_int = int16(x_chirp_scaled);

% write hex coefficient file
x_hex = dec2hex(x_chirp_int, 4);

signal_file = fopen([m_path, '/hdl/', 'sine.mem'], 'w');
for k = 1:L-1
    fprintf(signal_file, '%s\n', x_hex(k, :));
end
fprintf(signal_file, '%s', x_hex(k+1, :));

%% Filter Coefficients 

% CIC parameters
R = 4;                          % Decimation factor
N = 5;                          % Number of stages
D = 1;                          % Differential delay

% FIR parameters
B = 23;                         % Coeffi. Bit-width
Fc = 1*fs/(2*R);                % Pass band edge in Hz
L_filter = 2^8;                 % Filter order; must be even
Fo = R*Fc/fs;                   % Normalized Cutoff freq;
p = 2e3;                        % Granularity
s = 0.25/p;                     % Step size
f_pass = 0:s:Fo;                % Pass band frequency samples
f_stop = (Fo+s):s:0.5;          % Stop band frequency samples
f = [f_pass f_stop]*2;          % Normalized frequency samples; 0<=f<=1
Mp = ones(1,length(f_pass));    % Pass band response; Mp(1)=1
Mp(2:end) = abs( D*R*sin(pi*f_pass(2:end)/R)./sin(pi*D*f_pass(2:end))).^N;
Mf = [Mp zeros(1,length(f_stop))];
f(end) = 1;
h = fir2(L_filter,f,Mf);        % Filter length L+1
h = h/max(h);                   % Floating point coefficients
hz = round(h*power(2,B-1)-1);   % Integer coefficients

write_coe(h, 23, "filter_R4_N4_D1.coe") % write 23 bits length to file

%%
sin_out = readmatrix('sin_dec_out.txt');