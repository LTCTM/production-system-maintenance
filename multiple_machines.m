%��Ҫ˵��
%��������ʱ��ÿ�ν�����q������ڵ��ڻ�����mcc���������������bug������


H=100000;%�������ʱ��
cmc=10;%����ά�޷�
cmp=20;%����ά����
cus=0.5;%��λʱ�䵥λ��Ʒ�ִ���
cup=3;%����һ����Ʒ�ĳɱ�
cupe=0.1;%ÿ������ʧ�ܷ���

Uc=10;%ά��ʱ��
Up=5;%ά��ʱ��
Umax=2;%����һ����Ʒ����ʱ��

q=20;%������
f=20;%����Ƶ��
nsmax=25;%����

T=50;%ά��Ƶ��
%====����====
mcc=2;%������
next_events=repmat([next_fail(),NaN,T,T+Up,Umax,NaN],mcc,1);
%��mcc+1����ͨ���¼���Ŀǰֻ�н���
next_events(mcc+1,:)=[NaN,NaN,NaN,NaN,NaN,f];
for i =1:1:mcc
    next_events(i,2)=next_events(i,1)+Uc;
end
tsim=0;%�ۼ�����ʱ��
status=ones(1,mcc);%����ģ��ʱ�������ڡ������С�״̬
ns_full=zeros(1,mcc);%�Ƿ����ݣ���status����
%��Ҫ����Ľ��
CMC=0;%�ۼ�ά�޷�
CMP=0;%�ۼ�ά����
CPR=0;%�ۼ������ɱ��������˵�����к���û�����һ����Ʒ�ĳɱ�
%CPR=cup;
CS=0;%�ۼƲִ�
CPE=0;%�ۼƽ���ʧ�ܷ���
ns=0;%�ֿⴢ��

while(tsim<=H)
    %========��ȡ�����¼�========
    pe=min(next_events,[],'all');
    next_events=next_events-pe;
    [cur_machines,cur_events]=find(next_events==0);
    cur_event=cur_events(1);
    cur_machine=cur_machines(1);
    %========��ʽ��ʼ========
    %====���㱾�ֲִ���====
    CS=CS+ns*pe*cus;
    if(cur_machine~=mcc+1)
        if(status(cur_machine)==1 && cur_event==1) %�����з�������
            next_events(cur_machine,1)=Uc+next_fail();%������һ�εĹ���ʱ��
            status(cur_machine)=2;%�л���ά����״̬
            next_events(cur_machine,5)=Uc+next_events(5);%�����Ӻ�
            %���ϻ������´�ά��ʱ��
            %���Ϻ�ά�������ܹ�ˢ�¶Է�����һ��Ҫ��ˢ���Լ�������ϵͳ����û��bug
            next_events(cur_machine,3)=T+Uc;
            next_events(cur_machine,4)=next_events(cur_machine,3)+Up;
            %��Ϊά�޿�ʼ�ͻ�Ǯ
            CMC=CMC+cmc;
        elseif (status(cur_machine)==2 && cur_event==2)%�������޺���
            next_events(cur_machine,2)=next_events(cur_machine,1)+Uc;%��һ��ά�����ʱ��
            status(cur_machine)=1;%�л���������״̬
        elseif (status(cur_machine)==1  && cur_event==3)%�����п�ʼά��
            next_events(cur_machine,3)=T;%����������´�ά��֮ǰ��������
            status(cur_machine)=3;%�л���ά����״̬
            next_events(cur_machine,5)=Up+next_events(5);%�����Ӻ�
            %ά���������´ι���ʱ��
            next_events(cur_machine,1)=Uc+next_fail();
            next_events(cur_machine,2)=next_events(cur_machine,1)+Uc;
            %��Ϊά����ʼ�ͻ�Ǯ
            CMP=CMP+cmp;
        elseif (status(cur_machine)==3 && cur_event==4)%ά�����
            next_events(cur_machine,4)=next_events(cur_machine,3)+Up;%������һ��ά�����ʱ��
            status(cur_machine)=1;%�л���������״̬
        elseif (status(cur_machine)==1 && cur_event==5)%������һ����Ʒ
            next_events(cur_machine,5)=Umax;%�´���������Ʒ��ʱ��
            if (ns<nsmax)
                ns=ns+1;%�ֿ���һ����Ʒ
                %��Ϊ��ʼ�����ͼ���ɱ�
                CPR=CPR+cup;
            else
                %�ֿ�����Ҳ�ǿ��������ģ���Ϊ�����ﻹ���ٴ�һ��
                ns_full(cur_machine)=1;
            end
        else
            disp("error")
            break
        end
    %ͨ���¼�
    elseif (cur_event==6)%����
        next_events(mcc+1,6)=f;%�´ν���ʱ��
        for j =1:1:mcc
            if(ns_full(j)==1)
                %�����´�����ʱ��
                next_events(j,5)=Umax;
            end
        end
        %�����������гͷ�
        ns_full_total=sum(ns_full);
        if (ns+ns_full_total>=q)
            ns=(ns+ns_full_total)-q;
        else
            CPE=CPE+(q-(ns+ns_full_total))*cupe;%������
            ns=0;
        end
        %��Ϊÿ�����ٽ�mcc����������Ĭ��һ����ѻ�����Ļ�����ȥ
    end
    ns_full(:)=0;
    tsim=tsim+pe;
end
CT=CMC+CMP+CPR+CS+CPE;
CM=CT/tsim;
