function findval=findval(arr_seek,vseek)
% FINDVAL Find the value or the closes value 
% in the array and return the index of the value
% IND = FINDVAL(ARR) 
% ARR should be an array with ascending numbers

a_len=length(arr_seek);
ind=1;
%Check whether the value is within the array
if (vseek<min(arr_seek))|(vseek>max(arr_seek)),
    errordlg('The value is not withing the array');
    finval=0;
    return;
end

for ii= 1:a_len-1,
    if (arr_seek(ii)<=vseek)&(arr_seek(ii+1)>vseek),
        break;
    end
end
findval=ii;