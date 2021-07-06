

% VERSION 2 : ajout de la fonction aléatoire Weibull pour la génération 
% des temps de bon fonctionnement

% programme de simulation du PROBLEME 2

% Une seule machine, maintenance corrective, maintenance préventive (âge)
% production 
% pas de capacité limite pour le stockage
% pas de pénurie


clear;
clc;

% données 

% paramètres de la loi Weibull
a=2;
b=110;

T=30;
cmc=10;
cmp=2;
cup=3;
cus=0.5;
Uc=10;
Up=5;
Umax=2;
f=20;
q=20;


H=1000000;


% variables

etat=1;
e1=Weibull(a,b);
e3=T;
e2=0;
e4=0;
e5=Umax;
e6=f;
CMC=0;
CMP=0;
CS=0;
CPR=0;
tsim=0;
pe=0;
ns=0;
idc=0;

% programme


while(tsim <= H)
    if(etat == 1)  % état de fonctionnement
        pe=min([e1,e3, e5, e6]);
        e1=e1-pe;
        e3=e3-pe;
        e5=e5-pe;
        e6=e6-pe;
        
        if(e1 == 0)
            etat=2;
            CMC=CMC+cmc;
            e2=Uc;
        else
            if(e3 == 0)
                etat=3;
                CMP=CMP+cmp;
                e4=Up;
            else
                if(e5 == 0)
                    CS=CS+((tsim+pe-idc)*ns)*cus;
                    idc=tsim+pe;
                    CPR=CPR+cup;
                    ns=ns+1;
                    e5=Umax;
                else
                    if(e6 == 0)
                         CS=CS+((tsim+pe-idc)*ns)*cus;
                         idc=tsim+pe;
                         if(ns>=q)
                             ns=ns-q;
                         else
                             ns=0;
                         end
                         e6=f;
                    else
                        disp("erreur n°1");
                    end
                end
            end
        end
    else
        if(etat == 2) % état de maintenance corrective
            pe=min(e2,e6);
            e2=e2-pe;
            e6=e6-pe;
            
            if(e2 == 0)
                etat=1;
                e1=Weibull(a,b);
                e3=T; % type âge              
            else
                if(e6 == 0)
                     CS=CS+((tsim+pe-idc)*ns)*cus;
                     idc=tsim+pe;
                     if(ns>=q)
                         ns=ns-q;
                     else
                         ns=0;
                     end
                     e6=f;
                else
                    disp("erreur n°2");
                end
            end
        else
            if(etat == 3) % état de maintenance préventive
                pe=min(e4, e6);
                e4=e4-pe;
                e6=e6-pe;
                
                if(e4 == 0)
                    etat=1;
                    e1=Weibull(a,b);
                    e3=T;                     
                else
                    if(e6 == 0)
                         CS=CS+((tsim+pe-idc)*ns)*cus;
                         idc=tsim+pe;
                         if(ns>=q)
                             ns=ns-q;
                         else
                             ns=0;
                         end
                         e6=f;
                    else
                        disp("erreur n°3");
                    end
                end
            else
                disp("erreur n°4");
            end
        end
    end
    tsim=tsim+pe;
end

CoutTotal = CMC+CMP+CS+CPR;
CoutMoyen = CoutTotal/tsim;
fprintf("Coût total de maintenance corrective  = %d \n", CMC);
fprintf("Coût total de maintenance préventive = %d \n", CMP);
fprintf("Coût total de production = %d \n", CPR);
fprintf("Coût total de stockage = %d \n", CS);
fprintf("Coût total = %d \n", CoutTotal);
fprintf("Coût moyen = %d \n", CoutMoyen);

                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                

