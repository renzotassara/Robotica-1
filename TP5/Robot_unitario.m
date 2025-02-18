close all, clear, clc;

dh = [
       0   1     0     pi/2   0;
       0   0	 1	      0	  0;
       0   0 	 0	   pi/2	  0;
       0   1	 0	  -pi/2   0;
       0   0     0     pi/2   0;
       0   1     0       0   0];
  
  
R = SerialLink(dh);

R.qlim(1:6,1:2)= ones(6,1)*[-pi pi];
R.plotopt = {'jointdiam',1};
q = [30,-15,-20,10,40,15]*pi/180;
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
T = R.fkine(q).double;
T = R.base.double\T*inv(R.tool.double);
pc = T(1:3,4) - dh(6,2)*T(1:3,3);
R.plot(q,'scale',0.8,'trail',{'r', 'LineWidth', 2});
qq = Pieper1(pc(1),pc(2),pc(3),R);

for i = 1:2:8
    q(1:3) = qq(:,i)';
    fprintf(strcat("Coordenadas solución ",int2str((i+1)/2),":\n",num2str(q)));
    R.name = strcat("Solución ",int2str((i+1)/2));
    R.plot(q,'scale',0.8,'trail',{'r', 'LineWidth', 2});
    T30 = R.links(1).A(q(1)).double*R.links(2).A(q(2)).double*R.links(3).A(q(3)).double*...
        R.links(4).A(q(4)).double;
    fprintf("\nVector de traslación %d: [%5.2f,%5.2f,%5.2f]\n",(i+1)/2,T30(1:3,4));
    if i < 7
        fprintf("\nPresione enter para siguiente plot\n");
        pause
    end
    
end

