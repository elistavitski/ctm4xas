function struc_out=add_struc(struc_in, data_in)
    if isempty(struc_in)
        struc_out{1}=data_in;
    else
        struc_len=length(struc_in);
        struc_in{struc_len+1}=data_in;
        struc_out=struc_in;
    end