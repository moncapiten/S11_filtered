dataPosition = '../../Data/';
filename = ['bodeStableState1'];
%filename = 'AD8031';

mediaposition = '../../Media/';
medianame = strcat('bodeRLC-simulation-Qx2');

% data import and conditioning
rawData = readmatrix(strcat(dataPosition, filename, '.txt'));

ff = rawData(:, 1);
A = rawData(:, 2);
ph = rawData(:, 3);


%params = [w0, gam];

function y = H(params, s)
    num = params(1)^2;
    den = s.^2 + 2*params(2)*params(1)*s + params(1)^2;

    y = num./den;
end

function y = tf(params, f)
    w = 2 * pi * f;
    s = 1i*w;
    y = abs(H(params, s));
end


% setting of fit parameters and function
w0 = 8e3;
gam = 3;

params = [w0, gam];

% fitting
[beta, R3, ~, covbeta] = nlinfit(ff, A, @tf, params);

% plotting
figure
semilogx(ff, 20*log10(A), 'o')
hold on
semilogx(ff, 20*log10(tf(beta, ff)))
hold off

