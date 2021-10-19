function [qstar, info] = GNinvkin(initialq,rd,com)
tStart = tic;

%CoM x y position
xcom = com.x;
ycom = com.y;

%legs lenght
l1 = 0.41;
l2 = 0.41;

treshold_error = 0.00001; %treshold of the cartisian error to acept a solution

%initial guess
q0 = initialq;
q1 = q0(1);
q2 = q0(2);

%direct kinematic
fq = [l1*sin(q1)+l2*sin(q1+q2)+xcom, -l1*cos(q1)-l2*cos(q1+q2)+ycom]';

%jacobian from the base to the hell
J = [[l1*cos(q1)+l2*cos(q1+q2),l2*cos(q1+q2)];[l1*sin(q1)+l2*sin(q1+q2),l2*sin(q1+q2)];];

%error between the desired position and the actual position of the hell
err = rd-fq;

i = 0;
q = q0;


 while sqrt(err(1)^2+err(2)^2)>0.000001
  % disp(i);
   invjac = inv([[l1*cos(q1)+l2*cos(q1+q2),l2*cos(q1+q2)];[l1*sin(q1)+l2*sin(q1+q2),l2*sin(q1+q2)];]);       %compute the jacobian inverse
   q = q+invjac*err;                          %compute the new joint angle
   q1 = q(1);
   q2 = q(2);
   fq = [l1*sin(q1)+l2*sin(q1+q2)+xcom, -l1*cos(q1)-l2*cos(q1+q2)+ycom]';
   err = rd-fq;     %compute the error
    i = i + 1;
  
 end
 tEnd = toc(tStart);
 info.time = tEnd;
  info.iteration = i;
  info.error = sqrt(err(1)^2+err(2)^2);
 qstar = q; 
end




% function [qstar, info] = GNinvkin(initialq,rd,com)
% 
% syms q1 q2 real;
% 
% %CoM x y position
% xcom = com.x;
% ycom = com.y;
% 
% %legs lenght
% l1 = 0.41;
% l2 = 0.41;
% 
% treshold_error = 0.00001; %treshold of the cartisian error to acept a solution
% 
% %initial guess
% q0 = initialq;
% 
% %direct kinematic
% fq = [l1*sin(q1)+l2*sin(q1+q2)+xcom, -l1*cos(q1)-l2*cos(q1+q2)+ycom]';
% 
% %jacobian from the base to the hell
% J = [[l1*cos(q1)+l2*cos(q1+q2),l2*cos(q1+q2)];[l1*sin(q1)+l2*sin(q1+q2),l2*sin(q1+q2)];];
% 
% %error between the desired position and the actual position of the hell
% err = eval(rd-subs(fq,[q1,q2],[q0(1),q0(2)]));
% 
% i = 0;
% q = q0;
% 
% tStart = tic;
%  while sqrt(err(1)^2+err(2)^2)>0.000001
%    
%    invjac = inv(subs(J,[q1,q2],[q(1),q(2)]));       %compute the jacobian inverse
%    q = eval(q+invjac*err);                          %compute the new joint angle
%    err = eval(rd-subs(fq,[q1,q2],[q(1),q(2)]));     %compute the error
% 
%     i = i + 1;
%   
%  end
%  tEnd = toc(tStart);
%  info.time = tEnd;
%   info.iteration = i;
%   info.error = sqrt(err(1)^2+err(2)^2);
%  qstar = q; 
% end
