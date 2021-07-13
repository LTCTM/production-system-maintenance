function CM=supercell_homework(m,U,H)
    exp_func=@(L)(-log(rand())/L);
    weibull=@(a,b)(b*(-log(rand())).^(1/a));
    %维修时间，等价于[gc(t),gcs(t)]
    %équivalent à [gc(t),gcs(t)]
    gc=[4,6];
    %维护时间，等价于[gp(t),gps(t)]
    %équivalent à [gp(t),gps(t)]
    gp=[2,4];
    %单次维修费，等价于[cmc,cmcs]
    %équivalent à [cmc,cmcs]
    cmc=[50,60];
    %单次维护费，等价于[cmp,cmps]
    %équivalent à [cmp,cmps]
    cmp=[5,10];
    %单位时间单位产品仓储费
    cs=0.5;
    %生产一个产品的成本，等价于[cprod,cprods]
    %équivalent à [cprod,cprods]
    cprod=[0.7,0.9];
    cp=4;%每件交付失败罚金
    %生产最快节拍，等价于[Umax,Usmax]
    %équivalent à [Umax,Usmax]
    Umax=[0.3,0.4];
    Q=20;%交货量
    Freq=10;%交货频率
    NSmax=20;%满容
    Ts=40;%维护频率

    %========启动========
    %========lancement========
    %第1行是主要机器事件
    %La ligne 1 est l'événement de M
    %第2行是备用机器事件
    %La ligne 2 est l'événement de Ms
    %第3行是通用事件，只有交货
    %La ligne 3 est l'événement de demande
    next_events=[
    weibull(2,100),NaN,m,NaN,U,NaN;
    NaN,NaN,NaN,NaN,NaN,NaN;
    NaN,NaN,NaN,NaN,NaN,Freq];
    tsim=0;%累计运行时长
    status=[1,4];
    %是否满容
    %si les machines sont en plein
    ns_full=[0,0];
    %需要计算的结果
    %les résultats
    CMC=0;%累计维修费
    CMP=0;%累计维护费
    CPROD=0;%累计生产成本
    CS=0;%累计仓储
    CP=0;%累计交付失败罚金
    ns=0;%仓库储量

    while(tsim<=H)
        %========获取最新事件========
        %========Recevez le dernier événement========
        pe=min(min(next_events));
        next_events=next_events-pe;
        %找到发生下一个事件的机器和内容
        %Trouvez la machine et le numéro où se produit le prochain événement
        [cur_machines,cur_events]=find(next_events==0);
        cur_event=cur_events(1);
        cur_machine=cur_machines(1);
        %========正式开始========
        %========le début========
        %结算仓储费
        %fermer un compte de cs pour chaque événement
        CS=CS+ns*pe*cs;
        %主要机器或备用机器的事件
        %événement de M ou Ms
        if(cur_machine~=3)
            %结算事件
            %====fermer un compte de l'événement====
            if(status(cur_machine)==1 && cur_event==1)
                %运行中发生故障
                %Défaillance pendant le fonctionnement
                status(cur_machine)=2;
                %维修所需时间
                %temps de la MC
                c_time=exp_func(gc(cur_machine));
                %本次维修完成时间
                %la fin de la MC
                next_events(cur_machine,2)=c_time;
                %生成下一次的故障时间
                %la MC prochaine
                next_events(cur_machine,1)=c_time+weibull(2,100);
                %生产延后
                %retarde de la production
                next_events(cur_machine,5)=c_time+next_events(5);
                %故障会重置下次维护时间
                %la MP prochaine avec un retard du temps de MC
                next_events(cur_machine,3)=m+c_time;
                CMC=CMC+cmc(cur_machine);
            elseif (status(cur_machine)==2 && cur_event==2)
                %故障中修好了
                %réparé en plein milieu d'une panne
                status(cur_machine)=1;
                next_events(cur_machine,2)=NaN;
            elseif (status(cur_machine)==1 && cur_event==3)
                %运行中开始维护
                %Maintenance préventive commencée pendant le fonctionnement
                status(cur_machine)=3;
                %本次维护时间
                %temps de la MP
                p_time=exp_func(gp(cur_machine));
                %本次维护完成时间
                %la fin de la MP
                next_events(cur_machine,4)=p_time;
                %生成下一次的维护时间
                %la MP prochaine
                next_events(cur_machine,3)=m;
                %生产延后
                %retarde de la production
                next_events(cur_machine,5)=p_time+next_events(5);
                %维护后生成下次故障时间
                %la MC prochaine avec un retard du temps de MP
                next_events(cur_machine,1)=p_time+weibull(2,100);
                CMP=CMP+cmp(cur_machine);
            elseif (status(cur_machine)==3 && cur_event==4)
                %维护完成
                %maintenance préventive fini
                status(cur_machine)=1;
                next_events(cur_machine,4)=NaN;
            elseif (status(cur_machine)==1 && cur_event==5)
                %生产出一个产品
                %Produire un produit
                next_events(cur_machine,5)=U;
                if (ns<NSmax)
                    ns=ns+1;
                    CPROD=CPROD+cprod(cur_machine);
                else
                    if(ns_full(cur_machine)==0)
                        CPROD=CPROD+cprod(cur_machine);
                    end
                    ns_full(cur_machine)=1;
                end
            else
                disp("error1")
                break
            end
            %如果主要机器坏了或开始维护，备用机器正在休眠，那么备用机器开始工作
            %si M est en maintenance, et Ms est en endormir: Ms à fonctionnement
            if(cur_machine==1 && status(1)~=1 && status(2)==4)
                next_events(2,:)=[weibull(2,100),NaN,m,NaN,Umax(2),NaN];
                status(2)=1;
            %如果备用机器正在工作，发现主要机器已经在工作了，那么备用机器休眠
            %si Ms est en fonctionnement, et M est en fonctionnement: Ms à endormir
            elseif(cur_machine==2 && status(2)==1 && status(1)==1)
                next_events(2,:)=[NaN,NaN,NaN,NaN,NaN,NaN];
                status(2)=4;
            end
        %====交货====
        %====la demande====
        elseif (cur_event==6)
            next_events(3,6)=Freq;
            ns_full_total=sum(ns_full);
            if (ns+ns_full_total>=Q)
                ns=(ns+ns_full_total)-Q;
            else
                CP=CP+(Q-(ns+ns_full_total))*cp;
                ns=0;
            end
            %因为每次至少交2个产品，所以机器里滞留的产品一定会被交出去
            %Étant donné qu'au moins 2 produits sont livrés à la fois, tout produit restant dans la machine doit être livré.
            ns_full(:)=0;
        else
            disp("error2")
            break
        end
        tsim=tsim+pe;
    end
    CT=CMC+CMP+CPROD+CS+CP;
    CM=CT/tsim;
end