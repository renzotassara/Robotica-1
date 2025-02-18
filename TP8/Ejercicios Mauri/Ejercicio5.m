q0 = zeros(1,6);
q1 = [36, -43, 22, 36, -70, 80]*pi/180;
q2 = [90, -80, -36, -75, -70, 130]*pi/180;
q3 = [-25, -25, -61, -180, -32, 94]*pi/180;

dh = [
    0      0.45   0.075 -pi/2  0;
    0      0      0.3    0     0;
    0      0      0.075 -pi/2  0;
    0      0.32   0      pi/2  0;
    0      0      0     -pi/2  0;
    0      0.008  0      0     0];
R = SerialLink(dh,'name','Fanuc Paint Mate 200iA');

t = 0:0.01:1;
[Q,QD,QDD] = jtraj(q0,q1,t);
[P,V,A]=jtraj(q1,q2,t);
Q = [Q;P];
QD = [QD;V];
QDD = [QDD;A];
[P,V,A] = jtraj(q2,q3,t);
Q = [Q;P];
QD = [QD;V];
QDD = [QDD;A];

figure('Name','Fanuc Paint Mate 200iA')
R.plot(Q(1,:),'trail',{'r','LineWidth',2});
R.animate(Q);

figure('Name','Variables articulares');
qplot([t,t(end)+t,2*t(end)+t]',Q);
ylabel('Coordenadas Articulares [rad]');
figure('Name','Velocidades articulares');
qplot([t,t(end)+t,2*t(end)+t]',QD);
ylabel('Velocidades Articulares [rad/s]');
figure('Name','Aceleraciones articulares');
qplot([t,t(end)+t,2*t(end)+t]',QDD);
ylabel('Aceleraciones Articulares [rad/s2]');