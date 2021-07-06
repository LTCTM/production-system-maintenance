
% loi Normale

function z=Normale(m, s)

u1=0;
while(u1==0 | u1==1)
    u1=rand();
end

u2=0;
while(u2==0 | u2==1)
    u2=rand();
end

x=((-2*log(u1))^(1/2))*cos(2*pi*u2);  % x suit une loi normale (0,1)

z=m+s*x;  % z suit une loi normale (m,s)





