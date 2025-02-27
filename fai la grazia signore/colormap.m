
data1=readmatrix("es11_fft6rz.txt");
data2 = readmatrix("es11_fft7rz.txt");

n1=2400;
f1=6000;

n2 = 2800;
f2 = 7000;

ydata1=linspace(0,f1*2,n1/2+1);
xdata1=linspace(0.05,1,40);

figure(1)
sgtitle('Densità spettrale di Vc al variare di A')
subplot(1,2,1)
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


subtitle('Forzante a 6kHz')

ydata2=linspace(0,f2*2,n2/2+1);
xdata2=linspace(0.05,1,40);

subplot(1,2,2)
imagesc(xdata2,ydata2,data2);
colorbar ;
clim([0;10]);

xlabel('Ampiezza [V]');
ylabel('f [Hz]')
yline(f2)
yline(f2/2)
yline(f2/3)
yline(f2/4)
yline(f2/5)

subtitle('Forzante a 7kHz')

exportgraphics(gcf,'Colormap2.pdf','ContentType','vector')