clear all;

% Data( media) position and name, to retrieve( save) files from( to) the correct position
dataPosition = '../../Data/';
filename = 'newData/newNoOff';
%filename = 'AD8031';

everyPlot = false;

%mediaposition = '../../Media/';
%medianame = strcat('bodeRLC-simulation-Qx2');

% data import and conditioning
rawData = readmatrix(strcat(dataPosition, filename, '.txt'));

tt = rawData(:, 1);
ch1 = rawData(:, 2);
ch2 = rawData(:, 3);


if everyPlot
    L = 8192*2;              % Number of points per period
    for i = 1:length(tt)/L
        plot(tt((i-1)*L+1:i*L), ch1((i-1)*L+1:i*L));
        hold on
        plot(tt((i-1)*L+1:i*L), ch2((i-1)*L+1:i*L));
        hold off
        pause(0.1);
    end
end






% plotting

t = tiledlayout(2, 1, "TileSpacing", "tight", "Padding", "compact");
ax1 = nexttile;
plot(tt, ch1, 'o')
hold on
plot(tt, ch2)
hold off

ax2 = nexttile;
axs = [ax1, ax2];
plot(ch1, ch2);
hold off


grid(axs, 'on');
grid(axs, 'minor');


legend(ax1, {'V+', 'Vc'}, 'Interpreter', 'latex', 'FontSize', 14);

title(t, 'Vc - V+ curve', 'Interpreter', 'latex', 'FontSize', 18);

ylabel(ax1, 'Voltage [V]', 'Interpreter', 'latex', 'FontSize', 14);
xlabel(ax1, 't [s]', 'Interpreter', 'latex', 'FontSize', 14);

ylabel(ax2, 'V+ [V]', 'Interpreter', 'latex', 'FontSize', 14);
xlabel(ax2, 'Vc [V]', 'Interpreter', 'latex', 'FontSize', 14);

%grid(ax2, 'on');
%grid(ax2, 'minor');


