clear; close all

[m_path, m_name] = fileparts(mfilename('fullpath'));


fs = 1e6; % sampling frequency
f_1 = 5e4; % first harmonic
f_2 = 3e5; % secong harmonic
L = 1000; % number of samples ~ 1000 ms

t = (0:L-1)/fs; % time grid

x = cos(2*pi*f_1*t) + cos(2*pi*f_2*t);
x = x - min(x); % unsigned signal

x = round(x/max(x)*65355); % quatization 16 bit

% write hex coefficient file
x_hex = dec2hex(x, 4);
h = fopen([m_path, '/hdl/', 'sine.mem'], 'w');
for k = 1:L-1
    fprintf(h, '%s\n', x_hex(k, :));
end
fprintf(h, '%s', x_hex(k+1, :));

%%
sin_out = readmatrix('sin_dec_out.txt');

f_vals = linspace(0, fs, L);
[pxx,f] = periodogram(x, kaiser(length(x), 38), L, fs);
[psin, f_dec] = periodogram(sin_out, kaiser(length(sin_out), 38), length(sin_out), fs/4);
figure()
semilogy(f, pxx)
grid on
hold on
semilogy(f_dec, psin)
hold off
legend({'Initial Signal', 'Filtered decimated'})