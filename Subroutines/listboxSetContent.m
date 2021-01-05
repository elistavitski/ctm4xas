function listboxSetContent(listbox_handle, content,varargin)
if isempty(content),
    set(listbox_handle,'String','');
    set(listbox_handle,'Value',[]);
else
    set(listbox_handle,'String',content);
    if length(varargin)>0
        set(listbox_handle,'Value',1);
    else
         set(listbox_handle,'Value',length(content));
    end
end