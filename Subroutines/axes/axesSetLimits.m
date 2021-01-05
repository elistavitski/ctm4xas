function new_limits=axesSetLimits(handles_axes, new_limits)
old_limits=axis(handles_axes);
new_limits(isnan(new_limits))=old_limits(isnan(new_limits));
axis(handles_axes,new_limits);


    

