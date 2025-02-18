T0 = eye(4);
T1 = [cosd(-26.56), -sind(-26.56),    0,    7;
      sind(-26.56),  cosd(-26.56),    0,    4;
                 0,             0,    1,    0;
                 0,             0,    0,    1];
om = [7; 4; 0; 1];
ma = [2; 1; 0; 1];             
oa = T1*ma;

figure(1);
grid on;
rotate3d on;
axis([-2 10 -2 10 -2 10]);
title('Ejercicio 4');
hold on;
trplot(T0,'color','b','frame','0','length',10);
trplot(T1,'color','r','frame','1','length',2);
plot3(oa(1), oa(2), oa(3), 'ro', 'MarkerSize', 6);