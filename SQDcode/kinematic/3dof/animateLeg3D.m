function moveLeg3D(q,com,lr,opacity)

%CoM position
xcom = com.x;
ycom = com.y;

l1 = 0.41;           %length top leg
l2 = 0.41;           %length bottom leg
l3 = 0.15;           %length foot


%angles that follow the DH convenction 
q1 = q(1);             
q2 = q(2);
q3 = q(3);

%positon of the line tips example (x11,y11)--> o-----o <--(x22,y22)
x11 =xcom;                  %posizione x CoM
y11 = ycom ;                 %posizione y CoM
x12 = xcom+l1*sin(q1);
y12 = ycom-l1*cos(q1);

x21 = x12;
y21 = y12;
x22 = xcom+l2*sin(q1+q2)+l1*sin(q1);
y22 = ycom-l2*cos(q1+q2)-l1*cos(q1);

x31 = x22;
y31 = y22;
x32 = xcom+l2*sin(q1+q2)+l1*sin(q1)+l3*sin(q1+q2+q3);
y32 = ycom-l2*cos(q1+q2)-l1*cos(q1)-l3*cos(q1+q2+q3);

%plot the lines and the markers

if lr=='r'
    z = 0.15;
else
    z = -0.15;
    
end

p1= plot3([x11 x12],[z z],[y11 y12],'o','MarkerIndices',[1 2],'color','b','lineWidth',3,'ColorMode','manual');
hold on
p2 = plot3([x11 x12],[z z],[y11 y12],lr,'lineWidth',3,'ColorMode','manual');
hold on 
p3  = plot3([x21 x22],[z z],[y21 y22],'o','MarkerIndices',[1 2],'color','b','lineWidth',3,'ColorMode','manual');
hold on 
p4 = plot3([x21 x22],[z z],[y21 y22],lr,'lineWidth',3,'ColorMode','manual');
hold  on
p5 = plot3([x31 x32],[z z],[y31 y32],'k','lineWidth',3,'ColorMode','manual');


hold on;
p6 = plot3([x11 x11],[z -z],[y11 y11],'k','lineWidth',3); %link between the legs

ylim([-0.5 2]);
xlim([-0.5 2]);
zlim([-0.2 1]);
grid();
p1.Color(4) = opacity;
p2.Color(4) = opacity;
p3.Color(4) = opacity;
p4.Color(4) = opacity;
p5.Color(4) = opacity;
p6.Color(4) = opacity;
xlabel('x');
ylabel('y');
zlabel('z');

view(0,0);

end









