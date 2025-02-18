
dh = [
       0    0.22135   0.200     0    0;
       0	0.02975	  0.250	    0	 0;
       0	0.3623	  0.000	    0	 1;
       0    -0.3998    0.000    pi    0];   


R = SerialLink(dh,'name','SCARA IRB 910sc','manufacturer','ABB');
q = [0,0,0.180,0];

R.qlim(1,1:2) = [-120, 120]*pi/180;
R.qlim(2,1:2) = [-120, 120]*pi/180;
R.qlim(3,1:2) = [0, 0.180];
R.qlim(4,1:2) = [-120, 120]*pi/180;


R.offset = [0; 0; 0.180; 0];


R.plot(q,'scale',0.2,'trail',{'r', 'LineWidth', 2});
R.teach()