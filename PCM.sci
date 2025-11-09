clc
clf();
clear all;
// Define parameters
n = 8;
samples = 30;
t = 0:0.001:3;
mt = 8*sin(2*%pi*t);
ts = 1/samples;
n1 = 0:ts:3;
s = 8*sin(2*%pi*n1);
// Define quantization parameters
L = 2^n;                    // Number of levels
vmax = 8;
vmin = -vmax;
delta = (vmax - vmin)/L;    // Step size
// Define partition and codebook for quantization
partition = vmin+delta:delta:vmax-delta;
codebook = vmin+delta/2:delta:vmax-delta/2;
// Perform quantization (manual implementation)
index = zeros(1, length(s));
quants = zeros(1, length(s));

for i = 1:length(s)
    // Find the quantization index
    if s(i) <= partition(1) then
        index(i) = 0;
        quants(i) = codebook(1);
    elseif s(i) > partition($) then
        index(i) = length(codebook) - 1;
        quants(i) = codebook($);
    else
        for j = 1:length(partition)-1
            if s(i) > partition(j) & s(i) <= partition(j+1) then
                index(i) = j;
                quants(i) = codebook(j+1);
                break;
            end
        end
    end
end
// Convert decimal indices to binary (left-MSB)
code = zeros(length(index), n);

for i = 1:length(index)
    bin_str = dec2bin(index(i), n);
    for j = 1:n
        code(i,j) = strtod(part(bin_str, j));
    end
end

// Parallel to serial conversion
l1 = length(index);
coded = [];
k = 1;

for i = 1:l1
    for j = 1:n
        coded(k) = code(i,j);
        k = k+1;
    end
end
scf(0);
clf();
subplot(2,1,1);
plot(t, mt, 'b-');
title('Message Signal');
xlabel('Time (seconds)');
ylabel('Amplitude (V)');
a = gca();
a.data_bounds = [0, -10; 3, 10];
xgrid;
subplot(2,1,2);
plot2d3('gnn', n1, s, style=2);
title('Sampled Signal');
xlabel('Time (seconds)');
ylabel('Amplitude (V)');
a = gca();
a.data_bounds = [0, -10; 3, 10];
xgrid;

scf(1)
clf();
subplot(2,1,1);
plot2d3('gnn', n1, quants, style=5);
title('Quantized Signal');
xlabel('Time (seconds)');
ylabel('Amplitude (V)');
a = gca();
a.data_bounds = [0, -10; 3, 10];
xgrid;
subplot(2,1,2);
x_coded = 1:length(coded);
plot2d2(x_coded, coded, style=2);
title('Encoded Signal (PCM)');
xlabel('Bit Number');
ylabel('Binary Value');
a = gca();
a.data_bounds = [0, -0.5; length(coded), 1.5];
xgrid;
// Serial to parallel conversion
qunt = matrix(coded, n, length(coded)/n);
// Binary to decimal conversion
index_recovered = zeros(1, size(qunt,2));
for i = 1:size(qunt,2)
    bin_str = '';
    for j = 1:n
        bin_str = bin_str + string(qunt(j,i));
    end
    index_recovered(i) = bin2dec(bin_str);
end
// Recover quantized values from indices
q_recovered = vmin + delta/2 + delta*index_recovered;
scf(2);
clf();
subplot(2,1,1);
plot2d2('gnn', 1:length(coded), coded, style=2);
title('Encoded Signal');
xlabel('Bit Number');
ylabel('Binary Value');
a = gca();
a.data_bounds = [0, -0.5; length(coded), 1.5];
xgrid;
subplot(2,1,2);
plot2d3('gnn', 1:length(q_recovered), q_recovered, style=5);
title('Demodulated Signal');
xlabel('Sample Number');
ylabel('Amplitude (V)');
a = gca();
a.data_bounds = [0, -10; length(q_recovered)+1, 10];
xgrid;
