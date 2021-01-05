function enableControl(inTags)
if iscell(inTags)
    for jj=1:length(inTags),
        set(findobj('Tag',inTags{jj}),'Enable','on');
    end
else
    set(findobj('Tag',inTags),'Enable','on');
end