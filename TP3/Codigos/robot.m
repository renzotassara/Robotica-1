function R = robot()

    %=========================================================================%
    clc, clear, close all
    addpath(genpath('rtb'))
    addpath(genpath('smtb'))
    addpath(genpath('common'))
    %=========================================================================%


    dh = [
        0.000  0.327  0.000   -pi/2 0;
        -pi/2   0.000  0.225     0  0;
        0.000  0.000  0.010   -pi/2 0;
        0.000  0.250  0.000    pi/2 0;
        0.000  0.000  0.000   -pi/2 0;
        0.000  0.064  0.000  0.000 0];  %Matriz DH


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
    R.offset = [0, -pi/2, 0, 0, 0,0];

    %La funcion "base" representa la posición y orientación de la base del robot con respecto al mundo o al sistema de coordenadas global
    R.base = trotz(pi/2); %--> Ejemplo

    %La funcion tool representa la posición y orientación del extremo del robot con respecto al último eslabón 
    R.tool = trotz(pi/2); % ---> Ejemplo: traslada 10cm y luego rota 90º

    %=====Variable Workspace====%
    workspace = [-0.475,0.475,-0.475,0.475,0,0.802];

    %=======================Visualizacion del robot========================%

    %Sin archivos STL
    %R.plot(q, 'scale', 0.8, 'trail', {'r', 'LineWidth', 2});

    %Con archivos STL
    R.plotopt3d = {'workspace',workspace};


    %ANOTACION:
    %Para que teach no graficara los archivos STL y el robot sin los archivos
    %STL a la vez, tuve que cambiar en la libreria (o funcion) de teach, linea
    %115 robot.plot ---> robot.animate
end