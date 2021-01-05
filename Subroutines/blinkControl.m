 function blinkControl(show_c,waitfor_c)
	showControl({show_c,waitfor_c});
    waitfor(findobj('Tag',waitfor_c),'Value',1);
    set(findobj('Tag',waitfor_c),'Value',0);
    hideControl({show_c,waitfor_c});
    