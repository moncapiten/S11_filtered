clearvars

m = 1;
gamma = 1;   %prova 1, 0.2 e 4(osserva grafico sx e vedi sottoperiodi e periodi maggiori)
k1 = 10;
k3 = [0, 10, 80];
%k3 = [0, 2, 10];
A = 1;
f0 = 100;
omega = 2*pi*f0;

t0 = 0;
durata = 15;
x0 = -0.5; %try -1.4
v0 = 0;

times = linspace(t0, durata, 1e5);


t = tiledlayout(2,2, "TileSpacing", "tight", "Padding", "compact");
ax1 = nexttile([1, 1]);
ax3 = nexttile([2, 1]);
ax2 = nexttile([1, 1]);

axs = [ax1, ax2, ax3];

for i = 2:2

    ff = @(t, xv)[xv(2); -gamma*xv(2) - (k1/m)*xv(1) - (k3(2)/m)*xv(1)^3 + (A/m)*sin(omega * t)];
    [tt xv] = ode45(ff,times,[x0 v0]);

    plot(ax1, tt, xv(:,1));
    plot(ax2, tt, xv(:,2));
    plot(ax3, xv(:,1), xv(:,2));

    if i == 1
        hold(ax1, "on");
        hold(ax2, "on");
        hold(ax3, "on");
    end
end


title(t, ['NLD - Super-Period - f = ', num2str(f0, '%.2f'), ' Hz'], 'Interpreter', 'latex', 'FontSize', 18);
%title(t, 'NLD - Super-Period - f = ${f0}$', 'Interpreter', 'latex')

grid(axs, "on");
grid(axs, "minor");

ylabel(ax1, 'x [u.a.]', 'Interpreter', 'latex', 'FontSize', 14);
xlabel(ax1, 't [s]', 'Interpreter', 'latex', 'FontSize', 14);

ylabel(ax2, 'v [u.a.]', 'Interpreter', 'latex', 'FontSize', 14);
xlabel(ax2, 't [s]', 'Interpreter', 'latex', 'FontSize', 14);

ylabel(ax3, 'v [u.a.]', 'Interpreter', 'latex', 'FontSize', 14);
xlabel(ax3, 'x [u.a.]', 'Interpreter', 'latex', 'FontSize', 14);


linkaxes([ax1, ax2], 'x');
%linkaxes([ax1, ax2], 'y');

%ylim(ax1, [-1, 1]);