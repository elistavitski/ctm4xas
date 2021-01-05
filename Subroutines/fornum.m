function fornum=fornum(numb)

if (numb>0)&(numb<10),
    stringFor=strcat('0',num2str(numb));
else
    stringFor=num2str(numb);
end
fornum=stringFor;
