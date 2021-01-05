function y=getvTag(tagIn)
%GETVTAG gets numeric value from the control bearing tag tagIn
    h1=findobj('Tag',tagIn);
    a=get(h1,'String');
    y=str2num(get(h1,'String'));
    