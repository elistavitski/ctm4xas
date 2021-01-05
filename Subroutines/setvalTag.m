function setvalTag(tagIn,val_in) 
    %Function SETVALTAG sets Value Property into the control bearing tag tagIn
    h1=findobj('Tag',tagIn);
    set(h1,'Value',val_in);