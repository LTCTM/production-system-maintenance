%高维
start_U=0.515;
end_U=0.515;
step_U=0.001;
%低维
start_m=85;
end_m=160;
step_m=5;
%结论:U=0.512-0.519,m=110-155

results=zeros(round((end_U-start_U)/step_U)+1,round((end_m-start_m)/step_m)+1);
for U = start_U:step_U:end_U
    x=round((U-start_U)/step_U)+1;
    for m = start_m:step_m:end_m
        y=round((m-start_m)/step_m)+1;
        results(x,y)=supercell_homework(m,U);
    end
end
%找到花费最小的情况
min_result=min(min(results))
[min_x,min_y]=find(results==min_result);
%数组下标转实际参数
min_U=(min_x-1)*step_U+start_U
min_m=(min_y-1)*step_m+start_m
