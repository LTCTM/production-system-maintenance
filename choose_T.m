%Ҫ��forѭ����T���ҵ����T��ʹ������С
%����ĵ�û��д������������
%====���г���====
%��һ������
arr_result=zeros(20,2);
for T=5:5:100
    %====����ԭ���ĵ������====
    
    %----���߼���whileѭ����====
    %ѭ������
    CT=CMC+CMP+CPR+CS+CPE;
    CM=CT/tsim;
    arr_result(T/5,1)=T;
    arr_result(T/5,2)=CM;
end

%�����
min_T=arr_result(arr_result(:,2)==min(arr_result(:,2)),1);
plot(arr_result(:,1),arr_result(:,2))