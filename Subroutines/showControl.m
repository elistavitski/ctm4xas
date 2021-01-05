function showControl(inTags)
for jj=1:length(inTags),
    set(findobj('Tag',inTags{jj}),'Visible','on');
end