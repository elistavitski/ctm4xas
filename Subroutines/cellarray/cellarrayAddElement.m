function struc_out=cellarrayAddElement(struc_in, data_in)
if isempty(struc_in)&&isempty(data_in)
    struc_out=[];
elseif isempty(data_in)
    struc_out=struc_in;
else
    if ~iscell(data_in),
        temp{1}=data_in; data_in=temp;
    end
    struc_in_len=length(struc_in);
    for jj=1:length(data_in)
        struc_in{struc_in_len+jj}=data_in{jj};
    end
    struc_out=struc_in;
end



