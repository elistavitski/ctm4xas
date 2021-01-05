function window_handle=windowSetAsCurrent(window_handle)
try 
    jj=get(window_handle);
catch
    errordlg('Invalid window handle.','Error');
    return
end
set(0,'CurrentFigure',window_handle);
