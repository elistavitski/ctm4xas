function out_str=num2strE4(num_in)
    if (num_in<=9)
        out_str=strcat('000',num2str(num_in));
    elseif (num_in>9)&(num_in<=99)
        out_str=strcat('00',num2str(num_in));
    elseif (num_in>99)&(num_in<=999)
         out_str=strcat('0',num2str(num_in));
    elseif (num_in>999)
         out_str=strcat('',num2str(num_in));
    end
 
