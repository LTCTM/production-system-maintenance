function x = exponentielle(L)
    %此处显示有关此函数的摘要
    %   此处显示详细说明
    u=0;
    while(u==0||u==1)
        u=rand();
    end
    x=-log(u)/L;

