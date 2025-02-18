%Ejercicio 5 TP5B Casarotto Tassara

addpath rtb common smtb
close all; clear all; clc;

%Longitudes de eslabones
a1 = 0.8;
a2 = 0.5;
a3 = 1;
l = [a1;a2;a3];

%Matriz de DH
dh = [0 0 a1 0 0;
      0 0 a2 0 0;
      0 0 a3 0 0];

R = SerialLink(dh,'name','Ejercicio 5B');    %Defino R
R.qlim(1,1:2) = [-180,180]*pi/180; 
R.qlim(2,1:2) = [-180,180]*pi/180; 
R.qlim(3,1:2) = [-180,180]*pi/180;

%Ingresar las coordenadas de Xc, Yc y Zc
xc = 0.5;   %Estos valores son de prueba para probar el codigo de forma mas rapida. Una vez que funcione bien, descomentar lineas de abajo para que el usuario ingrese los valores
yc = 0.3;
zc = 0.2;

% xc = input("Ingrese la coordenada Xc: ");
% yc = input("Ingrese la coordenada Yc: ");
% zc = input("Ingrese la coordenada Zc: ");

%Creo matriz tridimencional para completar las posiciones relativas del
%extremo con respecto a los diferentes sistemas con sus respectivas
%soluciones
%Por ejemplo:
% pc(:,:,2) =
%
%q1(1)  q1(2)
% |      |
%[xc'   xc''    0   0
% yc'   yc''    0   0
% zc'   zc''    0   0
% 1      1      1   1]
%
%La matriz anterior describe la posicion relativa entre el sistema 1 y el
%extremo para las dos soluciones posibles que tendra q1
pc = zeros(4,4,3);
pc(4,:,:) = 1;
pc(:,1,1) = [xc;yc;zc;1];


%==========Calculo de q1============
q1 = zeros(1,2);
q1aux = atan2(pc(2),pc(1));
q1(1) = q1aux;
if q1aux < 0
    q1(2) = q1aux + pi;
else
    q1(2) = q1aux - pi;
end

%=========Calculo de q2============
q2 = zeros(1,4);
k = 1;

for i = 1:2
    T1 = R.links(1).A(q1(i)).double;   %Calcula matriz de T.Hom. del link 1 y el valor calculado de q1
    pc(:,i,2) = inv(T1)*pc(:,1,1); %Calculo la posicion del extremo con respecto al sistema 1 para cada solucion de q1
    
    beta = atan2(pc(2,i,2),pc(1,i,2));
    r = sqrt(pc(1,i,2)^2 + pc(2,i,2)^2);
    L2 = R.links(2).a;
    L3 = R.links(3).a;
    alfa = acos(L2^2 + r^2 - L3^2)/(2*r*L2);
    
    q2(k) = beta - real(alfa);
    q2(k+1) = beta + real(alfa);
    k = k + 2;
end

%=========Calculo de q3==========
q3 = zeros(1,4)
k = 0;
for i = 1:2
    T1 = R.links(1).A(q1(i)).double;
    for j = 1:2
        T2 = T1*R.links(2).A(q2(j+k)).double;
        pc(:,j+k,3) = inv(T2) * pc(:,i,2);
        q3(j+k) = atan2(pc(2,j+k,3),pc(1,j+k,3)) - pi/2;
    end
    k = k + 2;
end
%Matriz solucion
qq = zeros(3,8);
qq(1,:) = [q1(1) q1(1) q1(1) q1(1) q1(2) q1(2) q1(2) q1(2)]; 
qq(2,:) = [q2(1) q2(1) q2(2) q2(2) q2(3) q2(3) q2(4) q2(4)];
qq(3,:) = [q3(1) q3(1) q3(2) q3(2) q3(3) q3(3) q3(4) q3(4)];

qq















