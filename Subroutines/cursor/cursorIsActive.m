function cursor_active=cursorIsActive(cursor_handle)
try
    api = iptgetapi(cursor_handle);cursor_active=1;
catch
    cursor_active=0;
end


