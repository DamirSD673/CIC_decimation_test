clear; close all

%% Specification

fs = 1e6; % (High) Sampling freq in Hz before decimation
L = 1000; % number of samples ~ 1000 ms
t = (0:L-1)/fs; % time grid

R = 128; %% Decimation factor
N = 5; %% Number of stages
D = 1; %% Differential delay

%% CIC Decimator

CICDecim = dsp.CICDecimator('DecimationFactor', R, ...
                            'NumSections',N, ...
                            'FixedPointDataType','Specify word and fraction lengths', ...
                            'SectionWordLengths', 26, ...
                            'SectionFractionLengths', 0, ...
                            'OutputWordLength', 16);

%% ---- CIC filter parameters ----

B = 23; %% Coeffi. Bit-width
Fc = 1*fs/(2*R); %% Pass band edge in Hz

% ------- fir2.m parameters -----
filter_order = 2^8; %% Filter order; must be even
Fo = R*Fc/fs; %% Normalized Cutoff freq; 0<Fo<=0.5/M;

%% ---- CIC Compensator Design using fir2.m ----

p = 2e3; %% Granularity
s = 0.25/p; %% Step size
fp = 0:s:Fo; %% Pass band frequency samples
f_stop = (Fo+s):s:0.5; %% Stop band frequency samples
f = [fp f_stop]*2; %% Normalized frequency samples; 0<=f<=1
Mp = ones(1,length(fp)); %% Pass band response; Mp(1)=1
Mp(2:end) = abs( D*R*sin(pi*fp(2:end)/R)./sin(pi*D*fp(2:end))).^N;
Mf = [Mp zeros(1,length(f_stop))];
f(end) = 1;
h = fir2(filter_order,f,Mf); %% Filter length L+1

h = h/max(h); %% Floating point coefficients
hz = round(h*power(2,B-1)-1); %% Fixed point coefficients

dsp_filter = dsp.FIRFilter(h);
fvtool(dsp_filter, 'Fs', fs/R)

%% ---- Filter Cascade ----

filter_cascade = dsp.FilterCascade(CICDecim, dsp_filter);

f = fvtool(CICDecim, dsp_filter, filter_cascade, ...
    'Fs', [fs, fs/R, fs]);

%f.NormalizeMagnitudeto1 = 'on';
legend(f,'CIC Decimator','CIC Compensation Decimator', ...
    'Overall Response');

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

sin_file = fopen('sine.mem', 'w');
for k = 1:L-1
    fprintf(sin_file, '%s\n', x_hex(k, :));
end
fprintf(sin_file, '%s', x_hex(k+1, :));
fclose(sin_file);
pwelch(x_chirp, kaiser(L), [], L, fs)

%% Pass Test Signal through Filter Cascade (CIC-FIR)

src = dsp.SignalSource(x_chirp, 64);

y = zeros(16,16);
for ii = 1:16
     y(ii,:) = CICDecim(src());   
end
y_vec = y'; y_vec = y_vec(:);

y_FIR = filter(h,1, y_vec);

figure()
pwelch(double(y_vec), kaiser(256), [], 256, fs/R)
hold on
pwelch(double(y_FIR), kaiser(256), [], 256, fs/R)
pwelch(x_chirp, kaiser(L), [], L, fs)
hold off
legend('CIC Filtered', 'FIR compensated', 'Original')