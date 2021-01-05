function findval=findval(arr_seek,vseek)
% FINDVAL Find the value or the closes value 
% in the array and return the index of the value
% IND = FINDVAL(ARR) 
% ARR should be an array with ascending numbers

arr_diff=arr_seek-vseek;
[C,findval]=min(abs(arr_diff));
