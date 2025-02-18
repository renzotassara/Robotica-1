%Ejercicio 5 TP5B Casarotto Tassara

addpath rtb common smtb
close all; clear all; clc;
%=======Posiciones y orientacion=========

    q_mejor = input('Obtener todas las soluciones (0) o solucion unica (1): ');
    %Articulaciones actuales
    q0 = [30,-15,-20,10,40,15]*pi/180;
    %Posicion y orientacion final sin tener en cuenta offset
    x=0.2;
    y=0.2;
    z=0.3;
    rumbo = 60*(pi/180);
    cabeceo = 20*(pi/180);
    giro = 20*(pi/180);
    [qq1,Q] = cin_inv(x,y,z,rumbo,cabeceo,giro,q0,q_mejor)
    cin_dir(qq1,q_mejor,Q)
    
function [qq1,Q] = cin_inv(x,y,z,rumbo,cabeceo,giro,q0,q_mejor)
    
    %===Importo robot===
    R = robot();
    %========Constantes a definir===========
    comparador = 10e-5;  %Es la precision del punto flotante comoo para ver si q5=0
    k = 1;              %Sirve para sacar dos soluciones a partir de una (por ejemplo las dos soluciones de q2 para un q1)
    
    
    
    % op = input('Usar valores precargados? (s/n): ', 's');
    % 
    % if op == 's'
    %     % Solicito al usuario la posicion del efector final
    %     x = input('Ingrese la posicion X del efector final: ')*(pi/180);
    %     y = input('Ingrese la posicion Y del efector final: ')*(pi/180);
    %     z = input('Ingrese la posicion Z del efector final: ')*(pi/180);
    % 
    %     % Solicito al usuario los ángulos de rumbo, cabeceo y giro deseados
    %     rumbo = input('Ingrese el ángulo de rumbo deseado (en grados): ')*(pi/180);
    %     cabeceo = input('Ingrese el ángulo de cabeceo deseado (en grados): ')*(pi/180);
    %     giro = input('Ingrese el ángulo de yaw giro (en grados): ')*(pi/180);
    %  else
    %     x=0.5;
    %     y=0.1;
    %     z=0.1;
    %     rumbo = 60*(pi/180);
    %     cabeceo = 20*(pi/180);
    %     giro = 20*(pi/180);
    %  end
    
    
    
    %Matriz de transformacion
    Rot_deseada = eul2r(rumbo, cabeceo, giro);  % Creo la matriz de rotación a partir de los ángulos de Euler
    T = eye(4);
    T(1:3, 1:3) = Rot_deseada;
    T(:,4) = [x;y;z;1];
    
    %Tranformacion de matriz segun base y tool
    Tbase = R.base.double;
    Ttool = R.tool.double;
    Toffset = R.offset;
    R.offset = [0,0,0,0,0,0];
    T = [Tbase(1:3,1:3)' -Tbase(1:3,1:3)'*Tbase(1:3,4);0,0,0,1] * T * [Ttool(1:3,1:3)' -Ttool(1:3,1:3)'*Ttool(1:3,4);0,0,0,1];
    
    pc = [T(1:3,4) - (R.links(6).d)*T(1:3,3);1];   %Posicion del centro de la muñeca
    
    %==========Calculo de q1============
    q1 = zeros(1,2);
    q1aux = atan2(pc(2),pc(1));
    q1(1) = q1aux;
    if q1aux < 0
        q1(2) = q1aux + pi;
    else
        q1(2) = q1aux - pi;
    end
    
    %=========Calculo de q2 y q3 (Posicion)============
    q2 = zeros(1,4);
    q3 = zeros(1,4);
    k = 1;
    
    for i = 1:2
        T1 = R.links(1).A(q1(i)).double;    %Matriz se T. Hom. 0T1
        pc1 = [T1(1:3,1:3)' -T1(1:3,1:3)'*T1(1:3,4);0,0,0,1]*pc; %Calculo la posicion del centro de la muñeca con respecto al sistema 1 para cada solucion de q1
    
        beta = atan2(pc1(2),pc1(1));
        r = sqrt(pc1(1)^2 + pc1(2)^2);
        L2 = R.links(2).a;  %longitud de eslabon 2
        theta = atan2(R.links(3).a,R.links(4).d);       %Como tenemos un codo fijo (a3=0.01 y d4=0.25)
        L3 = sqrt((R.links(4).d)^2 + (R.links(3).a)^2); %Eslabon 3 equivalente
        alfa = acos((L2^2 + r^2 - L3^2) / (2 * r * L2));
        
        %==Calculo de q2==
        q2(k) = beta - alfa;
        q2(k+1) = beta + alfa;
        
        %==Calculo de q3==
        for j = 0:1:1
            T2 = T1*R.links(2).A(q2(j+k)).double;
            pc21 = [T2(1:3,1:3)' -T2(1:3,1:3)'*T2(1:3,4);0,0,0,1] * pc;
            q3(j+k) = atan2(pc21(2),pc21(1)) + theta - pi/2;
        end
        k = k + 2;
    
    end
    k=1; %Reinicio valor de k para usarlo en el calculo del resto de las articulaciones
    
    %Matriz solucion para las primeras 3 articulaciones
    qq1 = zeros(6,8);
    qq1(1,:) = [q1(1) q1(1) q1(1) q1(1) q1(2) q1(2) q1(2) q1(2)]; 
    qq1(2,:) = [q2(1) q2(1) q2(2) q2(2) q2(3) q2(3) q2(4) q2(4)];
    qq1(3,:) = [q3(1) q3(1) q3(2) q3(2) q3(3) q3(3) q3(4) q3(4)];
    
    %========Calculo de q4,q5 y q6 (Orientacion)=======
    q4 = zeros(1,8);
    q5 = zeros(1,8);
    q6 = zeros(1,8);
    for i= 1:2:7
        T1 = R.links(1).A(qq1(1,i)).double;
        T2 = R.links(2).A(qq1(2,i)).double;
        T3 = R.links(3).A(qq1(3,i)).double;
        T36 = [T3(1:3,1:3)' -T3(1:3,1:3)'*T3(1:3,4);0,0,0,1]*[T2(1:3,1:3)' -T2(1:3,1:3)'*T2(1:3,4);0,0,0,1]*[T1(1:3,1:3)' -T1(1:3,1:3)'*T1(1:3,4);0,0,0,1]*T;
        
        if abs(T36(3,3) - 1) < comparador   %Esto se hace para cuando la articulacion 4 y 6 estan alineadas => habran infinitas combinaciones para mantener la orientacion deseada
            q4(k) = q(4);
            q5(k) = 0;
            q6(k) = atan2(T36(2,1),T36(1,1)-q4(1));
            q4(k+1) = q4(k);
            q5(k+1) = 0;
            q6(k+1) = q6(k);
        else
            q4(k)=atan2(T36(2,3),T36(1,3));
            if q4(k) > 0
                q4(k+1) = q4(k) - pi;
            else
                q4(k+1) = q4(k) + pi;
            end
        
            for j = 0:1:1
                T4 = R.links(4).A(q4(k+j)).double;
                T46 = [T4(1:3,1:3)' -T4(1:3,1:3)'*T4(1:3,4);0,0,0,1]*T36;
                q5(k+j) = atan2(T46(2,3),T46(1,3)) - pi/2;  %Calculo de q5
            
                T5 = R.links(5).A(q5(k+j)).double;
                T56 = [T5(1:3,1:3)' -T5(1:3,1:3)'*T5(1:3,4);0,0,0,1]*T46;
                q6(k+j) = atan2(T56(2,1),T56(1,1)); %Calculo de q6
            end
        end
    
        k = k+2;
    end
    
    qq1(4,:) = [q4(1) q4(2) q4(3) q4(4) q4(5) q4(6) q4(7) q4(8)]; 
    qq1(5,:) = [q5(1) q5(2) q5(3) q5(4) q5(5) q5(6) q5(7) q5(8)];
    qq1(6,:) = [q6(1) q6(2) q6(3) q6(4) q6(5) q6(6) q6(7) q6(8)];
    R.offset = Toffset;
    qq1 = qq1 - R.offset'*ones(1,8);    %Agrego offset a soluciones ya que no se tuvo en cuenta en los calculos
    
    if (q_mejor == 0)
        fprintf('Soluciones del sistema: \n');
        disp(qq1');
        figure(1)   %Figura para graficar todas las soluciones de a una
        for i = 1:8
            %qqsol(1,:) = qq1(:,i);
            R.plot(qq1(:,i)', 'scale', 1, 'jointdiam', 0.5);
            %R.plot3d(qq1','path',pwd,'scale',0.001,'nowrist')
            title('Grafico Cinematica Inversa');
            grid on;
            %view(45,0);
            %input('Presiona Enter para graficar la otra solucion');
            pause(3);
        end
    else    %Calculo distancia euclidiana entre vectores
        Qaux = qq1 - q0' * ones(1,8);   
        normas = zeros(1,8);
        for i=1:8
            normas(i) = norm(Qaux(:,i));
        end
        [~,pos] = min(normas);
        Q(1,:) = qq1(:, pos);
        fprintf('Soluciones del sistema: \n');
        qq1'
        fprintf('La solucion mas cercana es:\n');
        Q
        fprintf('Que se encuenta en la posicion: %.d\n', pos');
    
        figure(1)   %Figura para calcular la solucion mas cercana
        R.plot(Q, 'scale', 1, 'jointdiam', 0.5);
        title('Grafico Cinematica Inversa');
        grid on;
    end
end

%======Verificacion con metodo directo======
function cin_dir(qq1,q_mejor,Q)
    %===Importo robot===
    R = robot();
    Tbase = R.base.double;
    Ttool = R.tool.double;
    if q_mejor == 0
        q(1,:) = qq1(:,1);   %Tomo la primera solucion
    else
        q = Q;  %Compruebo para la solucion mas cercana
    end
    T = R.fkine(q).double;
    T = [Tbase(1:3,1:3)' -Tbase(1:3,1:3)'*Tbase(1:3,4);0,0,0,1] * T * [Ttool(1:3,1:3)' -Ttool(1:3,1:3)'*Ttool(1:3,4);0,0,0,1];
    Posicion = T(1:3,4)
    
    figure(2)
    R.plot(q,'scale', 1, 'jointdiam', 0.5);
    title('Grafico Cinematica Directa');
end