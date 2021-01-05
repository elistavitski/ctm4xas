function [fname, dname]=uiputfileE(fileType,dlgTitle,lastPathFile)
fid=fopen(lastPathFile,'r');
if fid>-1,
    fclose(fid);
    load(lastPathFile,'-mat');
    last_dn=settings.last_dn;
else
    last_dn='';
end
%------------------
[fname, dname] = uiputfile(fileType,...
dlgTitle, strcat(last_dn));
%------------------
if ~isequal(fname,0),
    settings.last_dn=dname;
    save(lastPathFile,'settings')
end