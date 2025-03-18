clearvars

data1 = readmatrix("../../Data/newData/superperiodi_10.txt");

tt = data1(:,1);
ch1 = data1(:,2);
ch2 = data1(:,3);

t = tiledlayout(3, 1);

f_t = nexttile();

plot(tt,ch1);
hold on;
plot(tt,ch2);
hold off;
grid on;
grid minor;

title('Ch1 e Ch2')
xlabel('t [s]')
ylabel('V [V]')

f_v = nexttile();

plot(ch1,ch2);
grid on;
grid minor;

title('Ch1 vs Ch2')
xlabel('Ch1 [V]')
ylabel('Ch2 [V]')

f_f = nexttile();

dt = mean( diff( tt));
fs = 1/dt
N = length(tt);
df = fs/N

fv = (0:N/2)*df;

fch2 = abs(fft(ch2));
fch2 = fch2(1:N/2+1);

fch1 = abs(fft(ch1));
fch1 = fch1(1:N/2+1);

plot(fv, fch1, Color = "blue");
hold on;
plot(fv, fch2, Color = "magenta");
hold off;
grid on;
grid minor;

xlim([0, 5e3])

xlabel('Frequency [Hz]', 'Interpreter', 'latex', 'FontSize', 14)
ylabel('Amplitude [V/Hz]', 'Interpreter', 'latex', 'FontSize', 14)
title('Densità spettrale di Ch2')


%{


n1=length(data1)*2;
f1=400;

ydata1=linspace(0,f1*2,n1/2+1);
xdata1=linspace(0.05,1,40);

figure(1)
sgtitle('Densità spettrale di Vc al variare di A')


subplot(1,1,1)
imagesc(xdata1,ydata1,data1);
colorbar ;
clim([0;10]);

xlabel('Ampiezza [V]');
ylabel('f [Hz]')
yline(f1)
yline(f1/2)
yline(f1/3)
yline(f1/4)
yline(f1/5)


subtitle('Forzante a 400Hz')

%exportgraphics(gcf,'Colormap2.pdf','ContentType','vector')

%}
