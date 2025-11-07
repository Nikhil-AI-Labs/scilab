clc;
clear;
clf;

A_c = 4;      
A_m = 2;    
f_c = 100;    
f_m = 10;     
fs = 1000;          // Sampling frequency
t = 0:1/fs:1;       // Time vector
N = length(t);

// ---------- Signals ----------
y_msg = A_m * sin(2*%pi*f_m*t);           // Message
y_carrier = A_c * sin(2*%pi*f_c*t);       // Carrier
y_dsb_sc = y_msg .* y_carrier;            // DSB-SC
y_dsb_fc = A_c*(1 + (y_msg/A_m)) .* sin(2*%pi*f_c*t);  // DSB-FC (AM with carrier)

// Envelope detection (rectify only, for time-domain view)
y_env = abs(y_dsb_fc);

// ---------- Demodulation ----------
// Envelope detection for DSB-FC
s_rect_fc = abs(y_dsb_fc);
Y_fc = fft(s_rect_fc);
f = (0:N-1)*(fs/N);
cutoff = 2*f_m;
for i=1:N
    if f(i) > cutoff then
        Y_fc(i) = 0;
    end
end
y_dem_fc = real(ifft(Y_fc));   // Demodulated message from DSB-FC

// Coherent detection for DSB-SC
y_dem_sc = y_dsb_sc .* (2/A_c * sin(2*%pi*f_c*t));  // Multiply by carrier
// LPF
Y_sc = fft(y_dem_sc);
for i=1:N
    if f(i) > cutoff then
        Y_sc(i) = 0;
    end
end
y_dem_sc = real(ifft(Y_sc));   // Demodulated message from DSB-SC

// ---------- Frequency Axis ----------
f_axis = (-N/2:N/2-1)*(fs/N);

// ---------- Spectra ----------
MSG   = fftshift(abs(fft(y_msg))/N);
CARR  = fftshift(abs(fft(y_carrier))/N);
DSBSC = fftshift(abs(fft(y_dsb_sc))/N);
DSBFC = fftshift(abs(fft(y_dsb_fc))/N);
DEM_SC = fftshift(abs(fft(y_dem_sc))/N);
DEM_FC = fftshift(abs(fft(y_dem_fc))/N);

// ---------- TIME DOMAIN PLOTS ----------
figure;
subplot(3,2,1);
plot(t,y_msg);
title('Message Signal');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,2,2);
plot(t,y_carrier);
title('Carrier Signal');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,2,3);
plot(t,y_dsb_sc);
title('DSB-SC Signal (Suppressed Carrier)');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,2,4);
plot(t,y_dsb_fc);
title('DSB-FC Signal (AM with Carrier)');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,2,5);
plot(t,y_dem_sc);
title('Demodulated Message (from DSB-SC)');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,2,6);
plot(t,y_dem_fc);
title('Demodulated Message (from DSB-FC)');
xlabel('Time (s)'); ylabel('Amplitude');

// ---------- FREQUENCY DOMAIN PLOTS ----------
figure;
subplot(3,2,1);
plot(f_axis,MSG);
title('Spectrum of Message Signal');
xlabel('Frequency (Hz)'); ylabel('Magnitude');

subplot(3,2,2);
plot(f_axis,CARR);
title('Spectrum of Carrier Signal');
xlabel('Frequency (Hz)'); ylabel('Magnitude');

subplot(3,2,3);
plot(f_axis,DSBSC);
title('Spectrum of DSB-SC Signal');
xlabel('Frequency (Hz)'); ylabel('Magnitude');

subplot(3,2,4);
plot(f_axis,DSBFC);
title('Spectrum of DSB-FC Signal');
xlabel('Frequency (Hz)'); ylabel('Magnitude');

subplot(3,2,5);
plot(f_axis,DEM_SC);
title('Spectrum of Demodulated Message (DSB-SC)');
xlabel('Frequency (Hz)'); ylabel('Magnitude');

subplot(3,2,6);
plot(f_axis,DEM_FC);
title('Spectrum of Demodulated Message (DSB-FC)');
xlabel('Frequency (Hz)'); ylabel('Magnitude');
