function y=getsTag(tagIn) 
%GETSTAG gets string from the control bearing tag tagIn
    h1=findobj('Tag',tagIn);
    y=get(h1,'String');