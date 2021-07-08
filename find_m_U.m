%高维
start_U=0.3;
end_U=0.9;
step_U=0.05;
%低维
start_m=25;
end_m=150;
step_m=5;

results=zeros(round((end_U-start_U)/step_U)+1,round((end_m-start_m)/step_m)+1);
for U = start_U:step_U:end_U
    x=round((U-start_U)/step_U)+1;
    for m = start_m:step_m:end_m
        y=round((m-start_m)/step_m)+1;
        results(x,y)=supercell_homework(m,U);
        %dsip("%d\n",results(x,y))
    end
end
%找到发生该下一个事件的机器和内容
min_result=min(min(results))
[min_x,min_y]=find(results==min_result);

min_U=(min_x-1)*step_U+start_U
min_m=(min_y-1)*step_m+start_m
