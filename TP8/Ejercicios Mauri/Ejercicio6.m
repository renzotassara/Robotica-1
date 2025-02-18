q1 = [36, -43, 22, 36, -70, 80]*pi/180;
q2 = [90, -80, -36, -75, -70, 130]*pi/180;
q3 = [-25, -25, -61, -180, -32, 94]*pi/180;

WP = [q1;q2;q3];
QDMAX = [350, 350, 400, 450, 450, 720];
TSEG = [1,1,1]; % Si se define QDMAX, entonces []
Q0 = zeros(1,6); % o []
DT = 0.01;
TACC = 0.3;
[TRAJ, t, DATA] = mstraj(WP, QDMAX, [], Q0, DT, TACC, 'noverbose');

dh = [
    0      0.45   0.075 -pi/2  0;
    0      0      0.3    0     0;
    0      0      0.075 -pi/2  0;
    0      0.32   0      pi/2  0;
    0      0      0     -pi/2  0;
    0      0.008  0      0     0];
R = SerialLink(dh,'name','Fanuc Paint Mate 200iA');

TRAJD = diff(TRAJ)/DT;
TRAJDD = diff(TRAJD)/DT;

figure('Name','Fanuc Paint Mate 200iA')
R.plot(TRAJ(1,:),'trail',{'r','LineWidth',2});
R.animate(TRAJ);

figure('Name','Variables articulares');
qplot(t,TRAJ);
ylabel('Coordenadas Articulares [rad]');
figure('Name','Velocidades articulares');
qplot(t(1:length(t)-1),TRAJD);
ylabel('Velocidades Articulares [rad/s]');
figure('Name','Aceleraciones articulares');
qplot(t(1:length(t)-2),TRAJDD);
ylabel('Aceleraciones Articulares [rad/s2]');