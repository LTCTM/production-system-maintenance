
% Tester la fonction Exponentielle

L=2;
somme=0;
for i=1:1:10000000
    x=Exponentielle (L);
    somme=somme+x;
end
moyenne=somme/10000000;
fprintf("Moyenne = %d \n", moyenne);