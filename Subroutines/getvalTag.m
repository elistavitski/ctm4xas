function y=getvalTag(tagIn)
%GETVALTAG gets Value Propertyfrom the control bearing tag tagIn
    h1=findobj('Tag',tagIn);
    y=get(h1,'Value');
    