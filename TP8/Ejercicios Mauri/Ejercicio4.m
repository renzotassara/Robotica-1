%% Limpieza 
close all
clear
clc

%% Inicialización P, R, T, t
P1 = [0, 0, 0.95];
P2 = [0.4, 0, 0.95];

qq = [0, -pi/2, -pi/4, 0, pi/4, 0];

dh = [
    0      0.45   0.075 -pi/2  0;
    0      0      0.3    0     0;
    0      0      0.075 -pi/2  0;
    0      0.32   0      pi/2  0;
    0      0      0     -pi/2  0;
    0      0.008  0      0     0];
R = SerialLink(dh);

rot = R.fkine(qq).double;
rot = rot(1:3,1:3);

T0 = eye(4);
T0(1:3,1:3) = rot;
T0(1:3,4) = P1';

T1 = eye(4);
T1(1:3,1:3) = rot;
T1(1:3,4) = P2';
dt = 1/100;
t = 0:dt:1;

%% Calculo jtraj
q0 = R.ikine(T0,'q0',qq);
q1 = R.ikine(T1,'q0',qq);

[QQ, QD, QDD] = jtraj(q0,q1,t);

f_art = figure('Name','Coordenadas articulares');
subplot(2,3,1);
qplot(t,QQ);
title('Posiciones jtraj');
xlabel('Tiempo [s]');
ylabel('Coordenadas angulares [rad,m]')
axpos = axis;
subplot(2,3,2);
qplot(t,QD);
title('Velocidades jtraj');
xlabel('Tiempo [s]');
ylabel('Velocidades angulares [rad/s,m/s]');
axvel = axis;
subplot(2,3,3);
qplot(t,QDD);
title('Aceleraciones jtraj');
xlabel('Tiempo [s]');
ylabel('Aceleraciones angulares [rad/s2,m/s2]');
axacel = axis;

%% Grafico XYZ de jtraj
Tj = R.fkine(QQ).double;
xj = squeeze(Tj(1,4,:))';
yj = squeeze(Tj(2,4,:))';
zj = squeeze(Tj(3,4,:))';
f_pos = figure('Name','XYZ jtraj');
subplot(3,2,1)
plot(t,xj);
title('X jtraj');
ylabel('X [m]');
axx = axis;
grid on
subplot(3,2,3);
plot(t,yj);
title('Y jtraj');
ylabel('Y [m]');
axy = axis;
grid on
subplot(3,2,5);
plot(t,zj);
title('Z jtraj');
ylabel('Z [m]');
axz = axis;
grid on


%% Calculo ctraj y derivación
S = tpoly(0,1,t);
Tc = ctraj(T0,T1,S);
pos = R.ikine(Tc,'q0',qq);
vel = diff(pos)/dt;
acel = diff(pos,2)/(dt^2);
figure(f_art);
subplot(2,3,4);
qplot(t,pos);
title('Posiciones ctraj');
xlabel('Tiempo [s]');
ylabel('Coordenadas angulares [rad,m]')
axis(axpos);
subplot(2,3,5);
qplot(t(1:end-1),vel);
title('Velocidades ctraj');
xlabel('Tiempo [s]');
ylabel('Velocidades angulares [rad/s,m/s]')
axis(axvel);
subplot(2,3,6);
qplot(t(1:end-2),acel);
title('Aceleraciones ctraj');
xlabel('Tiempo [s]');
ylabel('Aceleraciones angulares [rad/s2,m/s2]');
axis(axacel);

%% Grafico XYZ de ctraj
xc = squeeze(Tc(1,4,:))';
yc = squeeze(Tc(2,4,:))';
zc = squeeze(Tc(3,4,:))';
figure(f_pos);
subplot(3,2,2);
plot(t,xc);
title('X ctraj');
ylabel('X [m]');
grid on
axis(axx)
subplot(3,2,4);
plot(t,yc);
title('Y jtraj');
ylabel('Y [m]');
grid on
axis(axy)
subplot(3,2,6);
plot(t,zc);
title('Z jtraj');
ylabel('Z [m]')
grid on
axis(axz)

%% Comparación ZX
figure('Name','ZX')
subplot(2,1,1);
plot(xj,zj);
title('Z(X) jtraj');
grid on
axzx = axis;
subplot(2,1,2);
plot(xc,zc);
title('Z(X) ctraj');
axis(axzx);
grid on