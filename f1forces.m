function a=f1forces(pv,par,angle)
%par=f1carpar;
angle=angle*2*pi/180;
A1=par(7)*par(8)*(par(4)*cos(angle(1))+sin(angle(1)));
ad=(par(9)*pv(2).^2+A1)/par(7);
ae=par(3)/pv(2)/par(7);
a1=ae-ad;
A=par(7)*par(8)*((par(13)-par(4))*cos(angle(1))-sin(angle(1)));
B=1/2*par(15)*(par(16)+(par(4)-par(13))*par(12)*par(14));
a2=(A-B*pv(2).^2)/par(7);
if a2<=a1
    aa=a2;
else aa=a1;
end
a=[aa];