function posveldot=f1eqs(t,posvel,par,angle)
accel=f1forces(posvel,par,angle);
posveldot=[posvel(2);accel(1)];