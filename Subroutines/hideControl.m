function hideControl(inTags)
for jj=1:length(inTags),
    set(findobj('Tag',inTags{jj}),'Visible','off');
end