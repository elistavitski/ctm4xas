function cursorMoveVerLine(cursor_handle, new_position,relative)
if nargin<3
    relative=[];
end
api = iptgetapi(cursor_handle);
axes_handle=get(cursor_handle,'Parent');
axis_limits=axis(axes_handle);
if ~within(new_position,axis_limits(1),axis_limits(2),'Strict')
    new_position=mean([axis_limits(1) axis_limits(2)]);
end
position=api.getPosition();
if isempty(relative)
    position(1,1)=new_position;
    position(2,1)=new_position;
else
    position(1,1)=position(1,1)+new_position;
    position(2,1)=position(2,1)+new_position;
end
api.setPosition(position);