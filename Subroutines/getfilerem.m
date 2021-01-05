function [fn,dn]= getfilerem(filetr,exts);
% opens the file from the directory 
% given in file (variable filetr) with the extension
% (variable exts) and writes the current directory 
% to the same file 'c:\matlab7\work\recfile.txt'

fid=fopen(filetr);
recfile=fscanf(fid,'%c');
fclose(fid);

recfile=strcat(recfile,exts);
[fn,dn] = uigetfile(recfile, 'Load file...',...
    'MultiSelect', 'on');
if isequal(fn,0)
   return
end


fid=fopen(filetr,'w');
fprintf(fid,'%s',dn);
fclose(fid);

