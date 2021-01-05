function component_status=checkboxGetStatus(component_handle_or_tag)
if ischar(component_handle_or_tag),
    try
        component_handle=findobj('Tag', component_handle_or_tag);
    catch
        errordlg('Invalid component handle.','Error');
        component_status=NaN;
        return
    end
else
    try
        jj=get(component_handle_or_tag);
    catch
      errordlg('Invalid component handle.','Error');
        component_status=NaN;
        return
    end
    component_handle=component_handle_or_tag;
end



component_status=get(component_handle,'Value');
