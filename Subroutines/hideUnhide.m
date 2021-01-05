function hideUnhide(inTags,inStatus)
for jj=length(inTags),
    h1=findobj('Tag',inTags(jj));
    set(h1,'Visible',inStatus);
end