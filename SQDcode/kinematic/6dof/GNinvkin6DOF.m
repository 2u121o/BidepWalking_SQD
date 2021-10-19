function [qstar, info] = GNinvkin6DOF(initialq,rd,com)
%syms q1 q2 q3 q4 q5 q6  real
tStart = tic;
%CoM x y position
comx = com.x;
comy = com.y;
comz = com.z;

%DhH parameters
a1 = 0.1;
d1 = 0.02;
a3 = 0;
a4 = 0.39;
a5 = 0.41;

%inverse kinematics parameter
alpha = 0.08;

%initial guess
q0 = initialq;

q2 = q0(2);
q3 = q0(3);
q4 = q0(4);
q5 = q0(5);

%direct kinematic
fq = [comx + cos(q2)*(a5*sin(q4 + q5) + a4*sin(q4)) + sin(q2)*sin(q3)*(a5*cos(q4 + q5) - a3 + a4*cos(q4)),... 
      comy - a1 - sin(q2)*(a5*sin(q4 + q5) + a4*sin(q4)) + cos(q2)*sin(q3)*(a5*cos(q4 + q5) - a3 + a4*cos(q4)),...
      comz - d1 - cos(q3)*(a5*cos(q4 + q5) - a3 + a4*cos(q4))]';
err = rd-fq;

i = 0;
q = q0;



 while sqrt(err(1)^2+err(2)^2+err(3)^2)>0.001
     
    Jeval = [[0,   cos(q2)*sin(q3)*(a5*cos(q4 + q5) - a3 + a4*cos(q4)) - sin(q2)*(a5*sin(q4 + q5) + a4*sin(q4)),...
             cos(q3)*sin(q2)*(a5*cos(q4 + q5) - a3 + a4*cos(q4)),   ...
             cos(q2)*(a5*cos(q4 + q5) + a4*cos(q4)) - sin(q2)*sin(q3)*(a5*sin(q4 + q5) + a4*sin(q4)), ...
             a5*cos(q4 + q5)*cos(q2) - a5*sin(q4 + q5)*sin(q2)*sin(q3)];...
             
             [0, - cos(q2)*(a5*sin(q4 + q5) + a4*sin(q4)) - sin(q2)*sin(q3)*(a5*cos(q4 + q5) - a3 + a4*cos(q4)),...
             cos(q2)*cos(q3)*(a5*cos(q4 + q5) - a3 + a4*cos(q4)),...
             - sin(q2)*(a5*cos(q4 + q5) + a4*cos(q4)) - cos(q2)*sin(q3)*(a5*sin(q4 + q5) + a4*sin(q4)),...
             - a5*cos(q4 + q5)*sin(q2) - a5*sin(q4 + q5)*cos(q2)*sin(q3)];
             [0, 0, sin(q3)*(a5*cos(q4 + q5) - a3 + a4*cos(q4)), cos(q3)*(a5*sin(q4 + q5) + a4*sin(q4)),  a5*sin(q4 + q5)*cos(q3)];];
         

    pinvJ = pinv(Jeval);
    q = q+alpha*pinvJ*err;
    
    q2 = q(2);
    q3 = q(3);
    q4 = q(4);
    q5 = q(5);
    
  
  
  fq = [comx + cos(q2)*(a5*sin(q4 + q5) + a4*sin(q4)) + sin(q2)*sin(q3)*(a5*cos(q4 + q5) - a3 + a4*cos(q4)),... 
      comy - a1 - sin(q2)*(a5*sin(q4 + q5) + a4*sin(q4)) + cos(q2)*sin(q3)*(a5*cos(q4 + q5) - a3 + a4*cos(q4)),...
      comz - d1 - cos(q3)*(a5*cos(q4 + q5) - a3 + a4*cos(q4))]';

    err = rd-fq;
    i = i + 1;

 end
 tEnd = toc(tStart);
 info.time = tEnd;
  info.iteration = i;
  info.error = err(1)^2+err(2)^2+err(3)^2;
  
 qstar = q; 
end
