function x=weibull(a,b)
    u=0;
    while(u==0 || u==1)
        u=rand();
    end
    x=b*(-log(u))^(1/a);
end