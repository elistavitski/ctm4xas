function struc_out=cellarrayRemoveElement(struc_in, indx2remove)
    if isempty(struc_in),
        struc_out=[];
        return
    end
    
    if isnan(indx2remove)||indx2remove==0,
        struc_out=struc_in;
        return
    end



    struc_out=[];

    struc_len=length(struc_in);
    if struc_len==1,
        struc_out=[];
    elseif indx2remove==struc_len,
        for jj=1:indx2remove-1,
            struc_out{jj}=struc_in{jj};
        end
    else
        for jj=1:indx2remove-1,
            struc_out{jj}=struc_in{jj};
        end
        for jj=indx2remove+1:struc_len,
            struc_out{jj-1}=struc_in{jj};
        end
    end


