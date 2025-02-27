clear all;

dataPosition = '../../Data/';
filename = 'noOff';

rawData = readmatrix(strcat(dataPosition, filename, '.txt'));

tt = rawData(:, 1);
ch1 = rawData(:, 2);
ch2 = rawData(:, 3);


tt = linspace(0, 1, length(tt));

size(rawData)
size(tt)
size(ch1)
size(ch2)
% plotting

t = tiledlayout(3, 1, "TileSpacing", "tight", "Padding", "compact");
ax1 = nexttile;
%%plot(tt, ch1, 'o')
plot(tt, ch1)
hold on
plot(tt, ch2)
%plot(tt, ch2)
hold off

ax2 = nexttile;
axs = [ax1, ax2];

plot(ch1, ch2, 'o')


ax3 = nexttile;



