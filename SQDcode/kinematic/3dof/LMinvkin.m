function [qstar,info] = LMinvkin(initialq, rd,com)

% initialq = [1.5 1.8];
% rd = [0,0]';
% com = [0 0.82];
% 
xcom = com.x;
ycom = com.y;


syms q1 q2 real;


% inverse kinematic 2R planar Newton method

l1 = 0.41;
l2 = 0.41;

We = diag([1 1]);
%Wn = diag([0.001 0.001]);


%rd = [0.4,1.2]';

%initial guess
q0 = initialq';


%direct kinematic
fq = [l1*sin(q1)+l2*sin(q1+q2)+xcom, -l1*cos(q1)-l2*cos(q1+q2)+ycom]';

J = [[l1*cos(q1)+l2*cos(q1+q2),l2*cos(q1+q2)];[l1*sin(q1)+l2*sin(q1+q2),l2*sin(q1+q2)];];

err = eval(rd-subs(fq,[q1,q2],[q0(1),q0(2)]));

i = 2;
wn1 = 0.001;
wn2 = 0.001;

Wn = 0.5*err'*We*err*eye(2)+diag([wn1 wn2]); 
%Wn = diag([0.5 0.5]);

q = q0;

% Jeval = subs(J,[q1,q2],[q(1),q(2)]);
% S = svd(Jeval);
% mu =1/S(end);
% Wn = mu*eye(2);
% 


array_q(:,1) = initialq;
array_err(1) = sqrt(err(1)^2+err(2)^2);


%while ( err(2)>0.01|err(2)<-0.01)|(err(1)>0.01|err(1)<-0.01)

 while sqrt(err(1)^2+err(2)^2)>0.001  

   
   %qui dovrei sostituire il nuovo metodo perch' ho il problea della
   %singolarità
   %inversa =double(inv(subs(J,[q1,q2],[q(1),q(2)])))
   
   Jeval = subs(J,[q1,q2],[q(1),q(2)]);
   H = Jeval'*We*Jeval+Wn;
   gk = Jeval'*We*err;
   q = eval(q+inv(H)*gk);
   err = eval(rd-subs(fq,[q1,q2],[q(1),q(2)]));
   Wn = 0.5*err'*We*err*eye(2)+diag([wn1 wn2]); 
   
   %Wn = diag([0.5 0.5]);
%    S = svd(Jeval);
%    mu = 1/S(end).^2;
%    Wn = mu*eye(2);
%    array_q(:,i) = q; 
%    array_err(i) = sqrt(err(1)^2+err(2)^2);
%    
 
   
   i = i + 1;
   if i>= 500
       break;
   end
   
 end
%     info.plot = p;
%   info.iteration = i;
%  info.final_error = sqrt(err(1)^2+err(2)^2);
 qstar = q;

end