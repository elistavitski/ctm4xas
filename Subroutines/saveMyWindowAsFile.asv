function [fname last_directory]=mywindowSaveAsFile(handle_window,dlg_title,varargin)

% function 
last_directory_file_exists=0;
last_directory='';
file_list='';

if strcmp(varargin{1},'LastDirectory'),
    last_directory=varargin{2};
elseif strcmp(varargin{1},'LastDirectoryFile'),
    last_path_file=varargin{2};
    fid=fopen(lastPathFile,'r');
    if fid>-1,
        fclose(fid);
        load(lastPathFile,'-mat');
        last_directory=settings.last_dn;
        last_directory_file_exists=1;
    else
        last_directory='';
    end
    
end
%------------------
[fn,dn]=uiputfile({'*.fig','MATLAB Figures (*.fig)';...
    '*.ai','Adobe Illustrator file (*.ai)'; ...
    '*.eps','EPS file (*.eps)';...
    '*.jpg','JPEG file (*.jpg)'} ...
    ,dlg_titlee,last_directory);
if ~isequal(fn,0)
    [pathstr, name, ext, versn] = fileparts(fname) ;
    switch ext
        case '.fig'
            h_f=get(handle_window,'CloseRequestFcn');
            if strcmp(h_f,'');
                set(handle_window,'CloseRequestFcn','closereq');
                saveas(handle_window,fname)
                set(handle_window,'CloseRequestFcn','');
            else
                saveas(handle_window,fname)
            end
            
        case '.ai'
            saveas(handle_window,fname,'ill')
        case '.jpg'
            saveas(handle_window,fname,'jpg')
        case '.eps'
            saveas(handle_window,fname,'psc2')
    end
end
