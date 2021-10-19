clear all

load('variables/CoMz_trajectory.mat');
load('variables/SQDsagittal_beta50.mat');
load('variables/foot_trajectory.mat');
load('variables/LIP_coronal_optimization.mat');


%inizialize the vector of the joints values [q1 q2 q3]'
qstar = zeros(6,1500);
qstarl = zeros(6,1500);

%initial values
q0 = [-0.01  -0.01 -0.01 -0.01 -0.01 ]';

%thanks to the iscretization we know that the x position of the
%com evolve as x=Deltax*i
CoMx = (0:0.001:1.5);

%true if in debug phases otherwise flase
debug = true;

%initialize the desired position vector
rd = zeros(3,1501);

%compute the walking cycle of one step of a leg that can be used to
%generate the walking composed by more then one step
step_distance = 0;
srep_stride = 1;
n_steps = 0;
for j=1:1500
        
    
    
         if mod(j,1000) ~= 0
            i = mod(j,1000)+1;
         else
             i=1;
             n_steps = n_steps+1;
             step_distance = srep_stride*n_steps;
             
         end
        %during the first SS
        if i<200 
            xfoot = step_distance;
            zfoot = 0;
            
            xtoe = 0.15+step_distance;
            ztoe = 0;
            q6 = -10000;
          
        %during the first DS
        elseif i>=200 && i<300
            xfoot = foot_trajectory.Time((i+1)*2-200*2)+step_distance;
            zfoot = foot_trajectory.Data((i+1)*2-200*2);

            xtoe = 0.15+step_distance;
            ztoe = 0;
            
            a = zfoot-ztoe;
            b = xfoot-xtoe;
            
            q6 = atan2(b,a);
           
        %during the second SS  
        elseif i>=300 && i<700
            
            xfoot = foot_trajectory.Time((i+1)*2-200*2)+step_distance;
            zfoot = foot_trajectory.Data((i+1)*2-200*2);
            
            xtoe = foot_trajectory.Time((i+1)*2-300*2)+0.15+step_distance;
            ztoe = foot_trajectory.Data((i+1)*2-300*2);
            
            a = zfoot-ztoe;
            b = xfoot-xtoe;
            
            q6 = -atan2(b,a);
            
            %joint bound
            if q6>=1.8
                q6 = 1.8;
            elseif q6<=-1.8
                q6=-1.8;
            end
        %during the second DS     
        elseif i>=700 && i<800
            xfoot = 1+step_distance;
            zfoot = 0;
            q6 = -10000;

            xtoe = foot_trajectory.Time((i+1)*2-300*2)+0.35+step_distance;
            ztoe = foot_trajectory.Data((i+1)*2-300*2);
            
            a = zfoot-ztoe;
            b = xfoot-xtoe;
            
            q6 = atan2(b,a);
          %during the third SS
          elseif i>=800 && i<=1000
            xfoot = 1+step_distance;
            zfoot = 0;
            q6 = -10000;

            xtoe = 1.15+step_distance;
            ztoe = 0;
            
            a = zfoot-ztoe;
            b = xfoot-xtoe;
            
            q6 = atan2(b,a);
            
        
        end
        
        %compute the ankle angle, using simple trigonometry by considering
        %the two trajecories of the hell annd the toe
           
       
        %_____________________rimuovere___________________________________%
        %%%%%%this avoid that if the trajecotry is badly drawn,
        %%%%%%the leg stucks
        
        dist_COM_hell = sqrt((xfoot-CoMz_trajectory.Time(j+1)).^2+(zfoot-CoMz_trajectory.Data(j+1)).^2+(-0.1+valy_vect(j+1)).^2);
        while dist_COM_hell >0.82
            zfoot = zfoot+0.00001;
            dist_COM_hell = sqrt((xfoot-CoMz_trajectory.Time(j+1)).^2+(zfoot-CoMz_trajectory.Data(j+1)).^2+(-0.1+valy_vect(j+1)).^2);
           
           
        end
        
% % % % % % % % % % %         dist_COM_hell_l = sqrt((xfoot-CoMz_trajectory.Time(j+1)).^2+(zfoot-CoMz_trajectory.Data(j+1)).^2+(0.1+valy_vect(j+1)).^2);
% % % % % % % % % % %         while dist_COM_hell_l >0.82
% % % % % % % % % % %             zfoot_l = zfoot_l+0.00001;
% % % % % % % % % % %             dist_COM_hell_l = sqrt((xfoot-CoMz_trajectory.Time(j+1)).^2+(zfoot-CoMz_trajectory.Data(j+1)).^2+(0.1+valy_vect(j+1)).^2);
% % % % % % % % % % %            
% % % % % % % % % % %            
% % % % % % % % % % %         end
        %%%%%%%%%%%
        %%%%%%%%%%%
        %_________________________________________________________________%
        
        
       
       % com.x = CoMq6z_trajectory.Time(j+1)*(n_steps+1)
        com.x = CoMx(j+1);
        com.y = valy_vect(j+1);
        com.z = CoMz_trajectory.Data(j+1);
        
        %tStart = tic;
        %compute the inverse kinematic 
        %dist_COM_hell = sqrt((xfoot-com.x).^2+(zfoot-com.y).^2);
       
        rd(:,j) = [xfoot,-0.1,zfoot]';
        [q0, info] = GNinvkin6DOF(q0,[xfoot,-0.1,zfoot]',com);
       
% % % % % % % % % % % % % %         %rdl(:,j) = [xfoot,-0.1,zfoot]';
% % % % % % % % % % % % % %         [q0l, infol] = GNinvkin6DOF(q0,[xfoot,0.1,zfoot_l]',com);
       
        %q0 = LMinvkin(q0',[xfoot,zfoot]',com);
        %tEnd = toc(tStart)
        
        
        %generates an array of times of each operation
        array_times(j) = info.time;
        array_iterations(j) = info.iteration;
        array_errors(j) = info.error;
        
        %average time,iteration,error
        avg_time =  sum(array_times(2:end))/(length(array_times(2:end)));
        avg_iteration = sum(array_iterations(2:end))/(length(array_iterations(2:end)));
        avg_error = sum(array_errors(2:end))/(length(array_errors(2:end)));
        
        %max time,iteration,error
        max_time = max(array_times(2:end));
        max_iteration = max(array_iterations(2:end));
        max_error = max(array_errors(2:end));
        
        %min time, iteration, error
        min_time = min(array_times(2:end));
        min_iteration = min(array_iterations(2:end));
        min_error = min(array_errors(2:end));
   
        qstar(1,j) = q0(1);
        qstar(2,j) = q0(2);
        qstar(3,j) = q0(3);
        qstar(4,j) = q0(4);
        qstar(5,j) = q0(5);
        
% % % % % % % %         qstarl(1,j) = q0l(1);
% % % % % % % %         qstarl(2,j) = q0l(2);
% % % % % % % %         qstarl(3,j) = q0l(3);
% % % % % % % %         qstarl(4,j) = q0l(4);
% % % % % % % %         qstarl(5,j) = q0l(5);
        
       
        %can be avoide if set properly the values of q3
        if q6 == -10000
            q6=-q0(4)-q0(5);
            
        else
            q6 = 0;
            
        end
        
        qstar(6,j) = q6;
% % % % % % % % %         qstarl(6,j) = q6;
        
        
      
        if debug == true 
            
             moveLeg6DOF3D(qstar(:,j)',com,'r',1); 
             hold on
             plot3(CoMx(:),valy_vect(:),CoMz_trajectory.Data(1:1501));
             
             hold off
        end
        
        
         
         view(90,0);
    
         drawnow;
end


disp('-------Time-------')
    fprintf('max_time --> %e\n',max_time);
    fprintf('min_time --> %e\n',min_time);
    fprintf('avg_time --> %e\n',avg_time);
    disp('-------iteration-------')
    fprintf('max_iteration --> %e\n',max_iteration);
    fprintf('min_iteration --> %e\n',min_iteration);
    fprintf('avg_iteration --> %e\n',avg_iteration);
    disp('-------errror-------')  
    fprintf('max_error --> %e\n',max_error);
    fprintf('min_error --> %e\n',min_error);
    fprintf('avg_error --> %e\n',avg_error);


