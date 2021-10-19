%--------------------------------------------------------------------------
%DA MIGLIORARE il movimento del piede--------------------------------------
%--------------------------------------------------------------------------
clear all
close all

load('variables/CoMz_trajectory.mat');
load('variables/SQDsagittal_beta50.mat');
load('variables/foot_trajectory.mat');
load('variables/qstar.mat');
load('variables/LIP_coronal_optimization.mat');

writer = VideoWriter('biped_walking_10dof');
framerate = 20;
writer.FrameRate = framerate;
writer.Quality = 100;

%lenght covered by the robot
N = 1500; %[mm]

%regulate the simulation speed, if 1 the simulation uses all the joint
%values and the the simulation is sloewes if increase this value it uses
%one value on sim_speed sample. It can be only a natual value belong [1,N]
sim_speed = 5;


%0 --> default
%1 --> y,z
%2 --> -x,z
%3 --> x,z
view_type = 3;

% %joint valuse for the left foot
% qstarl = qstar(:,1:1000);
% qstarl = cat(2,qstarl,qstar(:,1:500));
% 
% %joint valuse for the right foot
% qstarr = qstar(:,500:1000);
% qstarr = cat(2,qstarr,qstar(:,1:1000));

%joint valuse for the left foot
qstarl = qstar(:,1:1500);

%joint valuse for the right foot
qstarr = qstar(:,500:1500);
qstarr = cat(2,qstarr,qstar(:,500:1000));

% figure()
% plot(qstarr')
% figure()
% plot(qstarl')

CoMx = (0:0.001:1.5);

open(writer);

for i=1:sim_speed:N
    
    hold off %comment to generate the plot sequence
%    
    alpha = 1;
    
    %levare commento se si vuole vedere la sequenza di passi come figura 2
    %del paper
%     alpha = 0.2;
%     if i-1==200 || i-1 == 700 
%      alpha =1;
%     end

    
     com.x = CoMx(i+1);
        com.y = valy_vect(i+1);
        com.z = CoMz_trajectory.Data(i+1);

     moveLeg6DOF3D(qstarl(:,i), com,'r',alpha); %left leg
     hold on
     moveLeg6DOF3D(qstarr(:,i), com,'b',alpha); %right leg
    
   
   %-----------------------LIP-----------------------------------
%    levale i commmenti per plottare anche il LIP 
  % plot3([valx_vect(i) valu_vect(i)],[com.y -valy_vect(i)],[com.z 0],'k','lineWidth',3);
   %--------------------------------------------------------------
    
   
    %draw the road
    hold on
    plot3([-2 2],[0.15 0.15],[0 0],'k');
    hold on 
    plot3([-2 2],[-0.15 -0.15],[0 0],'k');
    patch([[-2 2] fliplr([-2 2])], [[0.15 0.15] fliplr([-0.15 -0.15])], 'g')
    %--
    
    %modify the plot view angle
    switch view_type
        case 1
           view(90,0); %y,z
        case 2
           view(180,0); %-x,z
        case 3
            view(0,0); %x,z
        case 4
            view(-105,45);
    end
    
    grid();
    drawnow
    
%     currentFrame = getframe(gcf); %gfc-->get the current figuure
%     writeVideo(writer,currentFrame.cdata);



end

close(writer);

% ax = gca;
% ax.FontSize = 10;
% title('Kinematic Biped Walking 12 DoF')
% set(gcf, 'PaperPosition', [0 0 5 5]); %Position plot at left hand corner with width 5 and height 5.
% set(gcf, 'PaperSize', [5 5]); %Set the paper to have width 5 and height 5.
% saveas(gcf, 'biped_walking12dof', 'pdf') %Save figure

