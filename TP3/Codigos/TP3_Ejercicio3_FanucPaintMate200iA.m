dh = [
       0    0.450    0.075    pi/2    0;
       0	0.000 	 0.300	     0	  0;
       0	0.000	 0.075	  pi/2	  0;
       0	0.225	 0.000	 -pi/2 	  0;
       0    0.000    0.000    pi/2    0];
       %0    0.000    0.080    pi/2    0];


R = SerialLink(dh,'name','Paint Mate 200iA/5L','manufacturer','Fanuc');
q = [0,0,0,0,0];

R.qlim(1,1:2) = [-120, 120]*pi/180;
R.qlim(2,1:2) = [-120, 120]*pi/180;
R.qlim(3,1:2) = [-120, 120]*pi/180;
R.qlim(4,1:2) = [-120, 120]*pi/180;
R.qlim(5,1:2) = [-120, 120]*pi/180;
%R.qlim(6,1:2) = [-120, 120]*pi/180;

R.tool = transl(0,0,0.08);
%R.offset = [0.22895; 0; -0.100; 0];


R.plot(q,'scale',0.8,'trail',{'r', 'LineWidth', 2});
R.teach()