

% programme de simulation du PROBLEME 3 (bas� sur PROBLEME2_V2)

% Une seule machine, maintenance corrective, maintenance pr�ventive (�ge)
% production 
% --> capacit� limite pour le stockage
% --> cout de p�nurie


clear;
clc;

% donn�es 

% param�tres de la loi Weibull
a=2;
b=110;

T=20;
cmc=10;
cmp=2;
cup=3;
cus=0.5;
cupe=0.1;
Uc=10;
Up=5;
Umax=0.5;
nsmax=25;
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
CPE=0;
tsim=0;
pe=0;
ns=0;
idc=0;

% programme


while(tsim <= H)
    if(etat == 1)  % �tat de fonctionnement
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
                    
                    if(ns<nsmax)
                        ns=ns+1;
                        e5=Umax;
                    else
                       etat=4; 
                    end
                else
                    if(e6 == 0)
                         CS=CS+((tsim+pe-idc)*ns)*cus;
                         idc=tsim+pe;
                         if(ns>=q)
                             ns=ns-q;
                         else
                             CPE=CPE+(q-ns)*cupe;
                             ns=0;
                         end
                         e6=f;
                    else
                        disp("erreur n�1");
                    end
                end
            end
        end
    else
        if(etat == 2) % �tat de maintenance corrective
            pe=min(e2,e6);
            e2=e2-pe;
            e6=e6-pe;
            
            if(e2 == 0)
                etat=1;
                e1=Weibull(a,b);
                e3=T; % type �ge              
            else
                if(e6 == 0)
                     CS=CS+((tsim+pe-idc)*ns)*cus;
                     idc=tsim+pe;
                     if(ns>=q)
                         ns=ns-q;
                     else
                         CPE=CPE+(q-ns)*cupe;
                         ns=0;
                     end
                     e6=f;
                else
                    disp("erreur n�2");
                end
            end
        else
            if(etat == 3) % �tat de maintenance pr�ventive
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
                             CPE=CPE+(q-ns)*cupe;
                             ns=0;
                         end
                         e6=f;
                    else
                        disp("erreur n�3");
                    end
                end
            else
                
                if(etat == 4) % �tat de blocage : pas de place dans le stock
                    pe=e6;
                    CS=CS+((tsim+pe-idc)*ns)*cus;
                    idc=tsim+pe;

                    if(ns+1>=q)
                        ns=ns+1-q;
                    else
                        CPE=CPE+(q-(ns+1))*cupe;
                        ns=0;
                    end
                    e6=f;
                    etat=1;
                    e5=Umax;
                    
                else
                    disp("erreur n�4");
                end
            end
        end
    end
    tsim=tsim+pe;
end

CoutTotal = CMC+CMP+CS+CPR+CPE;
CoutMoyen = CoutTotal/tsim;
fprintf("Co�t total de maintenance corrective  = %d \n", CMC);
fprintf("Co�t total de maintenance pr�ventive = %d \n", CMP);
fprintf("Co�t total de production = %d \n", CPR);
fprintf("Co�t total de stockage = %d \n", CS);
fprintf("Co�t total de p�nurie = %d \n", CPE);
fprintf("Co�t total = %d \n", CoutTotal);
fprintf("Co�t moyen = %d \n", CoutMoyen);

                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                

