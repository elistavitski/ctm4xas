function [x1,x2]=sort2(x1,x2)
if x1>x2,
    t=x1;
    x2=x1; 
    x1=t;
end