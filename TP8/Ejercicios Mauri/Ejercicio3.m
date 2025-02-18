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

TC = ctraj(T0,T1,100);

QQ = R.ikine(TC,'q0',qq);

figure('Name','Fanuc Paint Mate 200iA')
R.plot(QQ(1,:),'trail',{'r','LineWidth',2});
R.animate(QQ);

figure('Name','Variables articulares');
qplot(QQ);