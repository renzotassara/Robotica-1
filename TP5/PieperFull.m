function QQ = PieperFull(T,R)
%%
T = R.base.double\T*inv(R.tool.double);
%Se calcula el origen de la muñeca en función de la matriz T y los
%parámetros de DH del robot
pc0 = T(:,4) - R.d(6)*T(:,3) 
xc = pc0(1);
yc = pc0(2);
zc = pc0(3);

%Incicializacion de matriz de posibles soluciones
QQ = zeros(6,8); 

a2 = R.links(2).a;
a3 = R.links(4).d;
                   
%% Calculo de q1 mediante arcotangente                   
QQ(1,1:4) = atan2(yc,xc);
% La otra alternativa para q1 tiene que ver con el cuadrante en el que se
% encuentra q1
if QQ(1,1) > 0
    QQ(1,5:8) = QQ(1,1:4) - pi;
else
    QQ(1,5:8) = QQ(1,1:4) + pi;
end

%% Calculo de q2 y q3
for i=1:2
    %El bucle va a calcular en cada iteración los valores de q2 y q3
    %respectivos a la q1 correspondiente con la iteración
    if mod(i,2) == 0
        T10 = R.links(1).A(QQ(1,5)).double;
    else
        T10 = R.links(1).A(QQ(1,1)).double;
    end
    
    T01 = [T10(1:3,1:3)' -T10(1:3,1:3)'*T10(1:3,4); 0 0 0 1];
    
    pc1 = T01*pc0;
    
    x1 = pc1(1);
    y1 = pc1(2);
    
    beta = atan2(y1,x1);
    r = sqrt(x1^2 + y1^2);
    alfa = acos((a2^2 + r^2 - a3^2)/(2*r*a2));
    
    QQ(2,1+4*(i-1)) = beta - real(alfa);
    QQ(2,3+4*(i-1)) = beta + real(alfa);
    
    for j =1:2
        T20 = T10*R.links(2).A(QQ(2,1+2*(j-1)+4*(i-1))).double;
        
        T02 = [T20(1:3,1:3)' -T20(1:3,1:3)'*T20(1:3,4);0 0 0 1];
        
        pc2 = T02*pc0;
        
        x2 = pc2(1);
        y2 = pc2(2);
    
        QQ(3,1+2*(j-1)+4*(i-1)) = atan2(y2,x2) + pi/2;
        
%         if (QQ(3,1+2*(j-1)+4*(i-1))>pi)
%             QQ(3,1+2*(j-1)+4*(i-1)) = QQ(3,1+2*(j-1)+4*(i-1)) - 2*pi;
%         elseif (QQ(3,1+2*(j-1)+4*(i-1))<-pi)
%             QQ(3,1+2*(j-1)+4*(i-1)) = QQ(3,1+2*(j-1)+4*(i-1)) +2*pi;
%         end
    end
    
end

%% Ordenamiento de QQ
%Se deben aparear los valores que corresponda entre las posibles soluciones
%para q2 y q3

for i=2:2:8
    QQ(2,i) = QQ(2,i-1);
    QQ(3,i) = QQ(3,i-1);
end

%% Problema de orientación

for i=1:2:7
    T63 = inv(R.links(3).A(QQ(3,i))).double*inv(R.links(2).A(QQ(2,i))).double...
          *inv(R.links(1).A(QQ(1,i))).double*T;
      
    QQ(4,i) = atan2(T63(2,3),T63(1,3));
    
    if (QQ(4,i) > 0)
        QQ(4,i+1) = QQ(4,i) - pi;
    else
        QQ(4,i+1) = QQ(4,i) + pi;
    end
    
    for j=i:i+1
        T43 = R.links(4).A(QQ(4,j)).double;
        T64 = T43\T63;
        
        QQ(5,j) = atan2(T64(2,3), T64(1,3)) + pi/2;
        
        T54 = R.links(5).A(QQ(5,j)).double;
        T65 = T54\T64;
        QQ(6,j) = atan2(T65(2,1), T65(1,1));

    end

end

end