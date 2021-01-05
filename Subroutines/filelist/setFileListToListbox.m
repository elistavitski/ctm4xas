function setFileListToListbox(fileList,ListboxTag)
if ~isempty(fileList)
    set(findobj('Tag',ListboxTag),'String',fileList)
end


    
            
