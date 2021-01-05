function setsTag(tagIn,str_in) 
    %sets string into the control bearing tag tagIn
    h1=findobj('Tag',tagIn);
    set(h1,'String',str_in);