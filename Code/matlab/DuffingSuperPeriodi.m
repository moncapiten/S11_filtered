%{
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
subplot(1,2,1);
plot(tt,[xx vv]);
legend("x","v");
grid on;
ylim([-1 1])
xlabel('tempo [s]');
ylabel('x,v [u.a.]');
subplot(1,2,2);
plot(xx,vv);
grid on;
grid minor;
xlabel('x [u.a.]');
ylabel('v [u.a.]');
sgtitle('Forzante non risonante')
%}




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
x0 = [-1.2, -1.4]; %try -1.4
v0 = [0, 0];

initial_conditions = [x0 v0; x0+0.2 v0];


t = tiledlayout(2,2, "TileSpacing", "tight", "Padding", "compact");
ax1 = nexttile([1, 1]);
ax3 = nexttile([2, 1]);
ax2 = nexttile([1, 1]);

axs = [ax1, ax2, ax3];

for i = 1:2

    ff = @(t, xv)[xv(2); -gamma*xv(2) - (k1/m)*xv(1) - (k3/m)*xv(1)^3 + (A/m)*sin(omega * t)];

    % 2. Soluzione numerica usando ode45
    [tt xv] = ode45(ff,t0+[0 durata],[x0(i), v0(i)]);

    plot(ax1, tt, xv(:,1));
    plot(ax2, tt, xv(:,2));
    plot(ax3, xv(:,1), xv(:,2));

    if i == 1
        hold(ax1, "on");
        hold(ax2, "on");
        hold(ax3, "on");
    end
end


% Plot del risultato
%plot(xx,vv);
grid(axs, "on");
grid(axs, "minor");



title('Super-Periodi')

xlabel(ax1, 'x [u.a.]');
ylabel(ax1, 't [s]');

xlabel(ax2, 'v [u.a.]');
ylabel(ax2, 't [s]');

xlabel(ax3, 'x [u.a.]');
ylabel(ax3, 'v [u.a.]');
