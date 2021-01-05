function value_out=guicomponentGetValue(component_handle_or_tag)
if ischar(component_handle_or_tag),
    try
        component_handle=findobj('Tag', component_handle_or_tag);
    catch
        errordlg('Invalid component handle','Error');
        return
    end
else
    try
        aa=get(component_handle_or_tag);
    catch
      errordlg('Invalid component handle','Error');
        return
    end
    component_handle=component_handle_or_tag;
end



value_out=get(component_handle,'Value');



            