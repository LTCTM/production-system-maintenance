H=1000000;%设计运行时长
cmc=10;%单次维修费
cmp=20;%单次维护费
cus=0.5;%单位时间单位产品仓储费
cup=3;%生产一个产品的成本
cupe=0.1;%每件交付失败罚金

Uc=10;%维修时间
Up=5;%维护时间
Umax=2;%生产一个产品所需时间

q=20;%交货量
f=20;%交货频率
nsmax=25;%满容

T=50;%维护频率
%====启动====
next_events=[next_fail(),NaN,T,T+Up,Umax,f];
next_events(2)=next_events(1)+Uc;
tsim=0;%累计运行时长
status=1;%启动模拟时机器处于“生产中”状态
ns_full=0;%是否满容，和status类似
%需要计算的结果
CMC=0;%累计维修费
CMP=0;%累计维护费
CPR=0;%累计生产成本。法国人的设计中好像没有算第一个产品的成本
%CPR=cup;
CS=0;%累计仓储
CPE=0;%累计交付失败罚金
ns=0;%仓库储量

while(tsim<=H)
    %========获取最新事件========
    pe=min(next_events);
    next_events=next_events-pe;
    cur_events=find(next_events==0);
    cur_event=cur_events(1);
    %========正式开始========
    %====结算本轮仓储费====
    CS=CS+ns*pe*cus;
    %====结算事件更新状态====
    if(status==1 && cur_event==1) %运行中发生故障
        next_events(1)=Uc+next_fail();%生成下一次的故障时间
        status=2;%切换至维修中状态
        next_events(5)=Uc+next_events(5);%生产延后
        %故障会重置下次维护时间
        %故障和维护必须能够刷新对方，不一定要求刷新自己，整个系统才能没有bug
        next_events(3)=T+Uc;
        next_events(4)=next_events(3)+Up;
        %认为维修开始就花钱
        CMC=CMC+cmc;
    elseif (status==2 && cur_event==2)%故障中修好了
        next_events(2)=next_events(1)+Uc;%下一次维修完成时间
        status=1;%切换至生产中状态
    elseif (status==1  && cur_event==3)%运行中开始维护
        next_events(3)=T;%假设机器在下次维护之前都不故障
        status=3;%切换至维护中状态
        next_events(5)=Up+next_events(5);%生产延后
        %维护后生成下次故障时间
        next_events(1)=Uc+next_fail();
        next_events(2)=next_events(1)+Uc;
        %认为维护开始就花钱
        CMP=CMP+cmp;
    elseif (status==3 && cur_event==4)%维护完成
        next_events(4)=next_events(3)+Up;%生成下一次维护完成时间
        status=1;%切换至生产中状态
    elseif (status==1 && cur_event==5)%生产出一个产品
        next_events(5)=Umax;%下次生产出产品的时间
        if (ns<nsmax)
            ns=ns+1;%仓库存放一个产品
            %认为开始生产就计算成本
            CPR=CPR+cup;
        else
            %仓库满了也是可以生产的，因为机器里还能再存一个
            %ns_full=1 说明现在机器里还有一个产品
            %注意这里用了ns_full，因此不再出现status=4的情况，可以确保不出bug
            ns_full=1;
        end
    elseif (cur_event==6)%交货
        next_events(6)=f;%下次交货时间
        if(ns_full==1)
            %重置下次生产时间
            next_events(5)=Umax;
        end
        %交货，不够有惩罚
        if (ns+ns_full>=q)
            ns=(ns+ns_full)-q;
        else
            CPE=CPE+(q-(ns+ns_full))*cupe;%交罚金
            ns=0;
        end
        %因为每次至少交一个货，所以默认一定会把机器里的货交出去
        ns_full=0;
    else
        disp("error")
        break
    end
    tsim=tsim+pe;
end
CT=CMC+CMP+CPR+CS+CPE;
CM=CT/tsim;
