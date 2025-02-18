
%Creación del robot
R = robot();

% Vector de coordenadas iniciales
q = [0,0,0,0,0,0];

% Sistemas de referencia a plotear (como booleano)
sr = [0,0,0,1,1,1,1];

% Carpeta donde se guardan los stl
path = strcat(pwd,'\PIEZAS\Piezas final');

% Inicialización de maatriz tridimensional, cada capa es una transformación
% entre sistemas subsecuentes
T = zeros(4,4,R.n+1); 
%En la creación del robot, se puede mover y girar la base, por lo que se
%referencia el sistema 0 a la transformación de la base y no al 0 global
T(:,:,1) = R.base;

%Armado de matrices de transformación 0T1, 1T2, 2T3, étc. 
for i = 2:R.n+1
    T(:,:,i)=trotz(R.theta(i-1))*transl(0,0,R.d(i-1))*transl(R.a(i-1),0,0)*trotx(R.alpha(i-1));
end


R.plot3d(q,'path',path,'scale',0.001,'notiles');
hold on


for i = 1: R.n+1
    %Los sistemas de referencia se plotean respecto al {0}, por lo que se
    %deben multiplicar sucecivamente las matrices de transformación
    %homogenea, ej.: Para representar 0T3, necesito hacer 0T1*1T2*2T3. Se
    %obtienen todas las matrices de transformación de los sistemas y luego
    %se evalua el vector de booleanos para ver si corresponde el plot o no
    if i == 1
        Taux = T(:,:,i);
    else
        Taux = Taux*T(:,:,i);
    end
    
    if sr(i) == 1        
        trplot(Taux,'color','r','frame',int2str(i-1),'length',0.3);
    end
 
end

