function [fname, dname]=uigetfileE(fileType,dlgTitle,lastPathFile,multipleFiles)
if nargin<4,
    multipleFiles=0;
end  
fid=fopen(lastPathFile,'r');
if fid>-1,
    fclose(fid);
    load(lastPathFile,'-mat');
    last_dn=settings.last_dn; 
else
    last_dn='';
end
%------------------
if ~multipleFiles
    [fname, dname] = uigetfile(fileType,dlgTitle, strcat(last_dn));
else
    [fname, dname] = uigetfile(fileType,dlgTitle, strcat(last_dn),'MultiSelect','on' );
end
%------------------
if ~isequal(fname,0),
    settings.last_dn=dname;
    save(lastPathFile,'settings')
end