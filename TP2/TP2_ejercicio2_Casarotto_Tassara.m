
% Ejemplos para el TP2

%=========================================================================%
clc, clear, close all
%=========================================================================%
fprintf('TP2   Ejercicio 2\n')
fprintf('Para seleccionar el ejercicio que quiera visualizar, ingrese "1", "2" o "3" que corresponden a los ejercicios 1,2 y 3 respectivamente\n')
OPT = input('\nOpción: ');
%=========================================================================%

if OPT == 1
    %Ejercicio 2-A
    ma = [1 ;0.5; 0 ;1]; %Coordenadas de a con respecto al M
    alfa = -17*(pi/180);    %Angulo que rota el sistema M con respecto a 0
    desplazamientoM = [0 ; 0 ; 0];   %Traslacion del origen de M con respecto al origen de 0
    T = [
        cos(alfa) -sin(alfa) 0 desplazamientoM(1);
        sin(alfa)  cos(alfa) 0 desplazamientoM(2);
           0          0      1 desplazamientoM(3);
           0          0      0        1         ];  %Matriz de rotacion y traslacion
    oa = T*ma
       
    
    figure; % Crea una nueva figura para el gráfico
    
    % Agregar un punto rojo en las coordenadas oa
    plot3(oa(1), oa(2), oa(3), 'ro', 'MarkerSize', 10);
    hold on;
    
    % Resto del código para trplot
    T0 = eye(4);
    T1 = trotz(alfa);   %usar trotx, troty o trotz para indicar sobre que eje gita {M}
    
    trplot(T0,'color','b','frame','0','length',1.8);
    trplot(T1,'color','r','frame','1','length',1);
    
    grid on;
    rotate3d on;
    axis([-2 2 -2 2 -2 2]);
    title('Ejercicio 2-A');

elseif OPT == 2
    %Ejercicio 2-B
    ma = [0 ;0; 1 ;1];
    alfa = 35*(pi/180);
    desplazamientoM = [0 ; 0 ; 0];
    T = [
        1     0           0      desplazamientoM(1);
        0  cos(alfa)  -sin(alfa) desplazamientoM(2);
        0  sin(alfa)   cos(alfa) desplazamientoM(3);
        0     0           0             1         ];
    oa = T*ma
       
    
    figure; % Crea una nueva figura para el gráfico
    
    % Agregar un punto rojo en las coordenadas (1.103, 0.1857, 0)
    plot3(oa(1), oa(2), oa(3), 'ro', 'MarkerSize', 10);
    hold on;
    
    % Resto del código para trplot
    T0 = eye(4);
    T1 = trotx(alfa);
    
    trplot(T0,'color','b','frame','0','length',2);
    trplot(T1,'color','r','frame','1','length',2);
    
    grid on;
    rotate3d on;
    axis([-2 2 -2 2 -2 2]);
    title('Ejercicio 2-B');
elseif OPT == 3
    %Ejercicio 2-C
    ma = [1 ;0.5; 0.3 ;1];
    alfa = 90*(pi/180);
    desplazamientoM = [0 ; 0 ; 0];
    T = [
              cos(alfa)   0    sin(alfa)  desplazamientoM(1);
                 0        1        0      desplazamientoM(2);
             -sin(alfa)   0    cos(alfa)  desplazamientoM(3);
                 0        0        0             1         ];
    oa = T*ma
       
    
    figure; % Crea una nueva figura para el gráfico
    
    
    % Agregar un punto rojo en las coordenadas oa
    plot3(oa(1), oa(2), oa(3), 'ro', 'MarkerSize', 10);
    hold on;
    
    % Resto del código para trplot
    T0 = eye(4);
    T1 = troty(alfa);   %usar trotx, troty o trotz para indicar sobre que eje gita {M}
    
    trplot(T0,'color','b','frame','0','length',2);
    trplot(T1,'color','r','frame','1','length',2);
    
    grid on;
    rotate3d on;
    axis([-2 2 -2 2 -2 2]);
    title('Ejercicio 2-C');
end