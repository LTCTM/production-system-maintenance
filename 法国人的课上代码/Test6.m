
% exercice 3 : for

Somme=0;
for i=1:1:10
    n=input('Saisir un nombre : ');
    Somme = Somme + n;
end
Moyenne = Somme / 10;
fprintf('La moyenne des nombres saisis = %d \n', Moyenne);