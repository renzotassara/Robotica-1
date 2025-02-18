close, clear
syms q1 q2 q3 a1 a2 a3 real; %Inicialización de variables simbólicas

fprintf('\nMatriz simbólica TD\n'); %Matriz simbolica objetivo, es la matriz
n = sym('n',[3 1]);                 % de Transformación lineal homogenea
o = sym('o',[3 1]);                 % dada por los datos x, y, gamma
a = sym('a',[3 1]);
p = sym('p',[3 1]);

TD = [n o a p];
TD(4,:) = [0 0 0 1];
TD

fprintf('\nRobot mediante DH simbólico\n');
DH = [0   0  a1  0  1;
      0  0  a2  0  0;
      0  0  a3  0  0];

R = SerialLink(DH)

fprintf('\nMatrices de transormación homogénea');
T10 = R.links(1).A(q1).double
T21 = R.links(2).A(q2).double
T32 = R.links(3).A(q3).double

fprintf('\nMatriz de cinemática directa mediante producto\n');
T03 = simplify(T10*T21*T32)

fprintf('\nEcuación TD = T10*T21*T31\n');
[(1:16)', TD(:), T03(:)]

fprintf('\nPremultiplicando por inv(T10) e inv(T21) se despeja T32\n')
T12 = [T21(1:3,1:3)' -T21(1:3,1:3)'*T21(1:3,4);0 0 0 1];
T01 = [T10(1:3,1:3)' -T10(1:3,1:3)'*T10(1:3,4);0 0 0 1];
T32_calc = simplify(T12*T01*TD);
[(1:16)', T32_calc(:), T32(:)]

fprintf('\n>Ec 15\n');
ec_15 = T32_calc(15) == T32(15)
q1_sol = solve(ec_15,q1)

fprintf('\n>Ec 13\n');
ec_13 = T32_calc(13) == T32(13)
ec_13 = isolate(ec_13,'p1*cos(q2) - a1*cos(q2) + p2*sin(q2)')

fprintf('\n>Ec 14\n');
ec_14 = T32_calc(14) == T32(14)

fprintf('\nElevando ecuación 13 y 14 al cuadrado y sumando:\n');
ec_13 = simplify(ec_13^2);
ec_14 = simplify(ec_14^2);
ec_aux = simplify(ec_13+ec_14)
fprintf('\nSe resuelve para q3\n');
q3_sol = isolate(ec_aux,cos(q3))


fprintf('\nPremultiplicando por inv(T10) y postmultiplicando por inv(T32) se despeja T21\n');
T23 = [T32(1:3,1:3)' -T32(1:3,1:3)'*T32(1:3,4);0 0 0 1];
T21_calc = simplify(T01*TD*T23);
[(1:16)', T21_calc(:), T21(:)]

fprintf('\n>Ec 13\n');
ec_13 = T21_calc(13) == T21(13)
q2_sol = isolate(ec_13,cos(q2))

fprintf('\n>Resumen\n');
q1_sol
q2_sol
q3_sol

