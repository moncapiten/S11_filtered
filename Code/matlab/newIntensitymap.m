clearvars;
% Parameters
%Fs = 1000;              % Sampling frequency (Hz)
%T = 1/Fs;               % Sampling period


%filename =  'newData/betterQuantizationStep';   % 0.3 to 0.9 V
%filename = 'newData/heatMap7khz';   % 0.5 to 0.9 V
%filename = 'newData/heatmap4khz_100Takes';   % 0.3 to 0.9 V
%filename = 'newData/4khz100TakesNarrowRange';   % 0.3 to 0.62 V
%filename = 'newData/heatmap4khzWideRange100Takes'; % 0 to 0.7 V
filename = 'newData/heatmap4khz_150Takes_pinpointRange'; % 0.37 to 0.57 V
%filename = 'newData/freqHeatMap_0.458V'; % 200 to 1e4 Hz
%filename = 'newData/freqHeatmap_0.458V_narrowRange' % 3e3 to 6.5e3 Hz
%filename = 'newData/freqHeatMap_300Takes_0.458V_wideRange' % 1e2 to 1e4 Hz - 6 files
%filename = 'newData/freqHeatMap_300Takes_0.458V_narrowRange' % 3e3 to 6.5e3 Hz - 6 files
dataPosition = '../../Data/';
flag_largeFile = true;
filenumber = 3;

if flag_largeFile
    for i = 0:filenumber
        i
        rawData = readmatrix(strcat(dataPosition, filename, '_', num2str(i), '.txt'));
        if i == 0
            temp = rawData;
        else
            temp = [temp; rawData];
        end
    end
    rawData = temp;
else    
    rawData = readmatrix(strcat(dataPosition, filename, '.txt'));
end


%rawData
flag_seeAll = true;
flag_seeSome = false;
which_parameter_value = 0.457;
mag = false;

tt = rawData(:, 1);
ch1 = rawData(:, 2);
ch2 = rawData(:, 3);

%L = 8192;              % Number of points per period
L = 8192*2;              % Number of points per period
T = mean(diff(tt(1:L)));      % Sampling period
Fs = 1/T               % Sampling frequency

numberOfPeriods = length(tt)/L;

parameter_values = linspace(0.37, 0.57, numberOfPeriods);  % Parameter range
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

%    A ==
    if flag_seeAll || (flag_seeSome && A > which_parameter_value - 0.001 && A < which_parameter_value + 0.001)
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
colormap("turbo");
imagesc(parameter_values, Fs*(0:(L/2))/L, intensity_map.');
ylabel('Frequency [Hz]', 'Interpreter', 'latex', 'FontSize', 14);
title('FFT Intensity Map - 0.458V Excitation - Narrow Range', 'Interpreter', 'latex', 'FontSize', 18);
colorbar;
axis xy;  % Ensure the y-axis is correctly oriented
%plot(parameter_values, .5*parameter_values)
colors = ["cyan", "green", "yellow", "red", "magenta"];

hold on;
for i = 1:length(colors)
    if mag
        yline(excitationFrequency/i, 'Color', colors(i));
        if i == 1
            xlabel('Excitation Signal Amplitude [V]', 'Interpreter', 'latex', 'FontSize', 14);
        end
    else
        plot(parameter_values, 1/i * parameter_values, "Color", colors(i));
        if i == 1
            xlabel('Excitation Signal Frequency [Hz]', 'Interpreter', 'latex', 'FontSize', 14);
        end
    end
end
hold off;

ylim([0, 1e4]);  % Limit the y-axis to the first 10 kHz



