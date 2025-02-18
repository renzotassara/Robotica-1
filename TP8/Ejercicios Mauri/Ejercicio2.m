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

q0 = R.ikine(T0,'q0',qq);
q1 = R.ikine(T1,'q0',qq);

QQ = jtraj(q0,q1,100);

R.plot(q0,'trail',{'r','LineWidth',2});
R.animate(QQ);

figure(2);
qplot(QQ);



