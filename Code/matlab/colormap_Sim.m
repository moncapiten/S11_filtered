clearvars

data1 = readmatrix("../../Data/Sim/Simulation.txt");
data2 = readmatrix("../../Data/Sim/newSimulation.txt");
data3 = readmatrix("../../Data/Sim/evenNewerSimulation.txt");
data4 = readmatrix("../../Data/Sim/stillNewer.txt");

n1=length(data1)*2;
f1=1;

n2 = length(data2)*2;
%n2 = 37500;
f2 = 0.5;

n3 = length(data3)*2;
f3 = 1;

n4 = length(data4)*2;
f4 = 0.1;

ydata1=linspace(0,f1*2,n1/2+1);
xdata1=linspace(0.05,1,40);

figure(1)
sgtitle('Densità spettrale di Vc al variare di A')
subplot(1,5,1)
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




ydata2=linspace(0,f2*2,n2/2+1);
xdata2=linspace(0.05,1,40);

subplot(1,5,2)
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

subtitle('Forzante a 4kHz')



ydata3=linspace(0,f3*2,n3/2+1);
xdata3=linspace(0.05,1,40);

subplot(1,5,3)
imagesc(xdata3,ydata3,data3);
colorbar ;
clim([0;10]);

xlabel('Ampiezza [V]');
ylabel('f [Hz]')
yline(f3)
yline(f3/2)
yline(f3/3)
yline(f3/4)
yline(f3/5)

subtitle('Forzante a 4kHz')



ydata4=linspace(0,f4*2,n4/2+1);
xdata4=linspace(0.05,1,40);

subplot(1,5,4)
imagesc(xdata4,ydata4,data4);
colorbar ;
clim([0;10]);

xlabel('Ampiezza [V]');
ylabel('f [Hz]')
yline(f4)
yline(f4/2)
yline(f4/3)
yline(f4/4)
yline(f4/5)

subtitle('Forzante a 4kHz')

%exportgraphics(gcf,'Colormap2.pdf','ContentType','vector')

