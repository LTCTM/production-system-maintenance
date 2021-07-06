
% fonction Weibull

function x=Weibull(a, b)

    u=0;
    while(u==0 | u==1)
        u=rand();
    end

    x=b*(-1*log(u))^(1/a);

end
