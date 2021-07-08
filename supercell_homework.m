function CM=supercell_homework(m,U)    
    H=30000;%设计运行时长
    exp_func=@(L)(-log(rand())/L);
    weibull=@(a,b)(b*(-log(rand())).^(1/a));
    gc=[4,6];%维修时间，等价于[gc(t),gcs(t)]
    gp=[2,4];%维护时间，等价于[gp(t),gps(t)]
    
    cmc=[50,60];%单次维修费，等价于[cmc,cmcs]
    cmp=[5,10];%单次维护费，等价于[cmp,cmps]
    cs=0.5;%单位时间单位产品仓储费
    cprod=[0.7,0.9];%生产一个产品的成本，等价于[cprod,cprods]
    cp=4;%每件交付失败罚金

    Umax=[0.3,0.4];%生产一个产品所需时间，等价于[Umax,Usmax]
    Q=20;%交货量
    Freq=10;%交货频率
    NSmax=50;%满容
    Ts=40;%维护频率

    %====启动====
    %第1行是主要机器事件
    %第2行是备用机器事件
    %第3行是通用事件，只有交货
    next_events=[
    weibull(2,100),NaN,m,m+exp_func(gp(1)),U,NaN;
    NaN,NaN,NaN,NaN,NaN,NaN;
    NaN,NaN,NaN,NaN,NaN,Freq];
    %首次维修完成时间
    next_events(1,2)=next_events(1,1)+exp_func(gc(1));
    tsim=0;%累计运行时长
    status=[1,4];%启动模拟时主要机器处于“生产中”状态，备用机器处于“休眠中”状态
    ns_full=[0,0];%是否满容，和status类似
    %需要计算的结果
    CMC=0;%累计维修费
    CMP=0;%累计维护费
    CPROD=0;%累计生产成本
    CS=0;%累计仓储
    CP=0;%累计交付失败罚金
    ns=0;%仓库储量

    while(tsim<=H)
        %========获取最新事件========
        %到下一个事件发生的时间长度
        pe=min(min(next_events));
        %所有事件经过该时间
        next_events=next_events-pe;
        %找到发生该下一个事件的机器和内容
        [cur_machines,cur_events]=find(next_events==0);
        cur_event=cur_events(1);
        cur_machine=cur_machines(1);
        %========正式开始========
        %结算仓储费
        CS=CS+ns*pe*cs;
        %主要机器或备用机器的事件
        if(cur_machine~=3)
            %========每个机器分别结算自己的事件========
            if(status(cur_machine)==1 && cur_event==1) %运行中发生故障
                status(cur_machine)=2;%切换至维修中状态
                c_time=weibull(2,100);%维修所需时间
                next_events(cur_machine,2)=next_events(cur_machine,1)+c_time;%本次维修完成时间
                next_events(cur_machine,1)=c_time+weibull(2,100);%生成下一次的故障时间
                next_events(cur_machine,5)=c_time+next_events(5);%生产延后
                %故障会重置下次维护时间
                %故障和维护必须能够刷新对方
                next_events(cur_machine,3)=m+c_time;
                next_events(cur_machine,4)=next_events(cur_machine,3)+exp_func(gp(cur_machine));
                %维修开始时花钱
                CMC=CMC+cmc(cur_machine);
            elseif (status(cur_machine)==2 && cur_event==2)%故障中修好了
                status(cur_machine)=1;%切换至生产中状态
                next_events(cur_machine,2)=NaN;
            elseif (status(cur_machine)==1 && cur_event==3)%运行中开始维护
                status(cur_machine)=3;%切换至维护中状态
                p_time=exp_func(gp(cur_machine));%本次维护时间
                next_events(cur_machine,4)=next_events(cur_machine,3)+p_time;%本次维护完成时间
                next_events(cur_machine,3)=m;%生成下次维护时间
                next_events(cur_machine,5)=p_time+next_events(5);%生产延后
                %维护后生成下次故障时间
                next_events(cur_machine,1)=p_time+weibull(2,100);
                next_events(cur_machine,2)=next_events(cur_machine,1)+exp_func(gc(cur_machine));
                %认为维护开始就花钱
                CMP=CMP+cmp(cur_machine);
            elseif (status(cur_machine)==3 && cur_event==4)%维护完成
                status(cur_machine)=1;%切换至生产中状态
                next_events(cur_machine,4)=NaN;
            elseif (status(cur_machine)==1 && cur_event==5)%生产出一个产品
                next_events(cur_machine,5)=U;%下次生产出产品的时间
                if (ns<NSmax)
                    ns=ns+1;%仓库存放一个产品
                    CPROD=CPROD+cprod(cur_machine);%生产完成才计算成本
                else
                    %仓库满了也是可以生产的，因为机器里还能再存一个
                    if(ns_full(cur_machine)==0)
                        CPROD=CPROD+cprod(cur_machine);%生产完成才计算成本
                    end
                    ns_full(cur_machine)=1;
                end
            else
                disp("error1")
                break
            end
            %如果主要机器坏了或开始维护，备用机器正在休眠，那么备用机器开始工作
            if(cur_machine==1 && status(1)~=1 && status(2)==4)
                next_events(2,:)=[weibull(2,100),NaN,m,m+exp_func(gp(1)),Umax(2),NaN];
                %首次维修完成时间
                next_events(2,2)=next_events(2,1)+exp_func(gc(2));
                %备用机器状态切换为“工作中”
                status(2)=1;
            %如果备用机器正在工作，发现主要机器已经在工作了，那么备用机器休眠
            elseif(cur_machine==2 && status(2)==1 && status(1)==1)
                next_events(2,:)=[NaN,NaN,NaN,NaN,NaN,NaN];
                status(2)=4;
            end
        %通用事件
        elseif (cur_event==6)%交货
            next_events(3,6)=Freq;%下次交货时间
            %交货，不够有惩罚
            ns_full_total=sum(ns_full);
            if (ns+ns_full_total>=Q)
                ns=(ns+ns_full_total)-Q;
            else
                CP=CP+(Q-(ns+ns_full_total))*cp;%交罚金
                ns=0;
            end
            %因为每次至少交2个货，所以默认一定会把机器里的货交出去
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