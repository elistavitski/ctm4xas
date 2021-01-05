function ok=windowCopyToClipboard(handle_window)
try
    jj=get(handle_window);
catch
    errordlg('Invalid window handle. Cannot copy to clipboard','Error');
    return
end
print(handle_window,'-dbitmap');
