q0 = [0, -pi/2, 0, 0, 0, 0]; 
q1 = [-pi/3, pi/10, -pi/5, pi/2, pi/4, 0];
T = 0:0.1:3;
Q = jtraj(q0,q1,T);

dh = [
    0      0.45   0.075 -pi/2  0;
    0      0      0.3    0     0;
    0      0      0.075 -pi/2  0;
    0      0.32   0      pi/2  0;
    0      0      0     -pi/2  0;
    0      0.008  0      0     0];
R = SerialLink(dh);
R.plot(q0,'trail',{'r', 'LineWidth', 2});
R.animate(Q);

figure(2);
qplot(T,Q);