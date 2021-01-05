function folderName=getFolderFromDialog(dlgTitle,lastPathFile)
if nargin<2,
    last_dn='';
else
    fid=fopen(lastPathFile,'r');
    if fid>-1,
        fclose(fid);
        load(lastPathFile,'-mat');
        last_dn=settings.last_dn;
    else
        last_dn='';
    end
end
folderName = uigetdir(last_dn,dlgTitle);

%------------------
if ~isequal(folderName,0),
    settings.last_dn=folderName;
    save(lastPathFile,'settings')
else
    folderName='';
end
    