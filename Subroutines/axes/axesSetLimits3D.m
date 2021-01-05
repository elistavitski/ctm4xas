function new_limits=axesSetLimits3D(handles_axes, new_limits)
old_limits=axis(handles_axes);
new_limits(isnan(new_limits))=old_limits(isnan(new_limits));
axis(handles_axes,new_limits);
%handle axis
surf_handle=get(handles_axes,'Children');
ZZ=get(surf_handle,'ZData');
if ~isnan(new_limits(5)),     ZZ(ZZ<new_limits(5))=new_limits(5); end
if ~isnan(new_limits(6)),     ZZ(ZZ>new_limits(6))=new_limits(6); end
set(surf_handle,'ZData',ZZ);


    

