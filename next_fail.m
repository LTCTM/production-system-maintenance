function result=next_fail()
    rr=randn()*30;
    rr=max(rr,-rr);
    result=rr+40;
end
