H=1000000;%�������ʱ��
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
next_events=[next_fail(),NaN,T,T+Up,Umax,f];
next_events(2)=next_events(1)+Uc;
tsim=0;%�ۼ�����ʱ��
status=1;%����ģ��ʱ�������ڡ������С�״̬
ns_full=0;%�Ƿ����ݣ���status����
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
    pe=min(next_events);
    next_events=next_events-pe;
    cur_events=find(next_events==0);
    cur_event=cur_events(1);
    %========��ʽ��ʼ========
    %====���㱾�ֲִ���====
    CS=CS+ns*pe*cus;
    %====�����¼�����״̬====
    if(status==1 && cur_event==1) %�����з�������
        next_events(1)=Uc+next_fail();%������һ�εĹ���ʱ��
        status=2;%�л���ά����״̬
        next_events(5)=Uc+next_events(5);%�����Ӻ�
        %���ϻ������´�ά��ʱ��
        %���Ϻ�ά�������ܹ�ˢ�¶Է�����һ��Ҫ��ˢ���Լ�������ϵͳ����û��bug
        next_events(3)=T+Uc;
        next_events(4)=next_events(3)+Up;
        %��Ϊά�޿�ʼ�ͻ�Ǯ
        CMC=CMC+cmc;
    elseif (status==2 && cur_event==2)%�������޺���
        next_events(2)=next_events(1)+Uc;%��һ��ά�����ʱ��
        status=1;%�л���������״̬
    elseif (status==1  && cur_event==3)%�����п�ʼά��
        next_events(3)=T;%����������´�ά��֮ǰ��������
        status=3;%�л���ά����״̬
        next_events(5)=Up+next_events(5);%�����Ӻ�
        %ά���������´ι���ʱ��
        next_events(1)=Uc+next_fail();
        next_events(2)=next_events(1)+Uc;
        %��Ϊά����ʼ�ͻ�Ǯ
        CMP=CMP+cmp;
    elseif (status==3 && cur_event==4)%ά�����
        next_events(4)=next_events(3)+Up;%������һ��ά�����ʱ��
        status=1;%�л���������״̬
    elseif (status==1 && cur_event==5)%������һ����Ʒ
        next_events(5)=Umax;%�´���������Ʒ��ʱ��
        if (ns<nsmax)
            ns=ns+1;%�ֿ���һ����Ʒ
            %��Ϊ��ʼ�����ͼ���ɱ�
            CPR=CPR+cup;
        else
            %�ֿ�����Ҳ�ǿ��������ģ���Ϊ�����ﻹ���ٴ�һ��
            %ns_full=1 ˵�����ڻ����ﻹ��һ����Ʒ
            %ע����������ns_full����˲��ٳ���status=4�����������ȷ������bug
            ns_full=1;
        end
    elseif (cur_event==6)%����
        next_events(6)=f;%�´ν���ʱ��
        if(ns_full==1)
            %�����´�����ʱ��
            next_events(5)=Umax;
        end
        %�����������гͷ�
        if (ns+ns_full>=q)
            ns=(ns+ns_full)-q;
        else
            CPE=CPE+(q-(ns+ns_full))*cupe;%������
            ns=0;
        end
        %��Ϊÿ�����ٽ�һ����������Ĭ��һ����ѻ�����Ļ�����ȥ
        ns_full=0;
    else
        disp("error")
        break
    end
    tsim=tsim+pe;
end
CT=CMC+CMP+CPR+CS+CPE;
CM=CT/tsim;
