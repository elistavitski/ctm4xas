function integrated=spectrumIntegrate(spectrum_in, integration_preset) 
    subset_lims=integrationPresetCreateLimitsArray(integration_preset);
    x_axis=spectrum_in.x;
    y_axis=spectrum_in.y;
    point_spacing=abs(x_axis(1)-x_axis(2));
    % locate integration limit indices         
    ind_x(1)=findval_c(x_axis,subset_lims(1));
    ind_x(2)=findval_c(x_axis,subset_lims(2));
    ind_x=sort(ind_x);
    if length(subset_lims)==2,
        integrated=sum(y_axis(ind_x(1):ind_x(2)))*point_spacing;
    elseif length(subset_lims)==4,
        % locate BASELINE limit indices    
        ind_bsl(1)=findval_c(x_axis,subset_lims(3));
        ind_bsl(2)=findval_c(x_axis,subset_lims(4));
        ind_bsl=sort(ind_bsl);
        %determine coefficients
        bsl_x=[x_axis(ind_bsl(1))  x_axis(ind_bsl(2))];
        bsl_y=[y_axis(ind_bsl(1))  y_axis(ind_bsl(2))];
        
        bsl_coef(1)=(bsl_y(2)-bsl_y(1))/(bsl_x(2)-bsl_x(1));
        bsl_coef(2)=((bsl_y(2)+bsl_y(1))-bsl_coef(1)*(bsl_x(2)+bsl_x(1)))/2;
        %calculate baseline
        x_int=x_axis(ind_bsl(1):ind_bsl(2));
        y_int=bsl_coef(1)*x_int+bsl_coef(2);
        
        spectrum_truncated=y_axis(ind_bsl(1):ind_bsl(2));
        integrated=sum(spectrum_truncated-y_int)*point_spacing;
    end
  