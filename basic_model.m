H=600;%�������ʱ��
cmc=50;%����ά�޷�
mu_c=15;%ά��ʱ��
cmp=35;%����ά����
mu_p=5;%ά��ʱ��
T=60;%ά��Ƶ��
cus=1;%��λʱ�䵥λ��Ʒ�ִ���
cup=40;%����һ����Ʒ�ĳɱ�
cupe=10;%ÿ������ʧ�ܷ���
u_max=20;%����һ����Ʒ����ʱ��
q=1;%������
f=160;%����Ƶ��
nsmax=3;%����
%========
next_events=[next_fail(),NaN,T,T+mu_p,u_max,f];
next_events(2)=next_events(1)+mu_c;
tsim=0;%�ۼ�����ʱ��
status=1;%����ģ��ʱ�������ڡ������С�״̬
full=0;%�Ƿ����ݣ���status����
%��Ҫ����Ľ��
CMC=0;%�ۼ�ά�޷�
CMP=0;%�ۼ�ά����
CPR=cup;%�ۼ������ɱ��������˵�����к���û�����һ����Ʒ�ĳɱ�
CS=0;%�ۼƲִ�
CPE=0;%�ۼƽ���ʧ�ܷ���
CTM=0;%���ս��
ns=0;%�ֿⴢ��

while(tsim<H)
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
        next_events(1)=mu_c+next_fail();%������һ�εĹ���ʱ��
        status=2;%�л���ά����״̬
        next_events(5)=mu_c+next_events(5);%�������жϣ����Ӻ�
        %���ϻ������´�ά��ʱ��
        %��һ����������Ϊ��ѡ��������������
        %���Ϻ�ά�������ܹ�ˢ�¶Է�����һ��Ҫ��ˢ���Լ�������ϵͳ����û��bug
        next_events(3)=T+mu_c;
        next_events(4)=next_events(3)+mu_p;
        %��Ϊά�޿�ʼ�ͻ�Ǯ
        CMC=CMC+cmc;
    elseif (status==2 && cur_event==2)%�������޺���
        next_events(2)=next_events(1)+mu_c;%��һ��ά�����ʱ��
        status=1;%�л���������״̬
    elseif (status==1  && cur_event==3)%�����п�ʼά��
        next_events(3)=T;%������Լ���������´�ά��֮ǰ��������
        status=3;%�л���ά����״̬
        next_events(5)=mu_p+next_events(5);%�������жϣ����Ӻ�
        %ά���������´ι���ʱ��
        next_events(1)=mu_c+next_fail();
        next_events(2)=next_events(1)+mu_c;
        %��Ϊά����ʼ�ͻ�Ǯ
        CMP=CMP+cmp;
    elseif (status==3 && cur_event==4)%ά�����
        next_events(4)=next_events(3)+mu_p;%������һ��ά�����ʱ��
        status=1;%�л���������״̬
    elseif (status==1 && cur_event==5)%������һ����Ʒ
        next_events(5)=u_max;%�´���������Ʒ��ʱ��
        if (ns<nsmax)
            ns=ns+1;%�ֿ���һ����Ʒ
            %��Ϊ��ʼ�����ͼ���ɱ�
            CPR=CPR+cup;
        else
            %�ֿ�����Ҳ�ǿ��������ģ���Ϊ�����ﻹ���ٴ�һ��
            %full=1 ˵�����ڻ����ﻹ��һ����Ʒ
            %ע����������full����˲��ٳ���status=4�����������ȷ������bug
            full=1;
        end
    elseif (cur_event==6)%����
        next_events(6)=f;%�´ν���ʱ��
        %�����������гͷ�
        if (ns+full>=q)
            ns=(ns+full)-q;
        else
            CPE=CPE+(q-(ns+full))*cupe;%������
            ns=0;
        end
        %��Ϊÿ�����ٽ�һ����������Ĭ��һ����ѻ�����Ļ�����ȥ
        full=0;
    else
        disp("error")
        break
    end
    tsim=tsim+pe;
end
%function result=base_arr()
    %result=zeros(200,2)*NaN;
    %result(1,1)=0;
    %result(1,2)=0;
%end
