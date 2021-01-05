function resizeImageDir(DirName,DirName2,newName,preferredW)

% function for resizing the jpeg files stored in a directory:
% DirName: the folder in which the images are stored.
% DirName2: the folder in which the thumbnails will be stored.
% newName: a string to be added in front of all fileNames for the thumbnail
% files
% preferredW: preferred width of the thumbnails

D = dir([DirName '\*.jpg']);
warning off;
for i=1:length(D),
        if (strcmp(newName,'')~=1)            
            newFileName = [DirName '\' DirName2 '\' newName D(i).name(1:end-4) '.jpg'];
        else % replace:                      
            newFileName = [DirName '\' DirName2 '\' D(i).name(1:end-4) '.jpg'];            
        end   
        resizeJPG([DirName '\' D(i).name(1:end-4) '.jpg'],newFileName, preferredW);
        fprintf('\n');
end