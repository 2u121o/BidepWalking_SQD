close all;

%%parameters
Deltax = 0.001;         %unit length used for quantization
foot_width = 0.3;       %foot width intended as x
foot_height = 0.15;     %foot height intended as y



%%generate the zmp_reference along the sagittal axis
%array composed by 2 arrays, in the first position there are the values of
%the zmp reference and in the second position there are the values of the
%hip position
prefx = zeros(2,1500);


j = 1

for i = 0:Deltax:1.5   
     j =j+1;
     prefx(2,j) = i;
    if i<0.2
        prefx(1,j) = 0;
    elseif i>=0.2 && i<0.3
            prefx(1,j) = prefx(1,j-1)+0.005;
    elseif i>=0.3 && i<0.7
            prefx(1,j) = 0.5;
    elseif i>=0.7 && i<0.8
            prefx(1,j) = prefx(1,j-1)+0.005;
    elseif i>=0.8 && i<1.2
            prefx(1,j) = 1;
    elseif i>=1.2 && i<1.3
        prefx(1,j) = prefx(1,j-1)+0.005;
    else 
        prefx(1,j) = 1.5;
    end
end


%%generate the support polygon along the saggittal axis
%pmin and pmax contain the boundary of the support polygon
pminx = zeros(2,1500);
pmaxx = zeros(2,1500);
j = 1
for i = 0:0.001:1.5
    
     j =j+1;
     pminx(2,j) = i;
     pmaxx(2,j) = i;
     
     %compute the upper bound
     if i<0.2
        pmaxx(1,j) = foot_width/2;       
     elseif i<0.7
        pmaxx(1,j) = prefx(1,700)+foot_width/2;
     elseif i<1.2
         pmaxx(1,j) = prefx(1,1200)+foot_width/2;
     elseif i<1.5
         pmaxx(1,j) = prefx(1,1500)+foot_width/2;
     end 
     
     %compute the lower bound
      if i<0.3    
        pminx(1,j) = -foot_width/2;
     elseif i<0.8
        pminx(1,j) = prefx(1,700)-foot_width/2;
     elseif i<1.3
         pminx(1,j) = prefx(1,1200)-foot_width/2;
     elseif i<1.5
         pminx(1,j) = prefx(1,1500)-foot_width/2;
      end 
   
end



%%generate the zmp reference along the coronal axis, the code is
%%equivalent to the previous one used for the zmp along the saggittal axis
prefy = zeros(2,1500);
j = 1
for i = 0:0.001:1.5
    
     j =j+1;
     prefy(2,j) = i;
    if i<0.23
        prefy(1,j) = -0.1;
    elseif i>=0.23 && i<0.269
            prefy(1,j) = prefy(1,j-1)+0.005;
    elseif i>=0.269 && i<0.73
            prefy(1,j) = 0.1;
    elseif i>=0.73 && i<0.77
            prefy(1,j) = prefy(1,j-1)-0.005;
    elseif i>=0.77 && i<1.23
            prefy(1,j) = -0.1;
    elseif i>=1.23 && i<1.27
        prefy(1,j) = prefy(1,j-1)+0.005;
    else 
        prefy(1,j-1) = 0.1;
    end
end
% prefy(1,1) = -0.1;
% prefy(1,j) = 0.1;


%%generate the support polygon along the coronal axis
pminy = zeros(2,1500);
pmaxy = zeros(2,1500);


j = 1
for i = 0:0.001:1.5
    
     j =j+1;
     pminy(2,j) = i;
     pmaxy(2,j) = i;
     
     %compute the upper bound
     if i<0.1
        pmaxy(1,j) = foot_height/2;
     elseif i<0.2
        pmaxy(1,j) = -0.1+foot_height/2;
     elseif i<0.8
        pmaxy(1,j) = 0.1+foot_height/2;
     elseif i<1.2
         pmaxy(1,j) = -0.1+foot_height/2;
     elseif i<1.5
         pmaxy(1,j) = 0.1+foot_height/2;  
     end 
      
      %compute the lower bound
      if j>0 && i<0.3
        pminy(1,j) = -0.1-foot_height/2; 
     elseif i<0.7 
        pminy(1,j) = 0.1-foot_height/2;
     elseif i<1.3  
         pminy(1,j) = -0.1-foot_height/2;
     elseif i<1.4  
         pminy(1,j) = 0.1-foot_height/2;
      elseif i<1.5
         pminy(1,j) = -foot_height/2;
      end    
end



% generate the CoM velocity reference along the x axis 
vref = zeros(2,1500);
j = 1
for i = 0:0.001:1.5
    
     j =j+1;
     vref(2,j) = i;
    if i<0.25
        vref(1,j) = vref(1,j-1)+0.002;
    elseif i>=0.25 && i<1.25
            vref(1,j) = 0.5;
    else
            vref(1,j) = vref(1,j-1)-0.002;
    
    end
end

%% ---------------------------------PLOT-----------------------------------



% saggital zmp and the respective support polygon
figure()
p1 = plot(prefx(2,:),prefx(1,:), 'lineWidth',3, 'color', 'k');
hold on 
plot(prefx(2,:),pminx(1,:));
hold on
plot(prefx(2,:),pmaxx(1,:));
p2 = patch([prefx(2,:) fliplr(prefx(2,:))], [pminx(1,:) fliplr(pmaxx(1,:))], 'g') 
alpha(0.1) ;
grid();
legend([p1,p2],'ZMP_{xref}','SP_x','Location','northwest');
title('SP and ZMP along sagittal axis')
xlabel('x[m]') 
ylabel('x[m]') 
ax = gca;
ax.FontSize = 10;

% set(gcf, 'PaperPosition', [0 0 5 5]); %Position plot at left hand corner with width 5 and height 5.
% set(gcf, 'PaperSize', [5 5]); %Set the paper to have width 5 and height 5.
% saveas(gcf, '../report/plot/optimization/SPx', 'pdf') %Save figure



% coronal zmp and the respective support polygon 
figure()
p1 = plot(prefy(2,:),prefy(1,:), 'lineWidth',3,'color','k');
hold on 
plot(prefy(2,:),pminy(1,:));
hold on
plot(prefy(2,:),pmaxy(1,:));
p2 = patch([prefy(2,:) fliplr(prefy(2,:))], [pminy(1,:) fliplr(pmaxy(1,:))], 'g') %con flipr creao un area chiusa ato che inverte l'array
alpha(0.1) ;
grid();
legend([p1,p2],'ZMP_{yref}','SP_y');
title('SP and ZMP along coronal axis')
xlabel('x[m]') 
ylabel('y[m]') 
ax = gca;
ax.FontSize = 10;
% set(gcf, 'PaperPosition', [0 0 5 5]); %Position plot at left hand corner with width 5 and height 5.
% set(gcf, 'PaperSize', [5 5]); %Set the paper to have width 5 and height 5.
% saveas(gcf, '../report/plot/optimization/SPy', 'pdf') %Save figure



% plot the CoM velocity reference
figure();
plot(prefy(2,:), vref(1,:));
legend('vref');
grid();

% plot the robot steps on the xy plane

%steps central position, the matrix has as many rows as the number of the
%steps and two columns that are x and y position
foot_position = [0 0.1;
                 0 -0.1;
                 0.5 0.1;
                  1    -0.1;
                  1.5 0.1;
                  1.5 -0.1];

figure('Renderer', 'painters', 'Position', [0 0 1800 650])

% plot 6 steps
for i = 1:6
    xCenter = foot_position(i,1); 
    yCenter = foot_position(i,2); 
    xLeft = xCenter - foot_width/2;
    yBottom = yCenter - foot_height/2;
    rectangle('Position', [xLeft, yBottom, foot_width, foot_height], 'EdgeColor', 'r',  'LineWidth', 2);
    hold on;
    
end

xlim([-0.3, 2]);
ylim([-0.5, 0.5]);
grid on;

title('Planned Footsteps')
xlabel('x[m]') 
ylabel('y[m]') 

ax = gca;
ax.FontSize = 10;
% set(gcf, 'PaperPosition', [0 0 10 5]); %Position plot at left hand corner with width 5 and height 5.
% set(gcf, 'PaperSize', [10 5]); %Set the paper to have width 5 and height 5.
% saveas(gcf, '../report/plot/optimization/footsteps', 'pdf') %Save figure



