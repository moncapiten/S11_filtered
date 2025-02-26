clearvars

m = 1;
gamma = 1;   %prova 1, 0.2 e 4(osserva grafico sx e vedi sottoperiodi e periodi maggiori)
k1 = -2;
k3 = 50;
A = 0.05;
f0 = 1;
omega = 2*pi*f0;

t0 = 0;
durata = 20;
x0 = -1.2; %try -1.4
v0 = 0;


ff = @(t, xv)[xv(2); -gamma*xv(2) - (k1/m)*xv(1) - (k3/m)*xv(1)^3 + (A/m)*sin(omega * t)];

% 2. Soluzione numerica usando ode45
[tt xv] = ode45(ff,t0+[0 durata],[x0 v0]);
xx = xv(:,1);
vv = xv(:,2);

% Plot del risultato
figure(3);
subplot(1,2,1);
plot(tt,[xx vv]);
legend("x","v");
grid on;
ylim([-1 1])
xlabel('tempo [s]');
ylabel('x & v');
subplot(1,2,2);
plot(xx,vv);
grid on;
%xlim([-0.2 0.2])
%ylim([-1 1])
xlabel('x');
ylabel('v');
sgtitle('Forzante non risonante')