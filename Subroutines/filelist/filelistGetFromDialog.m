function [file_list last_directory] =filelistGetFromDialog(fileType,dlgTitle,varargin)
% function
last_directory_file_exists=0;
last_directory='';
file_list='';

if strcmp(varargin{1},'LastDirectory'),
    last_dn=varargin{2};
elseif strcmp(varargin{1},'LastDirectoryFile'),
    last_path_file=varargin{2};
    fid=fopen(last_path_file,'r');
    if fid>-1,
        fclose(fid);
        load(last_path_file,'-mat');
        last_dn=settings.last_dn;
        last_directory_file_exists=1;
    else
        last_dn='';
    end
    
end

    [fname, dname] = uigetfile(fileType,dlgTitle, strcat(last_dn),'MultiSelect','on' );

    if ~isequal(dname,0),
        last_directory=dname;
        if last_directory_file_exists
            settings.last_dn=dname;
            save(last_path_file,'settings')
        end
        %--------
        if iscell(fname)
            for jj=1:length(fname)
                file_list{jj}=[dname fname{jj}];
            end
        else
            file_list{1}=[dname fname];
        end
    end
if ~isempty(file_list),
file_list=sortcell( file_list');
end