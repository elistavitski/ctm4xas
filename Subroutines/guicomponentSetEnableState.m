function guicomponentSetEnableState(component_handle_or_tag,component_new_state)
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

if ischar(component_new_state)
    if strcmp(component_new_state,'toggle')
        component_enable_status=get(component_handle,'Enable');
        if strcmp(component_enable_status,'on')
            set(component_handle,'Enable','off');
        else
            set(component_handle,'Enable','on');
        end
    else
        errordlg('Incorrect settings for activity status','Error');
        return
    end
else
        if component_new_state
                set(component_handle,'Enable','on');
        else
            set(component_handle,'Enable','off');
        end
    end
            