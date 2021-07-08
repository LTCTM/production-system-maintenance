%高维
start_U=0.515;
end_U=0.515;
step_U=0.001;
%低维
start_m=85;
end_m=170;
step_m=5;
%结论:U=0.512-0.519,m=110-155

results=zeros(round((end_U-start_U)/step_U)+1,round((end_m-start_m)/step_m)+1);
for U = start_U:step_U:end_U
    %Indice de tableau au paramètre réel
    x=round((U-start_U)/step_U)+1;
    for m = start_m:step_m:end_m
        %Indice de tableau au paramètre réel
        y=round((m-start_m)/step_m)+1;
        results(x,y)=supercell_homework(m,U,30000);
    end
end
%找到花费最小的选择
%Trouvez le choix le moins cher
min_result=min(min(results))
%Trouvez l'indice de tableau du choix
[min_x,min_y]=find(results==min_result);
%paramètre réel à l'indice de tableau
min_U=(min_x-1)*step_U+start_U
min_m=(min_y-1)*step_m+start_m
