clc;
close all;
clear all;
cycles=3; //Number of cycles
original_frequency=2000; //Frequency of the signal
t=[0:1/1000000:cycles/original_frequency]; //Here 1000000 is the 'Scilab' Sampling frequency
original_signal=1*sin(2*%pi*original_frequency*t);//Signal pk-pk is 2 units

//## Encoding and Sampling
sam_freq=20000; //sampling Frequency
sam_time=1/sam_freq; //Sampling Time period
n=[0:1/sam_freq:cycles/original_frequency];
num_samples=length(n);
sam_signal=sin(2*%pi*original_frequency*n);

//N is num of bits used for quantizing
N=3;
num_levels=2^N; //using N bits we get 2^N levels
width=2/(num_levels-1);
levels=[-1:width:1];
boundaries=[-1+(width/2):width:1-(width/2)];
codes=[0:num_levels-1];
quant=zeros(1,num_samples);
signal_after_coding=zeros(1,num_samples);

//## Quantization and coding 
for i=1:num_samples
    index=1;
    if(sam_signal(i)>=boundaries($))
        signal_after_coding(i)=codes($);
        quant(i)=levels($);
    else
        for j=1:length(boundaries)
            boundary=boundaries(j);
            if(sam_signal(i)<=boundary)
                signal_after_coding(i)=codes(index);
                quant(i)=levels(index);
                break;
            end
            index=index+1;
        end
    end
end

//Signal after coding
signal_after_coding_bin=dec2bin(signal_after_coding);
disp('Signal after coding (binary):');
disp(signal_after_coding_bin);

//## PCM Decoder
signal_after_decoding=bin2dec(signal_after_coding_bin);
xa=zeros(1,num_samples);
x=zeros(1,num_samples);
for i = 1:num_samples
    x(i)=levels(signal_after_decoding(i)+1);
end
x=x';
t_samp=sam_time*(1:num_samples);
ts = [0:1/1000000:cycles/original_frequency];

// Sinc interpolation
y=zeros(length(ts),1);
for i=1:length(ts)
    for j=1:num_samples
        y(i) = y(i) + x(j)*sinc((ts(i) - t_samp(j))/sam_time);
    end
end

//========== COMPLETE PCM VISUALIZATION ==========//

scf(0);
// Figure 2: Original Signal with Sampling Points
subplot(2,1,1);
plot(t, original_signal, 'b-');
a=gca();
plot2d3(n, sam_signal, style=5);
plot(n, sam_signal, 'ro');
title('Step 2: Sampling of Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');
legend(['Original Signal'; 'Sampled Points']);
xgrid();
// Figure 4: Quantized Signal
subplot(2,1,2);
plot2d3(n, quant, style=5);
a=gca();
a.auto_clear = "off";
plot(n, quant, 'rs');
// Draw quantization levels
for lev=levels
    plot([min(n), max(n)], [lev, lev], 'k--');
end
title('Step 4: Quantized Signal');
xlabel('Time (s)');
ylabel('Amplitude (Quantized)');
xgrid();
a.auto_clear = "on";

// Figure 5: Sampled vs Quantized Comparison
scf(1);
subplot(2,1,1);
plot2d3(n, sam_signal, style=2);
a=gca();
a.auto_clear = "off";
plot(n, sam_signal, 'bo');
plot2d3(n, quant, style=5);
plot(n, quant, 'rs');
title('Step 5: Sampled vs Quantized Signal');
xlabel('Time (s)');
ylabel('Amplitude');
legend(['Sampled Signal'; ''; 'Quantized Signal']);
xgrid();
a.auto_clear = "on";

// Figure 6: Encoded Signal (Digital Codes)
subplot(2,1,2);
plot2d3(n, signal_after_coding, style=3);
a=gca();
a.auto_clear = "off";
plot(n, signal_after_coding, 'md');
title('Step 6: Encoded Signal (Digital Codes)');
xlabel('Time (s)');
ylabel('Code Value');
xgrid();
a.auto_clear = "on";


// Figure 8: Reconstructed Signal (After Interpolation)
scf(2);
subplot(2,1,1);
plot(ts, y, 'r-');
a=gca();
a.auto_clear = "off";
plot2d3(n, x, style=6);
plot(n, x, 'go');
title('Step 8: Reconstructed Signal (Sinc Interpolation)');
xlabel('Time (s)');
ylabel('Amplitude');
legend(['Reconstructed Signal'; 'Decoded Samples']);
xgrid();
a.auto_clear = "on";

// Figure 9: Original vs Reconstructed Signal Comparison
subplot(2,1,2);
plot(t, original_signal, 'b-');
a=gca();
a.auto_clear = "off";
plot(ts, y, 'r--');
title('Step 9: Original vs Reconstructed Signal');
xlabel('Time (s)');
ylabel('Amplitude');
legend(['Original Signal'; 'Reconstructed Signal']);
xgrid();
a.auto_clear = "on";
