function moveLeg6DOF3D(q,com,lr,opacity)

%CoM position
comx = com.x;
comy = com.y;
comz = com.z;

%change the parameters depending on which leg calls the function
if lr=='r'
    a1 = -0.025;

else
    a1 = 0.025;
    
end

%DH parameters
d1 = 0.02;
a3 = 0;
a4 = 0.39;
a5 = 0.41;
a6 = 0.15;




%angles that follow the DH convenction            
q2 = q(2);
q3 = q(3);
q4 = q(4);
q5 = q(5);
q6 = q(6);

%positon of the line tips example (x11,y11)--> o-----o <--(x22,y22)
x11 =comx;                  %posizione x CoM
y11 = comy;                 %posizione y CoM
z11 = comz;


%1-->2
x12 = comx;  
y12 = comy-a1 ;
z12 = comz - d1;


x21 = x12;
y21 = y12;
z21 = z12;


%1-->3
x22 =  comx - a3*sin(q2)*sin(q3);
y22 = comy - a1 - a3*cos(q2)*sin(q3);
z22 = comz - d1 + a3*cos(q3);


x31 = x22;
y31 = y22;
z31 = z22;

%1-->4
x32 =  comx + a4*cos(q2)*sin(q4) - sin(q2)*sin(q3)*(a3 - a4*cos(q4));
y32 = comy - a1 - cos(q2)*sin(q3)*(a3 - a4*cos(q4)) - a4*sin(q2)*sin(q4);
z32 =  comz - d1 + cos(q3)*(a3 - a4*cos(q4));


x41 = x32;
y41 = y32;
z41 = z32;



%1-->5
x42 = comx + cos(q2)*(a5*sin(q4 + q5) + a4*sin(q4)) + sin(q2)*sin(q3)*...
    (a5*cos(q4 + q5) - a3 + a4*cos(q4));
y42 = comy - a1 - sin(q2)*(a5*sin(q4 + q5) + a4*sin(q4)) + cos(q2)*sin(q3)*...
    (a5*cos(q4 + q5) - a3 + a4*cos(q4));
z42 =  comz - d1 - cos(q3)*(a5*cos(q4 + q5) - a3 + a4*cos(q4));


x51 = x42;
y51 = y42;
z51 = z42;


%1--->6
x52 = comx + cos(q2)*(a5*sin(q4 + q5) + a4*sin(q4) + a6*cos(q4 + q5 + q6))...
    - sin(q2)*sin(q3)*(a3 - a5*cos(q4 + q5) - a4*cos(q4) + a6*sin(q4 + q5 + q6));
y52 = comy - a1 - sin(q2)*(a5*sin(q4 + q5) + a4*sin(q4) + a6*cos(q4 + q5 + q6))...
    - cos(q2)*sin(q3)*(a3 - a5*cos(q4 + q5) - a4*cos(q4) + a6*sin(q4 + q5 + q6));
z52 =  comz - d1 + cos(q3)*(a3 - a5*cos(q4 + q5) - a4*cos(q4) + a6*sin(q4 + q5 + q6));



p1 = plot3([x11 x12],[y11 y12],[z11 z12],'k','lineWidth',3,'ColorMode','manual');
hold on 
p2  = plot3([x21 x22],[y21 y22],[z21,z22],'o','MarkerIndices',[1 2],'color','b','lineWidth',3,'ColorMode','manual');
hold on 
p3 = plot3([x21 x22],[y21 y22],[z21, z22],lr,'lineWidth',3,'ColorMode','manual');
hold  on
p4  = plot3([x31 x32],[y31 y32],[z31, z32],'o','MarkerIndices',[1 2],'color','b','lineWidth',3,'ColorMode','manual');
hold on
p5 = plot3([x31 x32],[y31 y32],[z31, z32],lr,'lineWidth',3,'ColorMode','manual');
hold on
p6  = plot3([x41 x42],[y41 y42],[z41 z42],'o','MarkerIndices',[1 2],'color','b','lineWidth',3,'ColorMode','manual');
hold on
p7 = plot3([x41 x42],[y41 y42],[z41 z42],lr,'lineWidth',3,'ColorMode','manual');
hold on
p8 = plot3([x51 x52],[y51 y52],[z51 z52],lr,'lineWidth',3,'ColorMode','manual');
% 


ylim([-0.3 0.3]);
xlim([-0.5 2]);
zlim([-0.2 1]);
xlabel('x');
ylabel('y');
zlabel('z');
grid();
p1.Color(4) = opacity;
p2.Color(4) = opacity;
p3.Color(4) = opacity;
p4.Color(4) = opacity;
p5.Color(4) = opacity;
p6.Color(4) = opacity;
p7.Color(4) = opacity;
p8.Color(4) = opacity;

end









