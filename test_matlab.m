%% 注：需打开 matlab 才能运行此脚本

% Fs is the sampling frequency, T is the sampling period
Fs = 1000;            
T = 1/Fs;             
% L is the length of the signal
L = 1500;             
% t is the time vector
t = (0:L-1)*T;        

% Create a signal containing a 50 Hz sinusoid with an amplitude of 0.7
% and a 120 Hz sinusoid with an amplitude of 1.
S = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);

% Corrupt the signal with zero-mean random noise
y = S + 2*randn(size(t));

% Compute the Fourier transform of the original signal S
Y_S = fft(S);
% Compute the Fourier transform of the noisy signal y
Y_y = fft(y);

% Compute the single-sided spectrum for both signals
P2_S = abs(Y_S/L);
P1_S = P2_S(1:L/2+1);
P1_S(2:end-1) = 2*P1_S(2:end-1);

P2_y = abs(Y_y/L);
P1_y = P2_y(1:L/2+1);

P1_y(2:end-1) = 2*P1_y(2:end-1);

% Define the frequency domain for plotting

f = Fs*(0:(L/2))/L;

% Plot the spectra
plot(f,P1_S,'b-') 
hold on
plot(f,P1_y,'r-') 
hold off
title('Single-Sided Amplitude Spectrum Comparison')
xlabel('f (Hz)')
ylabel('|P1(f)|')
legend('Original Signal', 'Noisy Signal')

%% 
% Verify Parseval's theorem for the noisy signal y 
% Energy in the time domain
energy_time = sum(y.^2);

% Energy in the frequency domain from single-sided spectrum P1_y
% Note: The single-sided spectrum P1_y is scaled amplitude. To get power, we need to square it.
% The DC component (first element) and Nyquist component (last element, if L is even) are not doubled.
% All other components are doubled. We need to reverse this to calculate total energy.
% The sum of squared amplitudes from the single-sided spectrum is sum((P1_y/sqrt(2)).^2) for non-DC/Nyquist.
% A simpler way is to reconstruct the two-sided spectrum's power from the single-sided one.
energy_freq = sum(P1_y(1).^2) + sum(P1_y(2:end-1).^2)/2;
if mod(L,2) == 0
    % If L is even, the last element of P1_y is the Nyquist frequency component
    energy_freq = energy_freq + P1_y(end).^2;
else
    % If L is odd, the last element is just another frequency component
    energy_freq = energy_freq + sum(P1_y(end).^2)/2;
end
energy_freq = energy_freq * L ;


% Display the results
fprintf('Energy in time domain: %f\n', energy_time);
fprintf('Energy in frequency domain (from P1_y): %f\n', energy_freq);
fprintf('Difference: %e\n', abs(energy_time - energy_freq));

%% 