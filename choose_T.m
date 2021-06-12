%要用for循环走T，找到最佳T，使花费最小
%这个文档没有写完整，仅表意
%====所有常数====
%加一个变量
arr_result=zeros(20,2);
for T=5:5:100
    %====所有原来的单体变量====
    
    %----主逻辑（while循环）====
    %循环体外
    CT=CMC+CMP+CPR+CS+CPE;
    CM=CT/tsim;
    arr_result(T/5,1)=T;
    arr_result(T/5,2)=CM;
end

%出结果
min_T=arr_result(arr_result(:,2)==min(arr_result(:,2)),1);
plot(arr_result(:,1),arr_result(:,2))