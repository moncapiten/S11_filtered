clearvars

m = 1;
gamma = 1;   %prova 1, 0.2 e 4(osserva grafico sx e vedi sottoperiodi e periodi maggiori)
k1 = 10;
k3 = [0, 10, 80];
%k3 = [0, 2, 10];
A = 0.05;
f0 = 1;
omega = 2*pi*f0;

t0 = 0;
durata = 20;
x0 = -1.2; %try -1.4
v0 = 0;

times = linspace(t0, durata, 1e5);



for i = 1:3
    ff = @(t, xv)[xv(2); -gamma*xv(2) - (k1/m)*xv(1) - (k3(i)/m)*xv(1)^3 + (A/m)*sin(omega * t)];
    [tt xv] = ode45(ff,times,[x0 v0]);
    xx = xv(:,1);
    vv = xv(:,2);
    plot(xx, vv);
    if i == 1
        hold on
    end
    i
end

legendentries = compose('k3 = %d', k3);
legend(legendentries)

grid on;
grid minor;

xlabel('x [u.a.]');
ylabel('v [u.a.]');

title('Distorsioni non lineari - k1 = 10');