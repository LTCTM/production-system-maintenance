function z=normale(m,s)
    u1=0;
    while(u1==0 || u1==1)
        u1=rand();
    end
    u2=0;
    while(u2==0 || u2==1)
        u2=rand();
    end
    x=((-2*log(1-u1))^0.5)*cos(2*pi*u2);%x其实是randn()，不需要这么复杂
    z=m+x*s;
end