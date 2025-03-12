clearvars

m = 1;
gamma = 2;   %prova 1, 0.2 e 4(osserva grafico sx e vedi sottoperiodi e periodi maggiori)
k1 = -20;
k3 = 80;
A = 3;
f0 = 3;
%f0 = logspace(-1, 2, 10);
omega = 2*pi*f0;

t0 = 0;
durata = 70;
x0 = [-1]; %try -1.4
v0 = [0];




t = tiledlayout(2,2, "TileSpacing", "tight", "Padding", "compact");
ax1 = nexttile([1, 1]);
ax3 = nexttile([2, 1]);
ax2 = nexttile([1, 1]);

axs = [ax1, ax2, ax3];

for i = 1:size(omega(:))

    i

    ff = @(t, xv)[xv(2); -gamma*xv(2) - (k1/m)*xv(1) - (k3/m)*xv(1)^3 + (A/m)*sin(omega(i) * t)];

    % 2. Soluzione numerica usando ode45
    [tt, xv] = ode45(ff,t0+[0 durata],[x0(1), v0(1)]);

    plot(ax1, tt, xv(:,1));
    plot(ax2, tt, xv(:,2));
    plot(ax3, xv(:,1), xv(:,2));

    if i == 1
        hold(ax1, "on");
        hold(ax2, "on");
        hold(ax3, "on");
    end
end

%plot(ax1, tt, (A/m)*sin(omega * tt), "Color", 'magenta')

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


%dlmwrite('../../Data/Simulation.txt', [tt, xv(:,1), xv(:,2)], 'delimiter', '\t', 'precision', 9);

% Create a button to save the data
btn = uicontrol('Style', 'pushbutton', 'String', 'Save Data', ...
    'Position', [20 20 100 30], ...
    'Callback', @(src, event) writematrix([tt, xv(:,1), xv(:,2)], '../../Data/Sim/stillNewer.txt', 'Delimiter', 'tab'));

%writematrix([tt, xv(:,1), xv(:,2)], '../../Data/Simulation.txt', 'Delimiter', 'tab');

