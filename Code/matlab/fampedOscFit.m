dataPosition = '../../Data/';
filename = ['bodeNewNew'];
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
figure
errorbar(ff, A, sig_A, 'o')
hold on
plot(ff, tf(p0, ff), '--', "Color", "magenta")
plot(ff, tf(beta, ff), "Color", "red")
%semilogx(ff, 20*log10(tf(beta, ff)))
hold off

legend('Data', 'p0', 'Fit', 'Location', 'best', 'Location', 'ne')

set(gca, 'XScale','log', 'YScale','log')

grid on;
grid minor;

title("Bode Diagram - Fit", 'Interpreter', 'latex', 'FontSize', 18);

xlabel('f [Hz]', 'Interpreter', 'latex', 'FontSize', 14);
ylabel('Gain [pure]', 'Interpreter', 'latex', 'FontSize', 14);
