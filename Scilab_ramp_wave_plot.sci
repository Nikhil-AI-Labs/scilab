 //t_period = 1/freq
 // Parameters
 clc
 clear
 clf
 f = 5000;
 T = 1/f;
 A = 5;
 dt = 1e-7;
  t = 0:dt:5*T;
 // Frequency in Hz
 // Period in seconds
 // Peak-to-peak amplitude in Volts
 // Time step (100 ns)
 // Time vector for 3 cycles
 ramp = modulo(t, T) * (A / T)- A/2;
 // Plotting
 scf(0);
 plot(t*1000, ramp); // Time in milliseconds
 xlabel("Time (ms)");
 ylabel("Amplitude (mV)");
 title("Ramp Wave- 5 kHz, 5 Vpp");
 xtitle("Ramp Wave", "Time (ms)", "Amplitude (mV)");
 grid();
