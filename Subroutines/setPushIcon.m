function setPushIcon(C_tag,icon_file)
if ~iscell(C_tag), C_tag_t{1}=C_tag; C_tag=C_tag_t;end
RGB = imread(icon_file);  
for jj=1:length(C_tag),
        h=findobj('Tag',C_tag{jj});
        for ii=1:length(h),
            try
                set(h(ii),'CData',RGB);
            
            catch
            end
        end
end
