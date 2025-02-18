%Ejercicio1_TP8_Casarotto_Tassara

clc, clear, close all
addpath rtb common smtb

q0 = [0, -pi/2, 0, 0, 0];
q1 = [-pi/3, pi/10, -pi/5, pi/2, pi/4];
dt = 0.1;
t_total = 3;
t = 0:0.1:3;

dh = [
       0    0.450    0.075    pi/2    0;
       0	0.000 	 0.300	     0	  0;
       0	0.000	 0.075	  pi/2	  0;
       0	0.225	 0.000	 -pi/2 	  0;
       0    0.000    0.000    pi/2    0];

R = SerialLink(dh,'name','Paint Mate 200iA/5L','manufacturer','Fanuc');
R.qlim(1,1:2) = [-120, 120]*pi/180;
R.qlim(2,1:2) = [-120, 120]*pi/180;
R.qlim(3,1:2) = [-120, 120]*pi/180;
R.qlim(4,1:2) = [-120, 120]*pi/180;
R.qlim(5,1:2) = [-120, 120]*pi/180;

[Q,QD,QDD] = jtraj(q0,q1,t);

figure(1)
% subplot(3, 1, 1);
% qplot(t,Q)
% title(['Posición']);
% subplot(3, 1, 2);
% qplot(t,QD)
% title(['Velocidad']);
% subplot(3, 1, 3);
% qplot(t,QDD)
% title(['Aceleración']);

for i = 1:5
    subplot(3, 1, 1);
    plot(t, Q(:, i));
    title(['Posición']);
    hold on;

    subplot(3, 1, 2);
    plot(t, QD(:, i));
    title(['Velocidad']);
    hold on;
    
    subplot(3, 1, 3);
    plot(t, QDD(:, i));
    title(['Aceleración']);
    hold on;
end

legend('Articulación 1', 'Articulación 2', 'Articulación 3', 'Articulación 4', 'Articulación 5');

figure(2);
R.plot(Q(1, :));
for i = 1:length(Q)
    R.animate(Q(i, :));
end

