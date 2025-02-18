%Alumnos:
% Casarotto Mauricio
% Tassara Renzo

    %=========================================================================%
    clc, clear, close all
    addpath rtb common smtb
    %=========================================================================%


dh = [
    0.000  0.450  0.075  -pi/2 0;
    0.000  0.000  0.300     0  0;
    0.000  0.000  0.075  -pi/2 0;
    0.000  0.320  0.000   pi/2 0;
    0.000  0.000  0.000  -pi/2 0;
    0.000  0.008  0.000  0.000 0];  %Matriz DH


    R = SerialLink(dh,'name','ABB IRB1100 0.475');  %Defino objeto robot

    %==============Defino limites de cada articulacion del robot==============%
    R.qlim(1,:) = [-230, 230]*pi/180;
    R.qlim(2,:) = [-115, 113]*pi/180;
    R.qlim(3,:) = [-205, 55]*pi/180;
    R.qlim(4,:) = [-230, 230]*pi/180;
    R.qlim(5,:) = [-125, 120]*pi/180;
    R.qlim(6,:) = [-400, 400]*pi/180;

    %============Defino offset, distancia a la base, distancia de la herramienta===========%
    %La funcion "offset" se utiliza para especificar un valor de compensación en radianes para una articulación específica del robot
    R.offset = [0, 0, 0, 0, 0,0];


% Sistemas de referencia a plotear (como booleano)
sr = [1,0,0,0,0,0,0];

% Inicialización de matriz tridimensional, cada capa es una transformación
% entre sistemas subsecuentes
T = zeros(4,4,R.n+1); 
%En la creación del robot, se puede mover y girar la base, por lo que se
%referencia el sistema 0 a la transformación de la base y no al 0 global
T(:,:,1) = R.base;
%Armado de matrices de transformación 0T1, 1T2, 2T3, étc. 

str_j = input('Ingrese que arreglo quiere calcular: ', 's');
j = str2double(str_j);

if j == 1
    q = [0,0,0,0,0,0];
elseif j == 2
    q = [pi/4, pi/2, 0, 0, 0, 0];
elseif j == 3
    q = [pi/5, -2*pi/5, -pi/10, pi/2, 3*pi/10, -pi/2];
else
    q = [-0.61, -0.15, -0.30, 1.40, 1.90, -1.40];
end
%dh(:,1) = q;
%Calculo las transformaciones teniendo en cuenta q (sin modificar DH) para
%poder graficar los sistemas de cada eslabon despues
for i = 2:R.n+1
    T(:,:,i)=(trotz(q(i-1)+R.offset(i-1)))*transl(0,0,R.d(i-1))*transl(R.a(i-1),0,0)*trotx(R.alpha(i-1));
end



%===========SOLO ESTO PIDE LA CONSIGNA===========%
fprintf('La matriz resultante 6T0 es: \n');
disp(R.fkine(q))

%================================================%

figure;
R.plot(q, 'scale', 0.8, 'trail', {'r', 'LineWidth', 2});
view(2)

hold on;

%Grafico los sistemas de referencia para cada eslabon con el q
%correspondiente
for i = 1: R.n+1
    if i == 1
        Taux = T(:,:,i);
    else
        Taux = Taux*T(:,:,i);
    end

    if sr(i) == 1        
        trplot(Taux,'color','r','frame',int2str(i-1),'length',0.2);
    end
end

disp('La matriz Homogenea total 0T4 es:');
disp(Taux);

% q1 = [0,0,0,0,0,0];
% q2 = [pi/4, pi/2, 0, 0, 0, 0];
% q3 = [pi/5, -2*pi/5, -pi/10, pi/2, 3*pi/10, -pi/2];
% q4 = [-0.61, -0.15, -0.30, 1.40, 1.90, -1.40];

% figure;
% subplot(2,2,1)
% R.plot(q1, 'scale', 0.8, 'trail', {'r', 'LineWidth', 2});
% clear
% subplot(2,2,2)
% R.plot(q2, 'scale', 0.8, 'trail', {'g', 'LineWidth', 2});
% clear
% subplot(2,2,3)
% R.plot(q3, 'scale', 0.8, 'trail', {'b', 'LineWidth', 2});
% clear
% subplot(2,2,4)
% R.plot(q4, 'scale', 0.8, 'trail', {'c', 'LineWidth', 2});



