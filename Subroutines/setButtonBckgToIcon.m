function setButtonBckgToIcon(C_tag,icon_rgb)
if ~iscell(C_tag), C_tag_t{1}=C_tag; C_tag=C_tag_t; end
for jj=1:length(C_tag),
        h=findobj('Tag',C_tag{jj});
        for ii=1:length(h),
            try
                set(h(ii),'CData',icon_rgb);
            catch
            end
        end
end