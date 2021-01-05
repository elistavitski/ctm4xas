function setvTag(tagIn,val_in) 
    %sets numeric value into the control bearing tag tagIn
    h1=findobj('Tag',tagIn);
    set(h1,'String',num2str(val_in));