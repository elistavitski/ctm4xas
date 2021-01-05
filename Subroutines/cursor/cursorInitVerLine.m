function cursor_handle=cursorInitVerLine(figure_handle,axes_handle, last_known_position,color)
windowSetAsCurrent(figure_handle);
axesSetAsCurrent(axes_handle);
axis_limits=axis;
if isnan(last_known_position)
    x=[mean([axis_limits(1) axis_limits(2)]) mean([axis_limits(1) axis_limits(2)]) ];

elseif ~within(last_known_position,axis_limits(1),axis_limits(2))
        x=[mean([axis_limits(1) axis_limits(2)]) mean([axis_limits(1) axis_limits(2)]) ];
else
    x=[last_known_position last_known_position];
    
end
y_mean=mean([axis_limits(3) axis_limits(4)]);
y_span=  abs(axis_limits(3) - axis_limits(4) ); 
y=[y_mean-y_span*1000 y_mean+y_span*1000];
cursor_handle = imline(axes_handle, x,y);
api = iptgetapi(cursor_handle);
api.setColor(color);



