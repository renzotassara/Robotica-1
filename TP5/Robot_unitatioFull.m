close all, clear, clc;

fprintf('######################################################\n')
fprintf('#               Prueba Metódo de Pieper              #\n')
fprintf('######################################################\n\n')

%% Iniciación de robot modelo y coordenadas de prueba
dh = [
       0   1     0     pi/2   0;
       0   0	 1	      0	  0;
       0   0 	 0	   pi/2	  0;
       0   1	 0	  -pi/2   0;
       0   0     0     pi/2   0;
       0   1     0       0   0];
  
  
R = SerialLink(dh);

R.qlim(1:6,1:2)= [ones(3,1)*[-pi pi];ones(3,1)*[-2*pi 2*pi]];
R.plotopt = {'jointdiam',1};
q = -[30,-15,-20,10,40,15]*pi/180;
op = input('Desea ingresar coordenadas de prueba?(S/N)\n(Si elige N, el sistema usara coordenadas ya cargadas)\n','s');
if op == "S"
    q(1) = input("Ingrese q1 en grados\n")*pi/180;
    q(2) = input("Ingrese q2 en grados\n")*pi/180;
    q(3) = input("Ingrese q3 en grados\n")*pi/180;
    q(4) = input("Ingrese q4 en grados\n")*pi/180;
    q(5) = input("Ingrese q5 en grados\n")*pi/180;
    q(6) = input("Ingrese q6 en grados\n")*pi/180;
end
fprintf('Coordenadas articulares de prueba');
q
fprintf(">Matriz T obtenida mediante cinematica directa, para probar la solución");
T = R.fkine(q).double

QQ = PieperFull(T,R);

for i = 1:8
    q(1:6) = QQ(:,i)';
    fprintf(strcat("Coordenadas solución ",int2str(i),":\n",num2str(q)));
    R.name = strcat("Solución ",int2str(i));
    R.plot(q,'scale',0.8,'trail',{'r', 'LineWidth', 2});
    T60 = R.links(1).A(q(1)).double*R.links(2).A(q(2)).double*R.links(3).A(q(3)).double*...
        R.links(4).A(q(4)).double*R.links(5).A(q(5)).double ...
        *R.links(6).A(q(6)).double;    
    fprintf("\nMatriz TLH n°%d:\n[%5.4f, %5.4f, %5.4f, %5.4f]\n[%5.4f, %5.4f, %5.4f, %5.4f]\n[%5.4f, %5.4f, %5.4f, %5.4f]\n[%5.4f, %5.4f, %5.4f, %5.4f]\n",i,T60');
    if i < 8
        fprintf("\nPresione enter para siguiente plot\n\n");
        pause
    end
    
end