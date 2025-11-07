// Frequency Modulation and Demodulation in Scilab

// === Define Parameters ===
A_c = 1;          // Carrier amplitude
A_m = 0.7;        // Message amplitude
f_c = 175;        // Carrier frequency (Hz)
f_m = 8;          // Message frequency (Hz)
k_f = 800;        // Frequency sensitivity (Hz/V)
f_s = 10000;      // Sampling frequency (Hz)

// === Time and Frequency Axis ===
t_axis = 0:1/f_s:1;        // 1-second duration
N = length(t_axis);
f_axis = ([-N/2 : N/2 - 1] * f_s) / N;

// === Modulation Index ===
m_f = (k_f * A_m) / f_m;
disp("FM modulation index: " + string(m_f));

// === Message Signal ===
m = A_m * cos(2 * %pi * f_m * t_axis);

// === Carrier Signal ===
c = A_c * cos(2 * %pi * f_c * t_axis);

// === Integral of Message Signal ===
integral_m = (A_m / (2 * %pi * f_m)) * sin(2 * %pi * f_m * t_axis);

// === FM Modulated Signal ===
s_f_m = A_c * cos(2 * %pi * f_c * t_axis + k_f * integral_m);

// === Frequency Spectrum of FM Signal ===
fm_fft = fftshift(abs(fft(s_f_m)) / N);

// === Plotting ===
clf();
subplot(4,1,1);
plot(t_axis, m);
title("Message Signal m(t)");

subplot(4,1,2);
plot(t_axis, c);
title("Carrier Signal c(t)");

subplot(4,1,3);
plot(t_axis, s_f_m);
title("FM Modulated Signal");

subplot(4,1,4);
plot(f_axis, fm_fft);
title("Frequency Spectrum of FM Signal");
xlabel("Frequency (Hz)");
ylabel("Magnitude");

// === Simple FM Demodulation (Differentiation + Envelope Detection) ===
dfm = diff(s_f_m);                       // Differentiate
env = abs(hilbert(dfm));                 // Envelope detection
env = env - mean(env);                   // Remove DC

figure();
plot(t_axis(1:$-1), env);
title("Demodulated Signal (Approximation)");
xlabel("Time (s)");
ylabel("Amplitude");
