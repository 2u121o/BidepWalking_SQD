%this function can be easly optimized
function p = forward_kin(frame_i,frame_f)
syms q1 q2 q3 q4 q5 q6 a1 a2 a3 a4 a5 a6 d1 comx comy comz ac dc real


%transformation between the matlab fram and the CoM fram
T_wc = [[-1 0 0  comx];[0 1 0 comy];[0 0 -1 comz];[0 0 0 1]];

%DH table
DH = [[0 a1 d1 -pi/2];[pi/2 0 0 q2];[-pi/2 a3  0 -pi/2+q3];[0 -a4 0 q4];[0 -a5 0 q5];[0 a6 0 -pi/2+q6];];

[rows, cols] = size(DH);

for i=1:1:rows
    A = newCoord(DH(i,:));    
    if i==1
        T = A;
        arrayA = A;
    else
        T = T*A;
        arrayA = cat(1,arrayA,A);
    end 
    
end

% disp("bTe = ");
%bTe = simplify(T);
% disp(bTe);

p = forward_kinematic(arrayA, [frame_i,frame_f]);
p = simplify(T_wc*p);
end

function A = newCoord(R)

A = [[cos(R(4)),  -sin(R(4))*cos(R(1)),  sin(R(4))*sin(R(1)),  R(2)*cos(R(4))];
     [sin(R(4)),  cos(R(4))*cos(R(1)),   -cos(R(4))*sin(R(1)), R(2)*sin(R(4))];
     [0,          sin(R(1)),             cos(R(1)),            R(3)];
     [0,          0,                     0,                    1];
     ];
end

%DH ---> DH table
%frames_index ---> [initial frame index, final frame index]
function p = forward_kinematic(hom_transf, frames_index)

    initial_frame = frames_index(1);
    final_frame = frames_index(2);
    
    n = final_frame-initial_frame;
    
    p = [0 0 0 1]';
    
    for i =n+1:-1:1
       
        T_i = hom_transf(i*4-3:i*4,:);
        p = simplify(T_i*p);
    end
    
     
    
end
