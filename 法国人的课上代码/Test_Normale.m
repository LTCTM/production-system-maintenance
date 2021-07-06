

% tester la loi normale 

m=10;
s=0.1;
somme=0;
for i=1:1:100000
    z=Normale(m, s);
    somme=somme+z;
end
moyenne=somme/100000;
fprintf("Moyenne = %d \n", moyenne);
