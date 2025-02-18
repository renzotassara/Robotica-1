syms q1 q2 q3 a1 a2 a3 real;
q = [q1 q2 q3];
dh = [0,0,a1,0,1;
      0,0,a2,0,0;
      0,0,a3,0,0];
R = SerialLink(dh);
J = simplify(R.jacob0(q)); 
disp(J)
