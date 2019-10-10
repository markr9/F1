%F1 2018 car

%calibration
par=f1carpar;
%          s    v
posvel0=[0.01;0.01]
angle=[0,0] %alpha,theta (incline[+ve up],camber[+ve banking])
tf=30
options=odeset('RelTol',1.0e-9);
[t,posvel]=ode45(@(t,posvel) f1eqs(t,posvel,par,angle),[0,tf],posvel0,options);
figure(12)
% i=1;
% t2=ones(1,length(t)-1);
% a2=ones(1,length(t)-1);
% while i<length(t)
%     t2(i)=(t(i+1)+t(i))/2;
%     a2(i)=(posvel(i+1,2)-posvel(i,2))/(t(i+1)-t(i));
%     i=i+1;
% end
t2=diff(t);
v2=diff(posvel(:,2));
a2=v2./t2;
t3=ones(1,length(t2));
i=1;
while i<=length(t3)
    t3(i)=(t(i)+t(i+1))/2;
    i=i+1;
end
plot(t3,a2,'x-')
xlabel('Time/s')
ylabel('Acceleration /ms^-2')
title('Acceleration (a from v)')
grid on
figure(13)
plot(t,posvel(:,1),'x-')
xlabel('Time /s')
ylabel('Distance /m')
title('Distance')
grid on
figure(14)
plot(t,posvel(:,2),'x-')
xlabel('Time /s')
ylabel('Velocity /ms^-1')
title('Velocity')
grid on
figure(15)
i=1;
a=ones(1,length(t));
while i<=length(t)
    a(i)=f1forces([0,posvel(i,2)],par,angle);
    i=i+1;
end
plot(posvel(:,2),a,'x-')
xlabel('Velocity /ms^-1')
ylabel('Acceleration /ms^-2')
title('Acceleration')
grid on
figure(16)
plot(t,a,'x-')
xlabel('Time /s')
ylabel('Acceleration /ms^-2')
title('Acceleration (a from eqs)')
grid on
figure(17)
plot(posvel(:,1),a,'x-')
xlabel('Distance /m')
ylabel('Acceleration /ms^-2')
title('Acceleration')
grid on
figure(18)
plot(posvel(:,1),posvel(:,2),'x-')
xlabel('Distance /m')
ylabel('Velocity /ms^-1')
title('Velocity')
grid on
fprintf('Calibration finished!\n')

%finding answers

%single use

%track use
