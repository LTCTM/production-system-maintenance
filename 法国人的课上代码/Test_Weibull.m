
% tester la loi Weibull


a=2;
b=110;
somme=0;
for i=1:1:100000
    x=Weibull(a, b);
    somme=somme+x;
end
moyenne=somme/100000;
fprintf("Moyenne = %d \n", moyenne);

