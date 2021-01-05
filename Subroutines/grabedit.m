function grabedit=grabedit(a_tag)
h1=findobj('Tag',a_tag);
grabedit=str2num(get(h1,'String'));