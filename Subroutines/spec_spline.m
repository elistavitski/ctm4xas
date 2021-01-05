function y_spl=spec_spline(x_spec, y_spec, x_pnts)
    x_pnts=sort(x_pnts)
    x_pnts_inc(1)=x_spec(1);
    y_pnts_inc(1)=y_spec(1);
    for jj=1:length(x_pnts),
        x_pnts_inc(jj+1)=x_pnts(jj)
        y_pnts_inc(jj+1)=y_spec(findval(x_spec,x_pnts(jj)
    end
    x_pnts_inc(jj+2)=x_spec(end);
    y_pnts_inc(jj+2)=y_spec(end);
    y_spl=spline(x_pnts_inc,y_pnts_inc,x_spec);