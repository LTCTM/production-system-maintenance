%����
tbf=50;
cmc=10;
cmp=20;
H=100;
Uc=10;
Up=5;
T=30;

%����
status=1;
e1=tbf;
e3=T;
e2=0;
e4=0;
CM=0;
CMP=0;
CMC=0;
tsim=0;
pe=0;

while(tsim<=H)
    if (status==1)
        pe=min([e1,e3]);
        e1=e1-pe;
        e3=e3-pe;
        if(e1==0)
            status=2;
            CMC=CMC+cmc;
            e2=Uc;
        else
            if(e3==0)
                status=3;
                CMP=CMP+cmp;
                e4=Up;
            else
                disp("erreur no1")
            end
        end
    else
        if(status==2)
            pe=e2;
            e2=0;
            status=1;
            e1=tbf;
            e3=T;
        else
            if(status==3)
                pe=e4;
                e4=0;
                status=1;
                e1=tbf;
                e3=T;
            else
                disp("errur no2\n")
            end
        end
    end
    tsim=tsim+pe;
end
CT=CMC+CMP;
CM=CT/tsim;
disp(CM)