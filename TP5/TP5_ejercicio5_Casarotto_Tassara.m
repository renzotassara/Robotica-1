%Ejercicio 5 TP5A Casarotto Tassara

addpath rtb common smtb
close all; clear all; clc;

%Logitudes de eslabones
a1 = 0.5;
a2 = 0.8;
a3 = 0.6;
longitud_max = a1+a2+a3;

%Matriz DH
dh = [0 0 a1 0 0;
      0 0 a2 0 0;
      0 0 a3 0 0];

R = SerialLink(dh,'name','Ejercicio 5');    %Defino R

%Defino limites de articulaciones
R.qlim(1,1:2) = [-180,180]*pi/180; 
R.qlim(2,1:2) = [-180,180]*pi/180; 
R.qlim(3,1:2) = [-180,180]*pi/180;

%Ingreso de posicion donde se quiere llegar
x = input('Ingresar coordenada X donde se quiere llegar: ');
y = input('Ingresar coordenada Y donde se quiere llegar: ');
gamma = input('Ingresar angulo Gamma (en grados): ');
gamma = gamma*(pi/180);

%Coordenadas de extremo de articulacion 2
x2 = x-a3*cos(gamma);
y2 = y-a3*sin(gamma);

%============================Calculo de q1==============================
q1 = zeros(2,1); %Vector solucion de q1
r = sqrt(x2^2 + y2^2)
alfa = acos((a2^2 - a1^2 - r^2)/(-2*a1*r)); %Angulo de a1 respecto de r
beta = atan2(y2,x2); %Angulo de r respecto a X0

if (~isreal(alfa))
    while (~isreal(alfa))
        disp('Posición inalcanzable, por favor vuelva a ingresar los valores')
        x = input('Ingresar coordenada X donde se quiere llegar: ');
        y = input('Ingresar coordenada Y donde se quiere llegar: ');
        gamma = input('Ingresar angulo Gamma (en grados): ');
        gamma = gamma * (pi / 180);  % Convierte gamma a radianes
        x2 = x - a3 * cos(gamma);
        y2 = y - a3 * sin(gamma);
        r = sqrt(x2^2 + y2^2);
        alfa = acos((a2^2 - a1^2 - r^2) / (-2 * a1 * r));
        beta = atan2(y2, x2);
    end
end

q1(1,1) = beta + alfa; 
q1(2,1) = beta - alfa; 

%===========================Calculo de q2==============================
q2 = zeros(2,1); %Vector solucion de q2
for i = 1:2
    q2(1,1) = -acos((r^2-a1^2-a2^2)/(2*a1*a2));
    q2(2,1) = -q2(1,1); %Por ser simetrico

    %Segunda forma de calculo de q2
     % T1 = R.links(1).A(q1(i,1)).double; %T.Homogenea que describe posicion y orientacion de punto 1 en relacion a la base
     % P2 = inv(T1)*[x2;y2;0;1];  %Posicion del punto 2 en relacion a 1
     % q2(i,1) = atan2(P2(2),P2(1)); %Calculo de q2
end

%============================Calculo de q3==============================
q3 = zeros(2,1); %Vector solucion de q3
for i = 1:2
    q3(i,1) = gamma - q1(i,1) - q2(i,1);
    %Segunda forma de calculo de q2
    % T1 = R.links(1).A(q1(i,1)).double; %T.Homogenea que describe posicion y orientacion de punto 1 en relacion a la base
    % T2 = T1*R.links(2).A(q2(i,1)).double;
    % P3 = inv(T2)*[x;y;0;1];  %Posicion del punto 3 en relacion a 2
    % q3(i,1) = atan2(P3(2),P3(1)); %Calculo de q3
end

%Armando matriz con todos los resultados
q = zeros (2,3);
q(:,1) = q1;
q(:,2) = q2;
q(:,3) = q3;

fprintf('q:\n')
disp('  q1       q2       q3');
disp(q*(180/pi))

%Grafico
figure(1)
R.plot(q(1,:),'scale',1,'jointdiam',0.5) % Ploteo del modelo.
grid on
view(2);

input('Presiona Enter para graficar la otra solucion');

figure(1)
R.plot(q(2,:),'scale',1,'jointdiam',0.5) % Ploteo del modelo.
grid on
view(2);

disp('Siuuuu');