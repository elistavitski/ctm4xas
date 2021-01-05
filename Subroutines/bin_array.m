function arrout=bin_array(arrin,x_bin,y_bin)

    s_arrin=size(arrin);
    for ii=1:floor(s_arrin(1)/x_bin),
        for jj=1:floor(s_arrin(2)/y_bin),
            arrout(ii,jj)=mean(mean(arrin(((ii-1)*x_bin+1):(ii*x_bin),...
                ((jj-1)*y_bin+1):(jj*y_bin))));
        end
    end
    
            