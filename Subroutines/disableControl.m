function disableControl(inTags)
if iscell(inTags)
    for jj=1:length(inTags),
        set(findobj('Tag',inTags{jj}),'Enable','off');
    end
else
    set(findobj('Tag',inTags),'Enable','off');
end