%Ejercicio1_TP8_Casarotto_Tassara

clc, clear, close all
addpath rtb common smtb

P1 = [0, 0, 0.95];
P2 = [0.4, 0, 0.95];
qq =  [0, -pi/2, -pi/4, 0, pi/4, 0];
dt = 0.1;
t_total = 3;
t = 0:0.1:3;


dh = [
    0      0.45   0.075 -pi/2  0;
    0      0      0.3    0     0;
    0      0      0.075 -pi/2  0;
    0      0.32   0      pi/2  0;
    0      0      0     -pi/2  0;
    0      0.008  0      0     0];

R = SerialLink(dh,'name','Paint Mate 200iA/5L','manufacturer','Fanuc');
R.qlim(1,1:2) = [-120, 120]*pi/180;
R.qlim(2,1:2) = [-120, 120]*pi/180;
R.qlim(3,1:2) = [-120, 120]*pi/180;
R.qlim(4,1:2) = [-120, 120]*pi/180;
R.qlim(5,1:2) = [-120, 120]*pi/180;
R.qlim(6,1:2) = [-120, 120]*pi/180;

T = R.fkine(qq).double;
T0 = [T(1:3,1:3), P1';0,0,0,1]
T1 = [T(1:3,1:3), P2';0,0,0,1]

q0 = R.ikine(T0,'q0',qq);
q1 = R.ikine(T1,'q0',qq);

%T=ctraj(T0,T1,100)
[Q,QD,QDD] = jtraj(q0,q1,100);

figure(1);
R.plot(Q(1, :),'trail', 'r');
for i = 1:length(Q)
    R.animate(Q(i, :));
    view(0,0)
end

figure(2)
subplot(3, 1, 1);
qplot(Q)
title(['Posición']);
subplot(3, 1, 2);
qplot(QD)
title(['Velocidad']);
subplot(3, 1, 3);
qplot(QDD)
title(['Aceleración']);
legend('Articulación 1', 'Articulación 2', 'Articulación 3', 'Articulación 4', 'Articulación 5','Articulación 6');
