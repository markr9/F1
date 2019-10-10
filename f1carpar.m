function par=f1carpar
format compact
format short
Pel=120e3 %electric power (W)
Pe=850 %engine power (bhp)
Pen=Pel+Pe*745.7 %power (W)
Crr=0.01; %rolling resistance co-eff (dim)
md=733 %dry mass (kg)
mf=105/75 %fuel mass (kg) [do]
m=md+mf
g=9.81 %gravity acceleration (ms^-2)

%power-drag
A=m*g*Crr
A2=m*g*(Crr*cos(pi/3)+sin(5*pi/180))
Pmax=Pen
vmax=325 %max velocity (km/h)
vdmax=340 %max velocity drs (km/h)
vmax=vmax/3.6 %(m/s)
vdmax=vdmax/3.6 %(m/s)
k=(Pmax-A*vmax)/vmax^3
kd=(Pmax-A*vdmax)/vdmax^3

v=0:1:100;
Pd=k*v.^3+A*v;
Pdd=kd*v.^3+A*v;
Pd2=k*v.^3+A2*v;
Pvec=ones(1,length(v))*Pen;
Pvec2=Pvec-Pd;
figure(1)
plot(v,Pvec,'x-',v,Pd,'x-',v,Pdd,'x-',v,Pvec2,'x-',v,Pd2,'x-')
xlabel('Velocity /ms^-1')
ylabel('Power /W')
title('Power')
legend('Engine Power','Drag power','DRS Drag power','Resaultant power','5 degree incline')
grid on

%friction-lift
area=1.3069 %area (m^2)
Aw=0.2*0.9+0.55*0.9+0.125*0.125+0.95*0.35%+1.05*(0.35+.175) %wings area (m^2)
rinner=[8,20,30]; %inner radius of corner (m) (add)
theta=[150,90,90]; %corner angle (deg) (add)
%cor id be1
vcorner=[80,115,180]; %velocity at corner apex (kph) (add)
vcorner=(vcorner./3.6).^2 %(add)
rcl=ones(1,length(rinner)); %classical racing line raduis (m)
w=[15,12,12]; %track width (m) (add)
i=1; %(add loop)
while i<=length(rcl)
   rcl(i)=rinner(i)+(w(i)*cos((theta(i)*pi/180)/4))/(sin((theta(i)*pi/180)/2)*sin((theta(i)*pi/180)/4));
   i=i+1;
end
rcl=[10:200]; %remove
vcorner=((11.772*rcl)./(1-0.0025*rcl)).^(1/2); %remove 0.0039
figure(2)
plot(rcl,vcorner,'rx')
xlabel('Raduis /m')
ylabel('Velocity /ms^-1')
grid on
hold on
eq=@(p,x) ((p(1).*x)./(1-p(2).*x)).^(1/2);
sv=[10,2];
coeff=nlinfit(rcl,vcorner,eq,sv);
xgrid=linspace(0,300,100);
line(xgrid,eq(coeff,xgrid),'color','b')
legend('Data points','Trend line')
title('Corner apex speed')
hold off
coeff=real(coeff)
mu=coeff(1)/g
cl=(coeff(2)*m*2)/(mu*Aw)

%drag
rho=1.255 %air density (kgm^-3)
cdA=(2*k)/rho-Crr*cl*Aw %drag coeff x area (m^2)
Crr*cl*Aw
%assume cdiAw=cdpA
C=cdA/2
cdi=C/Aw
cdp=C/area
cd=cdi+cdp
ltdr=cl/cd

%front wing
b=1.8 %front wing span (m)
AR=b^2/(0.2*0.9+0.55*0.9+0.125*0.125) %aspect ratio (m^2)
aoa=11 %angle of attack (deg)
cl2=2*pi*(AR/(AR+2))*aoa*pi/180
cl2=cl2*(4/3+2)
cdi2=cl2^2/(pi*AR*0.7)
ltdr=cl2/cdi2

cl-cl2
cdi-cdi2

%acceleration
A=m*g*Crr
k=1/2*rho*(cdA+Crr*Aw*cl)
vel=1:1:100;
ad=(k*vel.^2+A)/m;
aen=Pen./vel/m;
a=aen-ad;
figure(3)
plot(vel,a,'bx-',vel,aen,'rx-',vel,ad,'mx-')
xlabel('Velocity /ms^-1')
ylabel('accleration /ms^-2')
title('Acceleration')
legend('Acceleration','Engine a','Drag a')
grid on

%traction limit
A=g*(mu-Crr)
B=1/(2*m)*rho*(cdA+(Crr-mu)*Aw*cl)
vel2=1:1:100;
a2=A-B*vel2.^2;
y=a-a2;
figure(4)
plot(vel2,a2,'x-',vel,a,'x-',vel,y,'x-')
xlabel('Velocity /ms^-1')
ylabel('Max acceleration /ms^-2')
title('Traction limit')
legend('Traction limit','Power accleration','Acceleration difference')
grid on
figure(5)
y2=ones(1,length(y));
i=1;
while i<=length(y2)
    if a2(i)<=a(i)
        y2(i)=a2(i);
    else y2(i)=a(i);
    end
    if y2(i)<0
        y2(i)=0;
    end
    i=i+1;
end
plot(vel,y2,'x-')
xlabel('Velocity /ms^-1')
ylabel('Acceleration /ms^-2')
title('Acceleration')
grid on
coeffs=[B*m-k,0,-(m*g*Crr+A*m),Pen];
sol=roots(coeffs);
sol(3)
% syms v
% eqn=Pen/v-k*v^2-m*g*Crr==A-B*v^2;
% sol=solve(eqn,v);
% sol

%braking
anglea=10
A=g*(mu+Crr)
A2=g*((mu+Crr)*cos(anglea*pi/180)+sin(anglea*pi/180))
B=1/(2*m)*rho*(cdA+(Crr+mu)*Aw*cl)
vel=0:1:100;
a=-(A+B*vel.^2);
aa2=-(A2+B*vel.^2);
figure(6)
plot(vel,a,'x-',vel,aa2,'x-')
xlabel('Velocity /ms^-1')
ylabel('Braking /ms^-2')
title('Braking')
grid on
t=0:0.1:5;
v=-(A^(1/2)*tan(t*(A*B)^(1/2)))/(B^(1/2));
vv=-(A2^(1/2)*tan(t*(A2*B)^(1/2)))/(B^(1/2));
a2=-A-B*(-(A^(1/2)*tan(t*(A*B)^(1/2)))/(B^(1/2))).^2;
aa=-A2-B*(-(A2^(1/2)*tan(t*(A2*B)^(1/2)))/(B^(1/2))).^2;
s=-log(sec((A*B)^(1/2)*t))/B;
ss=-log(sec((A2*B)^(1/2)*t))/B;
figure(7)
plot(t,v,'x-',t,vv,'x-')
xlabel('Time /s')
ylabel('Velocity /ms^-1')
title('Braking')
grid on
figure(8)
plot(t,a2,'x-',t,aa,'x-')
xlabel('Time /s')
ylabel('Braking /ms^-2')
title('Braking')
grid on
figure(9)
plot(t,s,'x-',t,ss,'x-')
xlabel('Time /s')
ylabel('Distance /m')
title('Braking')
grid on
figure(10)
plot(v,s,'x-',vv,ss,'x-')
xlabel('Velocty /ms^-1')
ylabel('Distance /m')
title('Braking')
grid on
figure(11)
plot(v,a2,'x-',vv,aa,'x-')
xlabel('Velocty /ms^-1')
ylabel('Braking /ms^-2')
title('Braking')
grid on

%    1    2  3   4   5  6 7 8 9 10  11  12 13 14  15  16  17  18 19  20
par=[Pel,Pe,Pen,Crr,md,mf,m,g,k,kd,area,Aw,mu,cl,rho,cdA,cdi,cdp,cd,ltdr];
