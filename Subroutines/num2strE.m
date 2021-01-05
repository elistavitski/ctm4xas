function out_str=num2strE(num_in)
    if num_in<10
        out_str=strcat('0',num2str(num_in));
    else
        out_str=num2str(num_in);
    end
 
