function max_e=maxE(arr_in)
  	if abs(max(arr_in))>=abs(min(arr_in))
        max_e=max(arr_in);
    else
        max_e=abs(min(arr_in));
    end
end
   