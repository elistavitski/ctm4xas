function is_active=windowIsActive(window_handle)
if isempty(window_handle);
    is_active=0;
else
    try 
        h=get(window_handle);
    catch
        is_active=0;
        return
    end
    is_active=1;
end