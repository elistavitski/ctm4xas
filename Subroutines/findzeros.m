function findzero=findzero(arr_seek)
% FINDSERO Find the value or the closes value 
% in the array and return the index of the value
% IND = FINDVAL(ARR) 
% ARR should be an array with ascending numbers

a_len=length(arr_seek);
n=3;
zerosar=zeros(n,1);
ind=1;
for jj= 1:5;
    for ii= ind:a_len-1,
        if   ((arr_seek(ii)>=0)&(arr_seek(ii+1)<0))
           
            zerosar(jj,1)=ii;
            ind=ii+1 
            break;
        end
    end
end
findzero=zerosar;
