clear; close all
[m_path, m_name] = fileparts(mfilename('fullpath'));

%% Specification

fs = 1e6; % (High) Sampling freq in Hz before decimation
L = 1000; % number of samples ~ 1000 ms
t = (0:L-1)/fs; % time grid

%% Generate Test Signal

d = 2; % fraction of initial sampling freq. f_range = [0, fs/d]
f_span = linspace(0, (fs/d)/2, L);
x_chirp = sin(2*pi*f_span.*t)';

x_chirp_scaled = (2^15-1)*x_chirp/max(x_chirp);
x_chirp_int = int16(x_chirp_scaled);

pspectrum(x_chirp,fs,'spectrogram','TimeResolution',0.0001, ...
    'OverlapPercent',50,'Leakage',0.85)

% write hex coefficient file
x_hex = dec2hex(x_chirp_int, 4);

signal_file = fopen([m_path, '/hdl/', 'sine.mem'], 'w');
for k = 1:L-1
    fprintf(signal_file, '%s\n', x_hex(k, :));
end
fprintf(signal_file, '%s', x_hex(k+1, :));

pwelch(x_chirp, kaiser(L), [], L, fs)

