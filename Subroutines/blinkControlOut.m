 function out_blink=blinkControl(edit_c,waitfor_c, edit_c_def)
    showControl({edit_c,waitfor_c});
    setsTag(edit_c,edit_c_def);
    waitfor(findobj('Tag',waitfor_c),'Value',1);
    set(findobj('Tag',waitfor_c),'Value',0);
    hideControl({edit_c,waitfor_c});
    out_blink=getsTag(edit_c);