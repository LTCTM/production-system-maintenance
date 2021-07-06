
% programme de simulation du PROBLEME 1

% Une seule machine, maintenance corrective, maintenance préventive (âge)


% données 

T=30;
cmc=10;
cmp=2;
Uc=10;
Up=5;
H=100;


% variables

etat=1;
e1=LoiDePannne();
e3=T;
e2=0;
e4=0;
CMC=0;
CMP=0;
tsim=0;
pe=0;

% programme


while(tsim <= H)
    if(etat == 1)  % état de fonctionnement
        pe=min(e1,e3);
        e1=e1-pe;
        e3=e3-pe;
        
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
                disp("erreur n°1");
            end
        end
    else
        if(etat == 2) % état de maintenance corrective
            pe=e2;
            e2=0;
            etat=1;
            e1=LoiDePannne();
            e3=T;
        else
            if(etat == 3) % état de maintenance préventive
                pe=e4;
                e4=0;
                etat=1;
                e1=LoiDePannne();
                e3=T;
            else
                disp("erreur n°2");
            end
        end
    end
    tsim=tsim+pe;
end

CoutTotal = CMC+CMP;
CoutMoyen = CoutTotal/tsim;
fprintf("Coût total de maintenance corrective  = %d \n", CMC);
fprintf("Coût total de maintenance préventive = %d \n", CMP);
fprintf("Coût total de maintenance (corrective et préventive ) = %d \n", CoutTotal);
fprintf("Coût moyen de maintenance (corrective et préventive ) = %d \n", CoutMoyen);

                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                

