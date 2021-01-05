function setControlIcon(C_tag,icons)
if iscell(C_tag),
    if length(C_tag)~=length(icons),
        disp('Dimensions mismatch');
    else
        for jj=1:length(C_tag),
          set(findobj('Tag',C_tag{jj}),'CData',icons{jj});
        end
    end
else
     set(findobj('Tag',C_tag),'CData',icons);
end