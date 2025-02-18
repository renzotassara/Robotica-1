%Funcion que recibe como parametros las coordenadas del punto donde se
%intersectan los ejes de la muñeca y el objeto R de tipo SerialLink
function qq13 = Pieper1(xc,yc,zc,R)
%%
pc0 = [xc;yc;zc;1]; %se transforman las coordenada recibidas a un vector

qq13 = zeros(3,8); %Incicializacion de matriz de posibles soluciones,
                   % en formato para ser utilizada junto a las posibles
                   % soluciones de q4, q5 y q6

a2 = R.links(2).a;
a3 = R.links(4).d;
                   
%% Calculo de q1 mediante arcotangente                   
qq13(1,1:4) = atan2(yc,xc);
% La otra alternativa para q1 tiene que ver con el cuadrante en el que se
% encuentra q1
if qq13(1,1) > 0
    qq13(1,5:8) = qq13(1,1:4) - pi;
else
    qq13(1,5:8) = qq13(1,1:4) + pi;
end

%% Calculo de q2 y q3
for i=1:2
    %El bucle va a calcular en cada iteración los valores de q2 y q3
    %respectivos a la q1 correspondiente con la iteración
    if mod(i,2) == 0
        T10 = R.links(1).A(qq13(1,5)).double;
    else
        T10 = R.links(1).A(qq13(1,1)).double;
    end
    
    T01 = [T10(1:3,1:3)' -T10(1:3,1:3)'*T10(1:3,4); 0 0 0 1];
    
    pc1 = T01*pc0;
    
    x1 = pc1(1);
    y1 = pc1(2);
    
    beta = atan2(y1,x1);
    r = sqrt(x1^2 + y1^2);
    alfa = acos((a2^2 + r^2 - a3^2)/(2*r*a2));
    
    qq13(2,1+4*(i-1)) = beta - real(alfa);
    qq13(2,3+4*(i-1)) = beta + real(alfa);
    
    for j =1:2
        T20 = T10*R.links(2).A(qq13(2,1+2*(j-1)+4*(i-1))).double;
        
        T02 = [T20(1:3,1:3)' -T20(1:3,1:3)'*T20(1:3,4);0 0 0 1];
        
        pc2 = T02*pc0;
        
        x2 = pc2(1);
        y2 = pc2(2);
    
        qq13(3,1+2*(j-1)+4*(i-1)) = atan2(y2,x2) + pi/2;
        
        if (qq13(3,1+2*(j-1)+4*(i-1))>pi)
            qq13(3,1+2*(j-1)+4*(i-1)) = qq13(3,1+2*(j-1)+4*(i-1)) - 2*pi;
        elseif (qq13(3,1+2*(j-1)+4*(i-1))<-pi)
            qq13(3,1+2*(j-1)+4*(i-1)) = qq13(3,1+2*(j-1)+4*(i-1)) +2*pi;
        end
    end
    
end

%% Ordenamiento de qq13
%Se deben aparear los valores que corresponda entre las posibles soluciones
%para q2 y q3

for i=2:2:8
    qq13(2,i) = qq13(2,i-1);
    qq13(3,i) = qq13(3,i-1);
end




fprintf("\nPosibles soluciones para el problema de posición\n");
qq13

end




