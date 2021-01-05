function fileList=getFileListFromListbox(ListboxTag)
fileList=get(findobj('Tag',ListboxTag),'String');
if ~iscell(fileList)
    t{1}=fileList;
    clear(fileList);
    fileList=t;
end




    
            
