clear all;

% Data( media) position and name, to retrieve( save) files from( to) the correct position
dataPosition = '../../Data/';
filename = 'opbapa';
%filename = 'AD8031';

%mediaposition = '../../Media/';
%medianame = strcat('bodeRLC-simulation-Qx2');

% data import and conditioning
rawData = readmatrix(strcat(dataPosition, filename, '.txt'))

tt = rawData(:, 1);
ch1 = rawData(:, 2);
ch2 = rawData(:, 3);

% plotting

t = tiledlayout(2, 1);
ax1 = nexttile;
plot(tt, ch1, 'o')
hold on
plot(tt, ch2)
hold off

ax2 = nexttile;
axs = [ax1, ax2];
plot(ch2, ch1);


grid(ax1, 'on');
grid(ax1, 'minor');


plot(ch1, ch2);
