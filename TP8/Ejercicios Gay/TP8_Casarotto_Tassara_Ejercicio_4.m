%Ejercicio 4 Cassaroto Tassara

clc, clear, close all
addpath rtb common smtb

P1 = [0, 0, 0.95];
P2 = [0.4, 0, 0.95];
qq =  [0, -pi/2, -pi/4, 0, pi/4, 0];
dt = 0.01;
t_total = 3;
t = 0:dt:1;
M = length(t);


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

%====Calculo con jtraj====
T = R.fkine(qq).double;
T0 = [T(1:3,1:3), P1';0,0,0,1];
T1 = [T(1:3,1:3), P2';0,0,0,1];

q0 = R.ikine(T0,'q0',qq);
q1 = R.ikine(T1,'q0',qq);

[Q,QD,QDD] = jtraj(q0,q1,t);

%====Calculo con ctraj====

TC = ctraj(T0,T1,M);
QQ = R.ikine(TC,'q0',qq);
QQD = diff(QQ)/dt;
QQDD = diff(QQ,2)/(dt^2);%,2)/dt;

%===Posiciones XYZ===

for i=1:length(Q)
    Tjtraj = R.fkine(Q(i,:)).double;
    xj(i) = Tjtraj(1,4);
    yj(i) = Tjtraj(2,4);
    zj(i) = Tjtraj(3,4);
end

for i=1:length(QQ)
    xc(i) = TC(1,4,i);
    yc(i) = TC(2,4,i);
    zc(i) = TC(3,4,i);
end

%==================Graficos====================

%----Graficos de posiciones cartesianas----
figure(1)
subplot(3, 2, 1);
plot(t, xj);
title('Coordenadas con jtraj');
xlabel('Tiempo');
ylabel('xj');

subplot(3, 2, 3);
plot(t, yj);
xlabel('Tiempo');
ylabel('yj');

subplot(3, 2, 5);
plot(t, zj);
xlabel('Tiempo');
ylabel('zt');

subplot(3, 2, 2);
plot(t, xc);
title('Coordenadas con ctraj');
xlabel('Tiempo');
ylabel('xc');

subplot(3, 2, 4);
plot(t, yc);
xlabel('Tiempo');
ylabel('yc');

subplot(3, 2, 6);
plot(t, zc);
xlabel('Tiempo');
ylabel('zc');

%------Grafico de z(x)------

figure(2)
subplot(1, 2, 1);
plot(xj, zj);
title('zj(xj)');
xlabel('xj');
ylabel('zj');

subplot(1, 2, 2);
plot(xc, zc);
title('zc(xc)');
xlabel('xc');
ylabel('zc');


% figure(3);
% R.plot(Q(1, :),'trail', 'r');
% for i = 1:length(Q)
%     R.animate(Q(i, :));
%     view(0,0)
% end


%-----------Grafico posiciones articulares---------
figure(3)
subplot(3, 2, 1);
qplot(Q)
title(['Posición jtraj']);
subplot(3, 2, 3);
qplot(QD)
title(['Velocidad jtraj']);
subplot(3, 2, 5);
qplot(QDD)
title(['Aceleración jtraj']);
subplot(3, 2, 2);
qplot(QQ)
title(['Posición ctraj']);
subplot(3, 2, 4);
qplot(QQD)
title(['Velocidad ctraj']);
subplot(3, 2, 6);
qplot(QQDD)
title(['Aceleración ctraj']);
