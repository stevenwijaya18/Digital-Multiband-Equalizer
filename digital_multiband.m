clear; close all; clc;

% Setup Audio 
fs = 44100;
samplesPerFrame = 128;

% Setup Reader/Writer using ASIO Driver
try
    reader = audioDeviceReader('Driver', 'ASIO', ...
                               'Device', 'ASIO4ALL v2', ...
                               'SampleRate', fs, ...
                               'SamplesPerFrame', samplesPerFrame);
                           
    writer = audioDeviceWriter('Driver', 'ASIO', ...
                               'Device', 'ASIO4ALL v2', ...
                               'SampleRate', fs);
                               
    disp('Driver ASIO4ALL is ready');
    
catch ME
    disp('Error ASIO not detected');
    rethrow(ME); 
end

% Parameter Filter Hybrid
N_FIR = 64;   
frekuensi = [1000, 3000, 5000, 8000, 16000];
Rock = [6 -8 -3 2 4 8];
Jazz = [4 2 -4 -4 2 0];
Pop  = [5 2 0 2 5 3];
Flat = [0 0 0 0 0 0];

N_IIR = 4; Fc_IIR = 8000; % IIR Cut-off


% User Input and Filtering Mode
Mode_Input = input('Choose mode (Rock, Jazz, Pop, Flat): ', 's');

switch lower(Mode_Input)
    case 'rock', Mode_Aktif = Rock; Mode_Nama = 'Rock';
    case 'jazz', Mode_Aktif = Jazz; Mode_Nama = 'Jazz';
    case 'pop',  Mode_Aktif = Pop;  Mode_Nama = 'Pop';
    otherwise,   Mode_Aktif = Flat; Mode_Nama = 'Flat';
end

% Calculate FIR Coefficient b and IIR Coefficient a and b
if strcmpi(Mode_Nama, 'Flat')
    b_fir = 1;
else
    b_fir = ekualisasiParalel(frekuensi, Mode_Aktif, N_FIR, fs);
end
[b_iir, a_iir] = butter(N_IIR, Fc_IIR/(fs/2), 'low');

% Setup Filter Object
firFilter = dsp.FIRFilter('Numerator', b_fir);
iirFilter = dsp.IIRFilter('Numerator', b_iir, 'Denominator', a_iir);

% Visualization
[h_fir, w] = freqz(b_fir, 1, 1024, fs);
[h_iir, ~] = freqz(b_iir, a_iir, 1024, fs);
h_total = h_fir .* h_iir;

% Phase Calculation
phi = angle(h_total);
phase_deg = unwrap(phi) * 180/pi;

% Plotting
f = figure(1); set(gcf, 'Color', 'w');

% Subplot 1: Magnitude
subplot(2, 1, 1);
plot(w, 20*log10(abs(h_total)), 'LineWidth', 2, 'Color', 'b');
title(['Magnitude Response: Mode ' Mode_Nama ' (Hybrid ASIO)']);
ylabel('Magnitude (dB)'); grid on;
set(gca, 'XScale', 'log'); xlim([20 20000]); ylim([-30 20]);

% Subplot 2: Phase
subplot(2, 1, 2);
plot(w, phase_deg, 'LineWidth', 1.5, 'Color', 'r');
title('Phase Response');
xlabel('Frekuensi (Hz)'); ylabel('Phase (Degrees)');
set(gca, 'XScale', 'log'); grid on; xlim([20 20000]);

% Auto-Save
set(gcf, 'Visible', 'on'); drawnow;
namaFile = ['Bukti_ASIO_Hybrid_' Mode_Nama '.png'];
saveas(f, namaFile); 
pause(1); 

% Loop Real-Time ASIO
disp('Start Streaming ASIO... (Press Ctrl+C to Stop)');
try
    while true
        % 1. Input (ASIO)
        audioIn = reader();
        
        % 2. Hybrid Process
        audioMid = firFilter(audioIn); 
        audioOut = iirFilter(audioMid);
        
        % 3. Limiter
        audioOut(audioOut > 0.99) = 0.99;
        audioOut(audioOut < -0.99) = -0.99;
        
        % 4. Output (ASIO)
        writer(audioOut);
    end
catch
    release(reader); release(writer);
    disp('Program Berhenti.');
end

% Paralel Equalizer Function
function b_total = ekualisasiParalel(F, G_dB, N, Fm)
    G_linear = db2mag(G_dB);
    F_norm = F / (Fm/2);
    b_total = fir1(N, F_norm(1), 'low') * G_linear(1);
    for i = 1:length(F)-1
        b_bp = fir1(N, [F_norm(i), F_norm(i+1)], 'bandpass') * G_linear(i+1);
        b_total = b_total + b_bp;
    end
    b_hp = fir1(N, F_norm(end), 'high') * G_linear(end);
    b_total = b_total + b_hp;
end
