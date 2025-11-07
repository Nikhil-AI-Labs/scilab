clc;
clf();
A_m = 2;
f_m = 4;
f_s = 25*f_m;
n_bits = 5;
t = 0:1/f_s:2;

msg = A_m * sin(2 * %pi * f_m * t);

// Quantization with proper levels
x = msg + A_m;
Q = round((x / (2*A_m)) * (2^n_bits - 1));

// Encoding with fixed bit width
encode = dec2bin(Q, n_bits);

// Decoding with proper scaling
decode = bin2dec(encode);
decode_signal = (decode / (2^n_bits - 1)) * (2*A_m);
recsig = decode_signal - A_m;

// Low pass filter for demodulation
h_lpf = ones(1, 5) / 5;
demod = convol(recsig, h_lpf);
demod = demod(1:length(t));

// Plotting
subplot(2,1,1);
plot(t, msg, 'b-', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Amplitude');
title('Message Signal');
xgrid();

subplot(2,1,2);
plot(t, msg, 'b:', 'LineWidth', 1);
plot(t, decode_signal - A_m, 'ro', 'MarkerSize', 5);
xlabel('Time (s)');
ylabel('Amplitude');
title('Sampled and Quantized Signal');
xgrid();
legend(['Original'; 'Quantized']);
h = gca();
h.data_bounds = [0,-3;2,3];

figure();

subplot(2,1,1);
plot(t, recsig, 'b-', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Amplitude');
title('Decoded Signal (Zero Order Hold)');
xgrid();
h = gca();
h.data_bounds = [0,-3;2,3];

subplot(2,1,2);
plot(t, msg, 'b-', 'LineWidth', 2);
plot(t, demod, 'r--', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Amplitude');
title('Demodulation: Original vs Reconstructed');
xgrid();
legend(['Original'; 'Demodulated']);
h = gca();
h.data_bounds = [0,-3;2,3];
