T0 = eye(4);
T1 = [0.5 , -0.866, 0;
     0.866, 0.5,    0;
         0,   0,    1];
T2 = [ 0,  0, 1;
      -1,  0, 0;
       0, -1, 0];
T3 = [  0.5,  -0.750, -0.433;
      0.866,   0.433,  0.250;
          0,  -0.500,  0.866];

figure(1);
grid on;
rotate3d on;
axis([-2 2 -2 2 -2 2]);
title('Ejercicio 1_A');
hold on;
trplot(T0,'color','b','frame','0','length',2);
trplot(T1,'color','r','frame','1','length',1.5);


figure(2);
grid on;
rotate3d on;
axis([-2 2 -2 2 -2 2]);
title('Ejercicio 1_B');
hold on;
trplot(T0,'color','b','frame','0','length',2);
trplot(T2,'color','r','frame','1','length',1.5);


figure(3);
grid on;
rotate3d on;
axis([-2 2 -2 2 -2 2]);
title('Ejercicio 1_C');
hold on;
trplot(T0,'color','b','frame','0','length',2);
trplot(T3,'color','r','frame','1','length',1.5);