dataPosition = '../../Data/';
filename = ['bodeStableState99'];
%filename = 'AD8031';

mediaposition = '../../Media/';
medianame = strcat('bodeRLC-simulation-Qx2');

% data import and conditioning
rawData = readmatrix(strcat(dataPosition, filename, '.txt'));

ff = rawData(:, 1);
A = rawData(:, 2);
sig_A = 0.015 * A;
ph = rawData(:, 3);


%params = [w0, gam];

function y = H(params, s)
    num = params(1)^2;
    den = s.^2 + 2*params(2)*params(1)*s + params(1)^2;

    y = num./den;% + params(3);
end

function y = tf(params, f)
    w = 2 * pi * f;
    s = 1i*w;
    y = abs(H(params, s));
end


% setting of fit parameters and function
w0 = 1e4;
gam = .5;

p0 = [w0, gam];

% fitting
[beta, R3, ~, covbeta] = nlinfit(ff, A, @tf, p0);

% plotting
t = tiledlayout(2,2, "TileSpacing", "tight", "Padding", "compact");

ax1 = nexttile([1, 2]);
errorbar(ff, A, sig_A, 'o')
hold on
plot(ff, tf(p0, ff), '--', "Color", "magenta")
plot(ff, tf(beta, ff), "Color", "red")
%semilogx(ff, 20*log10(tf(beta, ff)))
hold off

ax2 = nexttile([1, 2]);
axs = [ax1, ax2];
plot(ff, repelem(0, length(ff)), '--', "Color", "black");
hold on
errorbar(ff, R3, sig_A, 'o')



legend(ax1, 'Data', 'p0', 'Fit', 'Location', 'best', 'Location', 'ne')

set(ax1, 'XScale','log', 'YScale','log')
set(ax2, 'XScale','log')


grid(axs, 'on');
grid(axs, 'minor');

title(t, "Bode Diagram - Fit 99%", 'Interpreter', 'latex', 'FontSize', 18);

linkaxes([ax1, ax2], 'x');
xlabel(ax2, 'f [Hz]', 'Interpreter', 'latex', 'FontSize', 14);
ylabel(ax1, 'Gain [pure]', 'Interpreter', 'latex', 'FontSize', 14);
ylabel(ax2, 'Residuals [pure]', 'Interpreter', 'latex', 'FontSize', 14);
