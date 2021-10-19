
aggpath;
%% Parameters

g = 9.81;           %gravitational acceleration
zc = 0.8;            %CoM height
w = sqrt(g/zc);      

beta = 50;          %Cost function weight

Deltax = 0.001;     %unit length used for quantization
epsilon = 0.005;    %velocity lower bound to avoid singularity
P = 300;           %horizon

%decision variables where x are the CoM position (1) and velocity (2) and u
%is the position of the ZMP
x=sdpvar(2*ones(1,P+1),ones(1,P+1)); 
u=sdpvar(ones(1,P+1),ones(1,P+1));


%initial conditions
x{1}(1) = 0;
x{1}(2) = epsilon;
u{1} = 0;


%% Constraints
Constraints = [];

%constraints given by the dynamical model
for i = 1:P 

        Constraints=[Constraints;
            x{i+1}(1) == x{i}(1)+Deltax;
            x{i+1}(2) == x{i}(2) + w.^2*(x{i}(1)-u{i}) * Deltax/x{i}(2);
            x{i}(2).^2>=epsilon.^2;];


end
%final CoM constraint
Constraints=[Constraints;x{P+1}(1) == prefx(1,P+1)];

%% Cost Function
Cost = 0;
for i=1:P
    Cost = Cost + (x{i}(2)-vref(1,i)).^2+beta*(u{i}-prefx(1,i)).^2;
end



% optimization procedure
options = sdpsettings('verbose',1);
Problem = optimize(Constraints, Cost,options);


% since the value return as a vector of cell and each cell contains the
% sqdvar first I transform the cells in vector and then I extract the
% values of the sqdvar with double()
valx = [x{:}];
valu = [u{:}];
valx_vect = double(valx(1,:));      %CoM position
valv_vect = double(valx(2,:));      %CoM velocity
valu_vect = double(valu);           %ZMP position


%space to time transformation 
t = zeros(1,P);
for i=1:P+1   
    t(i) = Deltax*sum(1./valv_vect(1:i-1));
end


%% ---------------------------------PLOT-----------------------------------


%---------------------------------Space------------------------------------
% plot the CoM, ZMP and the ZMP_reference in the space domain
figure();
plot(prefx(2,1:P+1),valx_vect,'lineWidth',3)
hold on
plot(prefx(2,1:P+1),prefx(1,1:P+1),'lineWidth',3)
hold on 
plot(prefx(2,1:P+1),valu_vect,'lineWidth',3);
grid();
legend('x','p_{ref}','p','Location','northwest');

title('ZMP and CoM profile')
xlabel('x[m]') 
ylabel('x[m]') 
ax = gca;
ax.FontSize = 10;
% set(gcf, 'PaperPosition', [0 0 5 5]); %Position plot at left hand corner with width 5 and height 5.
% set(gcf, 'PaperSize', [5 5]); %Set the paper to have width 5 and height 5.
% saveas(gcf, '../report/plot/optimization/opt_x_150_space', 'pdf') %Save figure



%plot the CoM velocity and the reference of CoM velocity in the space
%domain
figure()
plot(prefx(2,1:P+1),valv_vect,'lineWidth',3);
hold on 
plot(vref(2,1:P+1),vref(1,1:P+1),'lineWidth',3);
grid();

title('CoM speed profile')
legend('v','v_{ref}');
xlabel('x[m]') 
ylabel('v[m/s]') 
ax = gca;
ax.FontSize = 10;
% set(gcf, 'PaperPosition', [0 0 5 5]); %Position plot at left hand corner with width 5 and height 5.
% set(gcf, 'PaperSize', [5 5]); %Set the paper to have width 5 and height 5.
% saveas(gcf, '../report/plot/optimization/opt_vx_150_space', 'pdf') %Save figure

%--------------------------------------------------------------------------


%---------------------------------Time------------------------------------


% plot the CoM, ZMP and the ZMP_reference in the time domain
figure();
plot(t,valx_vect,'lineWidth',3);
hold on
plot(t,prefx(1,1:P+1),'lineWidth',3)
hold on 
plot(t,valu_vect,'lineWidth',3);
grid;
legend('x','p','p_{ref}','Location','northwest');
title('ZMP and CoM profile in time domain')
xlabel('t[s]') 
ylabel('x[m]') 
ax = gca;
ax.FontSize = 10;
xlim([0,8.2])
% set(gcf, 'PaperPosition', [0 0 5 5]); %Position plot at left hand corner with width 5 and height 5.
% set(gcf, 'PaperSize', [5 5]); %Set the paper to have width 5 and height 5.
% saveas(gcf, '../report/plot/optimization/opt_x_150_time', 'pdf') %Save figure

%plot the CoM velocity and the reference of CoM velocity in the time
%domain
figure()
plot(t,valv_vect,'lineWidth',3);
hold on 
plot(t,vref(1,1:P+1),'lineWidth',3);
legend('v','v_{ref}');
title('CoM speed profile in time domain')
grid();
xlabel('t[s]') 
ylabel('v[m/s]') 
ax = gca;
ax.FontSize = 10;
xlim([0,8.2])
% set(gcf, 'PaperPosition', [0 0 5 5]); %Position plot at left hand corner with width 5 and height 5.
% set(gcf, 'PaperSize', [5 5]); %Set the paper to have width 5 and height 5.
% saveas(gcf, '../report/plot/optimization/opt_vx_150_time', 'pdf') %Save figure
% %--------------------------------------------------------------------------


