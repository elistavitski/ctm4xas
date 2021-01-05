function bsl_corrected_arr=bsl_corr(arrIn,begin_end, range_bsl) 
    % Baseline correction -
    % bsl_corrected_arr=setsTag(arrIn,begin_end, range_bsl)
    %- - - begin_end
    % 1 points in the beginning
    % 2 points in the end
    
    if begin_end==1,
        bsl_corrected_arr=arrIn-mean(arrIn(1:1+range_bsl));
    elseif begin_end==2,
        bsl_corrected_arr=arrIn-mean(arrIn((end-range_bsl):end));
    end