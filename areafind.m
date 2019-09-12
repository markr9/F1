% area
format compact
A = imread('maskf1front2','BMP');
imagesc(A);
colormap([0 0 0; 1 1 1]); % Black & White
image(A);
%A=A/255;
c=size(A)
b=sum(A(:))
b=sum(b)
d=b/(c(1)*c(2))
scale=2*0.95
area=scale*d

%front wing: 200mm*900mm+550mm*900mm+125mm*125mm
%rear wing: 950mm*350mm

b=1.8 %front wing span (m)
AR=b^2/0.6906 %aspect ratio (m^2)
aoa=15 %angle of attack (deg)
cl2=2*pi*(AR/(AR+2))*aoa*pi/180
%cl2=cl2*3
cdi=cl2^2/(pi*AR*0.7)
ltdr=cl2/cdi