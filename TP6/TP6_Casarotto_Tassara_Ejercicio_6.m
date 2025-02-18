%% Inicialización de Robot
R = robot();
fprintf("############   INICIALIZANDO ROBOT   ############\n\n");
R
anulaciones = 0;
fprintf("-----------------------------------------------------------------\n");
fprintf("\n>>Probando q5=0\n");
for i=1:10000
   % Se actualiza la semilla de randomización para asegurar la no
   % repetición del ciclo
   rng('shuffle');
   
   % Generación aleatoria de q = [q1,..., q6] con valores entre -pi y +pi
   q = -pi + (2*pi)*rand(1,6);
   % Forzando q5 = 0
   q(5) = 0;
   
   J = R.jacob0(q);
   
   detJ = det(J);
   % El determinante puede ser negativo y comparar con 0 absoluto es
   % demasiado restrictivo numericamente. Por eso se trabaja con el valor
   % absoluto del determinante y la precisión de punto flotante eps
   if (abs(detJ) <= eps)
       anulaciones = anulaciones + 1;
   end   
end

fprintf("\nEl determinante del Jacobiano se 'anulo' en ");
fprintf("%d posiciones de\nlas 10000 probadas",anulaciones);
fprintf(" con q5 = 0.\n");


%% Prueba de coordenadas con q2 = asen(L3/L2) y q3 = -q2-90  (Ejes 0 y 4 //)
anulaciones = 0;
fprintf("\n-----------------------------------------------------------------\n");
fprintf("\n>>Probando ejes 0 y 4 paralelos\n\n");
L2 = R.links(2).a;
L3 = R.links(3).a;
for i=1:10000
   rng('shuffle');
   
   q = -pi + (2*pi)*rand(1,6);
   % Para está alineación se requiere que L2.sen(q2) = L3, de esta manera
   % la proyeccion horizontal(xy) de L2 se opone a la de L3 cuando está 
   % última es perpendicular al eje z0. Se despeja el valor de q2 en
   % función de L2 y L3, y L3 debe ser -q2 para ponerse vertical +- 90°para
   % que quede perpendicular a z0. Como se debe anular la proyección en el 
   % plano xy, a valores positivos de q2, le corresponden valores negativos
   % de q3, y viceversa.
   if (i <= 5000)
       q(2) = asin(L3/L2);
       q(3) = -q(2) - pi/2;
   else
       q(2) = -asin(L3/L2);
       q(3) = -q(2) + pi/2;
   end
   J = R.jacob0(q);
   
   detJ = det(J);
   if (abs(detJ) <= eps)
       anulaciones = anulaciones + 1;
   end   
end

fprintf("El determinante del Jacobiano se 'anulo' en");
fprintf(" %d posiciones\nde las 10000 probadas",anulaciones);
fprintf(" con q2 = 2.5473° y q3 = -92.473°,\n");
fprintf("o bien, q2 = -2.5473 y q3 = 92.5473\n\n");


%% Fin
fprintf("####  Fin de verificación de singularidades  ####\n");
