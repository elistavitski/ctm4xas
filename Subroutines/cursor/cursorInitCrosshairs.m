function cursor_handle=cursorInitCrosshairs(figure_handle,axes_handle, last_known_position,color)
set(0,'CurrentFigure',figure_handle);
set(gcf,'CurrentAxes',axes_handle);
axis_limits=axis;
if isnan(last_known_position)
    x=mean([axis_limits(1) axis_limits(2)]) ;
    y=mean([axis_limits(3) axis_limits(4)]) ;
elseif ~within(last_known_position(1),axis_limits(1),axis_limits(2),'Strict')||...
        ~within(last_known_position(2),axis_limits(3),axis_limits(4),'Strict')
    x=mean([axis_limits(1) axis_limits(2)]) ;
    y=mean([axis_limits(3) axis_limits(4)]) ;
else
    x=last_known_position(1);
    y=last_known_position(2);
end
cursor_handle = impoint(axes_handle, x,y);
api = iptgetapi(cursor_handle);
api.setColor(color);



