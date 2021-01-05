function saved=uiputfile_save(filename,data2save)
[fn,dn]=uiputfile('*.dat','Select file',filename);
saved=0;
if fn ~=0,
    save(strcat(dn,fn),'data2save','-ascii');
    saved=1;
end