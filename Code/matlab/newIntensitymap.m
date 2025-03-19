clearvars;
% Parameters
%Fs = 1000;              % Sampling frequency (Hz)
%T = 1/Fs;               % Sampling period


%filename =  'newData/betterQuantizationStep';   % 0.3 to 0.9 V
%filename = 'newData/heatMap7khz';   % 0.5 to 0.9 V
filename = 'newData/heatmap4khz_100Takes';   % 0.3 to 0.9 V
%filename = 'newData/4khz100TakesNarrowRange';   % 0.3 to 0.62 V
dataPosition = '../../Data/';
rawData = readmatrix(strcat(dataPosition, filename, '.txt'));

flag_seeAll = false;

tt = rawData(:, 1);
ch1 = rawData(:, 2);
ch2 = rawData(:, 3);

%L = 8192;              % Number of points per period
L = 8192*2;              % Number of points per period
T = mean(diff(tt(1:L)));      % Sampling period
Fs = 1/T               % Sampling frequency

numberOfPeriods = length(tt)/L;

parameter_values = linspace(0.3, 0.62, numberOfPeriods);  % Parameter range
excitationFrequency = 4000;  % Excitation frequency (Hz)

% Initialize the intensity map
intensity_map = zeros(length(parameter_values), L/2+1);

n = 0; % counter for the points per period
% Loop over parameter values
for i = 1:length(tt)/L
    A = parameter_values(i);  % Current parameter value
%    signal = rawData(n+1:n+L, 1);
    time = tt((i-1)*L+1:i*L);
    signal = ch2((i-1)*L+1:i*L);

    % Compute the FFT of the signal
    Y = fft(signal);
    
    % Compute the magnitude of the FFT
    P2 = abs(Y);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    
    % Store the FFT magnitude in the intensity map
    intensity_map(i, :) = P1;

    if flag_seeAll
        figure;
        t = tiledlayout(2, 1, "TileSpacing", "tight", "Padding", "compact");
        ax1 = nexttile;
        plot(time, signal);
        hold on;
        plot(time, ch1((i-1)*L+1:i*L));
        hold off;
        grid on;
        grid minor;
        xlabel('Time [s]', 'Interpreter', 'latex', 'FontSize', 14);
        ylabel('Voltage [V]', 'Interpreter', 'latex', 'FontSize', 14);
        legend({'Output Signal', 'Excitation Signal'}, 'Interpreter', 'latex', 'FontSize', 14);
        title('Signal and Reference Signal against Time', 'Interpreter', 'latex', 'FontSize', 16);

        ax2 = nexttile;
        plot(Fs*(0:(L/2))/L, P1);
        xlim(ax2, [0, 5000]);
        grid on;
        grid minor;
        xlabel('Frequency [Hz]', 'Interpreter', 'latex', 'FontSize', 14);
        ylabel('Magnitude [V/Hz]', 'Interpreter', 'latex', 'FontSize', 14);
        legend('Output Signal - fft', 'Interpreter', 'latex', 'FontSize', 14);
        title('Single-Sided Amplitude Spectrum of Signal', 'Interpreter', 'latex', 'FontSize', 14);


        title(t, ['Signal for Parameter Value: ', num2str(A)], 'Interpreter', 'latex', 'FontSize', 18);
        pause(0.1); % Pause to inspect each plot
    end


    n = n + L;
end
%{
L = 8192;              % Number of points per period
for i = 1:length(tt)/L
    plot(tt((i-1)*L+1:i*L), ch1((i-1)*L+1:i*L));
    hold on
    plot(tt((i-1)*L+1:i*L), ch2((i-1)*L+1:i*L));
    hold off
    pause(0.1);
end
%}



% Plot the intensity map
figure;
imagesc(parameter_values, Fs*(0:(L/2))/L, intensity_map.');
xlabel('Excitation Signal Amplitude [V]', 'Interpreter', 'latex', 'FontSize', 14);
ylabel('Frequency [Hz]', 'Interpreter', 'latex', 'FontSize', 14);
title('FFT Intensity Map', 'Interpreter', 'latex', 'FontSize', 18);
colorbar;
axis xy;  % Ensure the y-axis is correctly oriented
yline(excitationFrequency);
yline(excitationFrequency/2);
yline(excitationFrequency/3);
yline(excitationFrequency/4);
yline(excitationFrequency/5);
ylim([0, 1e4]);  % Limit the y-axis to the first 10 kHz

