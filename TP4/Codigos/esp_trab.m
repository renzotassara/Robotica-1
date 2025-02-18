%TP4 Casarotto Tassara

clc, clear, close all

R = robot();


%==================Grafico plano YZ=========================%
y1 = [];    %Creo vectores para llenar con los datos correspondientes y luego plotearlo
z1 = [];

%------------Grafico en Y(-)------------%
for axis5 = R.qlim(5,1):(pi/180):0
    q = [0,R.qlim(2,1),R.qlim(3,1),0,axis5,0];  %Vario articulacion del extremo
    T = R.fkine(q).double;  
    y1_valor = T(2, end);   %Tomo elemento del vector de travectoria del extremo
    z1_valor = T(3, end);
    y1 = [y1,y1_valor]; %Agrego dicho elemento al vector creado anteriormente
    z1 = [z1,z1_valor];
end

for axis3 = R.qlim(3,1):(pi/180):(-pi/2)
    q = [0,R.qlim(2,1),axis3,0,0,0];
    T = R.fkine(q).double;
    y1_valor = T(2, end);
    z1_valor = T(3, end);
    y1 = [y1,y1_valor];
    z1 = [z1,z1_valor];
end

for axis2 = R.qlim(2,1):(pi/180):0
    q = [0,axis2,-pi/2,0,0,0];
    T = R.fkine(q).double;
    y1_valor = T(2, end);
    z1_valor = T(3, end);
    y1 = [y1,y1_valor];
    z1 = [z1,z1_valor];
end

%------------Grafico en Y(+)------------%

for axis2 = 0:(pi/180):R.qlim(2,2)
    q = [0,axis2,-pi/2,0,0,0];
    T = R.fkine(q).double;
    y1_valor = T(2, end);
    z1_valor = T(3, end);
    y1 = [y1,y1_valor];
    z1 = [z1,z1_valor];
end

for axis3 = -pi/2:(pi/180):R.qlim(3,2)
    q = [0,R.qlim(2,2),axis3,0,0,0];
    T = R.fkine(q).double;
    y1_valor = T(2, end);
    z1_valor = T(3, end);
    y1 = [y1,y1_valor];
    z1 = [z1,z1_valor];
end

for axis5 = 0:(pi/180):R.qlim(5,2)
    q = [0,R.qlim(2,2),R.qlim(3,2),0,axis5,0];
    T = R.fkine(q).double;
    y1_valor = T(2, end);
    z1_valor = T(3, end);
    y1 = [y1,y1_valor];
    z1 = [z1,z1_valor];
end

figure;
subplot(1,2,1)
plot(y1, z1,'b-','LineWidth',1);
title('Plano YZ')
xlabel('Y');
ylabel('Z')

%Fin de grafico plano YZ


%=============Grafico plano XY==============%
x2 = [];
y2 = [];

for axis1 = R.qlim(1,1):(pi/180):R.qlim(1,2)
    q = [axis1,pi/2,-pi/2,0,0,0];
    T = R.fkine(q).double;
    x2_valor = T(1, end);
    y2_valor = T(2, end);
    x2 = [x2,x2_valor];
    y2 = [y2,y2_valor];
end

subplot(1,2,2);
plot(x2, y2, 'r-','LineWidth',1);
title('Plano XY')
xlabel('X');
ylabel('Y')
hold on;
disp('Fin del mejor codigo del mundo')
