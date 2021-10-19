aggpath();
generate_references;
%% Parameters

g = 9.81;           %gravitational acceleration
zc = 0.8;            %CoM height
w = sqrt(g/zc);      

beta = 50;          %Cost function weight
Deltat = 0.0005;    %time constant

    
P = 1500;           %horizon


%decision variables where x are the CoM position (1) and velocity (2) and u
%is the position of the ZMP
x=sdpvar(2*ones(1,P+1),ones(1,P+1)); 
u=sdpvar(ones(1,P+1),ones(1,P+1));


%initial conditions
x{1}(1) = 0;
x{1}(2) = 0;
u{1} = 0;


%% Constraints
Constraints = [];

%constraints given by the dynamical model
for i = 1:P 

        Constraints=[Constraints;
            x{i+1}(1) == x{i}(1) + x{i}(2)*Deltat;
            x{i+1}(2) == x{i}(2) + w.^2*(x{i}(1)-u{i}) * Deltat;
            ];


end
 Constraints=[Constraints;x{P+1}(2) == 0];

%% Cost Function
Cost = 0;
for i=1:P
    %this cost function tends to track the zmp profile and brings the CoM
    %speed to zero
    Cost = Cost + (x{i}(2)).^2+beta*(u{i}-prefy(1,i)).^2;
end



% optimization procedure
options = sdpsettings('verbose',1);
Problem = optimize(Constraints, Cost,options);


% since the value return as a vector of cell and each cell contains the
% sqdvar first I transform the cells in vector and then I extract the
% values of the sqdvar with double()
valy = [x{:}];
valu = [u{:}];
valy_vect = double(valy(1,:));      %CoM position
valvy_vect = double(valy(2,:));      %CoM velocity
valuy_vect = double(valu);           %ZMP position




%% ---------------------------------PLOT-----------------------------------


%---------------------------------Space------------------------------------
% plot the CoM, ZMP and the ZMP_reference in the space domain
figure();
p1 = plot(prefx(2,1:P+1),valy_vect,'lineWidth',3)
hold on
p2 = plot(prefx(2,1:P+1),prefy(1,1:P+1),'lineWidth',3)
hold on 
p3 = plot(prefx(2,1:P+1),valuy_vect,'lineWidth',3);

hold on
plot(prefy(2,:),pminy(1,:));
hold on
plot(prefy(2,:),pmaxy(1,:));
patch([prefy(2,:) fliplr(prefy(2,:))], [pminy(1,:) fliplr(pmaxy(1,:))], 'g') %con flipr creao un area chiusa ato che inverte l'array
alpha(0.1) ;

legend([p1,p2,p3],'y','p_{ref}','p','Location','northwest');
grid();
title('ZMP and CoM profile')
xlabel('x[m]') 
ylabel('y[m]') 
ax = gca;
ax.FontSize = 10;
set(gcf, 'PaperPosition', [0 0 8 4]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [8 4]); %Set the paper to have width 5 and height 5.
saveas(gcf, 'opt_y_50_space', 'pdf') %Save figure



%plot the CoM velocity and the reference of CoM velocity in the space
%domain
figure()
plot(prefx(2,1:P+1),valvy_vect,'lineWidth',3);
hold on 
plot(prefx(2,1:P+1),zeros(1,1501),'lineWidth',3);
grid();

title('CoM speed profile')
legend('v','v_{ref}','Location','southeast');
xlabel('x[m]') 
ylabel('v_y[m/s]') 
ax = gca;
ax.FontSize = 10;
set(gcf, 'PaperPosition', [0 0 8 4]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [8 4]); %Set the paper to have width 5 and height 5.
saveas(gcf, 'opt_vy_50_space', 'pdf') %Save figure

%--------------------------------------------------------------------------


%---------------------------------Time------------------------------------


% plot the CoM, ZMP and the ZMP_reference in the time domain
figure();
plot(t,valy_vect,'lineWidth',3);
hold on
plot(t,prefy(1,1:P+1),'lineWidth',3)
hold on 
plot(t,valuy_vect,'lineWidth',3);
grid;
legend('x','p','p_{ref}','Location','northwest');
title('ZMP and CoM profile in time domain')
xlabel('t[s]') 
ylabel('x[m]') 
ax = gca;
ax.FontSize = 10;
% xlim([0,8.2])
% set(gcf, 'PaperPosition', [0 0 5 5]); %Position plot at left hand corner with width 5 and height 5.
% set(gcf, 'PaperSize', [5 5]); %Set the paper to have width 5 and height 5.
% saveas(gcf, '../report/plot/optimization/opt_x_150_time', 'pdf') %Save figure

%plot the CoM velocity and the reference of CoM velocity in the time
%domain
figure()
plot(t,valvy_vect,'lineWidth',3);
hold on 
plot(t,zeros(1,P+1),'lineWidth',3);
legend('v','v_{ref}');
title('CoM speed profile in time domain')
grid();
xlabel('t[s]') 
ylabel('v[m/s]') 
ax = gca;
ax.FontSize = 10;
% xlim([0,8.2])
% set(gcf, 'PaperPosition', [0 0 5 5]); %Position plot at left hand corner with width 5 and height 5.
% set(gcf, 'PaperSize', [5 5]); %Set the paper to have width 5 and height 5.
% saveas(gcf, '../report/plot/optimization/opt_vx_150_time', 'pdf') %Save figure
% %--------------------------------------------------------------------------


