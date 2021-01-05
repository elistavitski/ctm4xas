function varargout = ctm4xas522(varargin)
 
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_frank03_01_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_frank03_01_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

%% Initiation of the controls
function gui_frank03_01_OpeningFcn(hObject, eventdata, handles, varargin)
    echo off
    fclose all;
    
    delete('ftn*'); delete('FTN*'); delete('temp*');delete('fort*'); delete('*.m14'); delete('*.m15');
    %initialize list of configurations for multiplet calculations
    h2=findobj('Tag','periodic_table');
    close(h2)
    %set positions of auxillary windows
    h1=findobj('Tag','gui_frank_main'); h1pos=get(h1,'position');
    set(h1,'position',[h1pos(1) h1pos(2) 622 h1pos(4)]);
    hideControl({'batch_panel' 'analize_panel' 'fit_panel'})
    h1=findobj('Tag','plot_panel'); 
    set(h1,'position',[78.4 3.9 44.2 27 ]);
    h1=findobj('Tag','batch_panel'); 
    set(h1,'position',[78.4 3.9 44.2 27 ]);
    h1=findobj('Tag','analize_panel'); 
    set(h1,'position',[78.4 3.9 44.2 27 ]);
    h1=findobj('Tag','fit_panel'); 
    set(h1,'position',[78.4 3.9 44.2 27 ]);
    hideControl({'stop_batch'});
    handles.Configurations=read_config_file;
    load('Resources\ctm4xas5.cfg','-mat')
     setsTag('element',settings.ion);
     setvalTag('auto_name',0);
    %setsTag('element','Ti2+');
    handles=update_config(handles);
    update_fields(handles);
    handles.batch=0;
    handles.color_order=1;
    handles.files2plot='';
    handles.num_files2plot=0;
    %setsTag('plot_file_name','');
    handles.plot_file='';
    handles.params_save=0;
    handles_report=0;
    handles.output = hObject;
    handles.anl_file_loaded=0;
    handles=collect_param(handles);
    guidata(hObject, handles);
    credits
   
function varargout = gui_frank03_01_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
%% Read new configurations file
function config_list=read_config_file
    fid=fopen('Resources\Configurations.txt');
    C=textscan(fid,'%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f  %f %f %f %f %f %f %f');
    for jj=1:length(C{1})
        temp=C{1}; config_temp{1}=temp{jj};
        temp=C{2}; config_temp{2}=temp(jj);
        temp=C{3}; config_temp{3}=temp(jj);
        temp=C{4}; config_temp{4}=temp(jj); 
        temp=C{5}; valence=temp(jj);
        corr_fac=(valence-2)*1.5;
        %1s
        temp=C{6};               config_temp{5}=temp(jj)+corr_fac;
        %2s
        temp=C{7};               config_temp{6}=temp(jj)+corr_fac;
        %2p
        temp=C{8}; temp1=C{9};   config_temp{7}=(temp(jj)+2*temp1(jj))/3+corr_fac;
        %3s
        temp=C{10};              config_temp{8}=temp(jj)+corr_fac;
        %3p
        temp=C{11}; temp1=C{12}; config_temp{9}=(temp(jj)+2*temp1(jj))/3+corr_fac;
        %3d
        temp=C{13}; temp1=C{14}; config_temp{10}=(2*temp(jj)+3*temp1(jj))/5+corr_fac;
        %4s
        temp=C{15};              config_temp{11}=temp(jj)+corr_fac;
        %4p
        temp=C{16}; temp1=C{17}; config_temp{12}=(temp(jj)+2*temp1(jj))/3+corr_fac;
        %4d
        temp=C{18}; temp1=C{19}; config_temp{13}=(2*temp(jj)+3*temp1(jj))/5+corr_fac;
        %5s
        temp=C{20};              config_temp{14}=temp(jj)+corr_fac;
        %5p
        temp=C{21}; temp1=C{22}; config_temp{15}=(temp(jj)+2*temp1(jj))/3+corr_fac;
        %5d
        temp=C{23}; temp1=C{24}; config_temp{16}=(2*temp(jj)+3*temp1(jj))/5+corr_fac;
        config_list{jj}=config_temp;
    end  
 
%% Execution of the Fortran scripts
function calc_spec_Callback(hObject, eventdata, handles)
    if ChBxStatus('cleanup'), cleanup=1; else cleanup=0; end
    if handles.ion_found==0,
        errordlg('Configuration not found','Error')
    else
        curr_config=handles.Configurations{handles.currentConfigNum};
        if ChBxStatus('xas_2p')||ChBxStatus('xps_2p') % 2p XAS, 2p XPS
            bindE=curr_config{7};
        elseif ChBxStatus('xas_3p')||ChBxStatus('xps_3p')   %3p XAS, 3p XPS
            bindE=curr_config{9};
        elseif ChBxStatus('xas_4p')  %4p XAS
            bindE=curr_config{12};
        elseif ChBxStatus('xas_3d')   %  3d XAS
            bindE=curr_config{10};
        elseif ChBxStatus('xas_4d')  %  4d XAS
            bindE=curr_config{13};
        elseif ChBxStatus('xas_5d')   %  5d XAS
            bindE=curr_config{16};
        elseif ChBxStatus('xas_1s')||ChBxStatus('xps_1s') % 1s XAS, 1s XPS
            bindE=curr_config{5};
        elseif ChBxStatus('xps_2s')  %2s XPS
            bindE=curr_config{6};
        elseif ChBxStatus('xps_3s')
            bindE=curr_config{8};
        elseif ChBxStatus('xes_1s2p') %1s2p XES
            bindE=curr_config{5}-curr_config{7};
        elseif ChBxStatus('xes_1s3p') %1s3p XES
            bindE=curr_config{5}-curr_config{9};
        else
            bindE=0;
        end
        if ~ChBxStatus('batch_panel_on')
            handles.batch=0;
        end
        
        if handles.batch
            fn=handles.batch_fn;
            dn=handles.batch_dn;
        elseif ChBxStatus('auto_name')
            [fn,dn]=autoname(handles);
        else
           [fn,dn]=uiputfileE('*.rcg','Select output file name','Resources\ctm4xas5.cfg');
        end   
        if fn ~= 0,        
            if ~strcmp(fn(end-3:end),'.rcg'), fn=[fn '.rcg']; end
            hbar = waitbar(0,'Please wait...');
            setsTag('status_line','Calculating...');
            fname=strcat(dn,fn);
            handles=collect_param(handles); 
            [pathstr,name,ext,versn] = fileparts(fname);
           
            %save parameters
            handles.params_save=1;
            handles.param_file=fullfile(pathstr,[name '.param' versn]);
            save_param_menu_Callback(hObject, eventdata, handles)
            %end save parameters
           
            if ~handles.CT
                if ~handles.RIXS
                    if ~handles.F4
                        [pars_ini,pars_fin,output_fname,bundle_files]=exe_flow_noCT(handles,fname,0,0);
                    else
                        [pars_ini,pars_fin,output_fname, bundle_files]=exe_flow_noCT_F(handles,fname,0,0);
                    end
                    file2autoplot=output_fname;
                else %case of RIXS
                    name1=strcat(name,'_abs');fname1=fullfile(pathstr,[name1 '.rcg' versn]);
                    name2=strcat(name,'_ems');fname2=fullfile(pathstr,[name2 '.rcg' versn]);
                    if handles.RIXS_QUAD, handles.QUAD=1; end %if 1s RIXS, first transition is quadrupole
                    [pars_ini,pars_fin,output_fname]=exe_flow_noCT(handles,fname1,0,0);
                    if handles.RIXS_QUAD, %if 1s RIXS, second transition is not quadrupole
                        handles.QUAD=0; 
                        handles.XES=1;
                        [pars_ini,pars_fin,output_fname]=exe_flow_noCT(handles,fname2,1,1);
                    else
                        [pars_ini,pars_fin,output_fname]=exe_flow_noCT(handles,fname2,1,0);
                    end
                end
            else %case of CT
                fname=fullfile(pathstr,[name '.rcg' versn]);
                name1=strcat(name,'_1');fname1=fullfile(pathstr,[name1 '.rcg' versn]);
                name2=strcat(name,'_2');fname2=fullfile(pathstr,[name2 '.rcg' versn]);
                
                %file 1
                create_ftn10(handles,0) % 0 mean no CT
                ! bin\rcn31.exe
                if ~cleanup
                    movefile('ftn10',fullfile(pathstr,[name1 '.rcn' versn]));
                    bundle_files{10}=fullfile(pathstr,[name1 '.rcn' versn]);
                end
                copyfile('bin\rcn2.inp' ,'ftn10')
                ! bin\rcn2.exe
                copyfile('ftn11','temp1.rcg') %skips .rcf file and writes directly to .rcg
                [pars_ini1,pars_fin1]=update_rcg_file('temp1.rcg',handles,0);
                if ~cleanup
                    copyfile('temp1.rcg',fullfile(pathstr,[name1 '.rcg' versn]));
                    bundle_files{8}=fullfile(pathstr,[name1 '.rcg' versn]);
                end
                waitbar(0.2)
                %file 2
                create_ftn10(handles,1) % 1 mean mixed CT
                ! bin\rcn31.exe
                if ~cleanup
                    movefile('ftn10',fullfile(pathstr,[name2 '.rcn' versn]));
                    bundle_files{11}=fullfile(pathstr,[name1 '.rcn' versn]);
                end
                copyfile('bin\rcn2.inp' ,'ftn10')
                ! bin\rcn2.exe
                movefile('ftn11','temp2.rcg') %skips .rcf file and writes directly to .rcg
                [pars_ini2,pars_fin2]=update_rcg_file('temp2.rcg',handles,0);
                if ~cleanup
                    copyfile('temp2.rcg',fullfile(pathstr,[name2 '.rcg' versn]));
                    bundle_files{9}=fullfile(pathstr,[name1 '.rcg' versn]);
                end
                waitbar(0.4)
                %combing two rcg files
                create_rcg_ct('temp_ct.rcg','temp1.rcg','temp2.rcg',handles)
                if ~cleanup
                    copyfile('temp_ct.rcg',fullfile(pathstr,[name '.rcg' versn]));
                    bundle_files{4}=fullfile(pathstr,[name '.rcg' versn]);
                end
                copyfile('temp_ct.rcg','ftn10')
                ! bin\rcg9.exe;
                if ~cleanup
                    copyfile('FTN09', fullfile(pathstr,[name '.org' versn]))
                    bundle_files{6}=fullfile(pathstr,[name '.org' versn]);
                end
                copyfile('ftn14','temp.m14')
                 % source of the error #1- with XES should be SHELL2 SPIN2
                 % in the .rac file
                if handles.XES
                    copyfile('Resources\templateXES_ct.rac', 'temp.rac','f');
                elseif handles.QUAD
                    copyfile('Resources\templateQuadCT.rac','temp.rac','f');
                else
                    copyfile('Resources\template_ct.rac', 'temp.rac','f');
                end
                racer_run=strcat('bin\racer.exe temp.m14 temp.ora <','temp.rac');
                %! bin\racer.exe temp.m14 temp.ora <temp.rac
                dos(racer_run)
                movefile('rmeout','FTN15')
                create_ban('temp.ban', handles);
                copyfile('temp.ban','fort.50')
                
                copyfile('temp.m14','FTN14')
                if ~cleanup
                    copyfile('temp.rac',fullfile(pathstr,[name '.rac' versn]))
                    bundle_files{5}=fullfile(pathstr,[name '.rac' versn]);
                    bundle_files{7}=fullfile(pathstr,[name '.ban' versn]);
                    copyfile('fort.50',fullfile(pathstr,[name '.ban' versn]))
                end
                ! bin\Ander.exe; 
                waitbar(0.8)
                if handles.QUAD
                    output_fname=fullfile(pathstr,[name '.oca' versn]);
                elseif  handles.XES
                    output_fname=fullfile(pathstr,[name '.ofa' versn]);                  
                else
                    output_fname=fullfile(pathstr,[name '.oba' versn]);
                end
                movefile('fort.44',output_fname);
                handles.oba_file=output_fname;
                pars_ini{1}=pars_ini1; pars_ini{2}=pars_ini2;pars_fin{1}=pars_fin1; pars_fin{2}=pars_fin2;
                if ChBxStatus('bundle')
                    bundle_files{1}=output_fname;
                    bundle_files{2}=fullfile(pathstr,[name '.nfo' versn]);
                    bundle_files{3}=fullfile(pathstr,[name '.param' versn]);
                    handles.oba_file=0;

                else
                    bundle_files='';
                    file2autoplot=output_fname;
                end
                
            end
            if ~handles.RIXS
                create_nfo_file(fname,handles,bindE,pars_ini,pars_fin,ChBxStatus('radio_ct'));
            end
            
            if ChBxStatus('bundle')&&(~handles.RIXS),
                 file2autoplot=make_bundles(bundle_files,cleanup);
                 
            end
            
          
            %autoplot
            if ChBxStatus('autoplot')
                curr_files2plot=getsTag('plot_file_name');
                if isempty(curr_files2plot)
                    curr_files2plot{1}=file2autoplot;
                    setvalTag('plot_file_name',1);
                    setsTag('plot_file_name',curr_files2plot);
                else
                    curr_files2plot{length(curr_files2plot)+1}=file2autoplot;
                    setsTag('plot_file_name',curr_files2plot);
                    setvalTag('plot_file_name',length(curr_files2plot));
                end
                plot_spec_Callback(hObject, eventdata, handles)
            end
            waitbar(1)
            close(hbar)    
            
        end
    setsTag('status_line','Done!');
    fclose all;

    handles.params_save=0;
    guidata(hObject, handles);
    
    end
    delete('ftn*'); delete('FTN*'); delete('temp*');delete('fort*'); delete('*.m14'); delete('*.m15');

%% Executables flow no CT
function [pars_ini,pars_fin,output_fname, bundle_files]=exe_flow_noCT(handles,fname,rixs_ae,rixs_quad)
        % rixs_ae indicates whether it's and ABS or EMS file
        % in EMS file the configuration lines are swapped
        % in the case of RIXS_QUAD they aren't
        [pathstr,name,ext,versn] = fileparts(fname);
        create_ftn10(handles,rixs_quad) % rixs_quad 0 means regular file handling, 1 - config strings
                                        % are taken from the excited state fields
        cleanup=ChBxStatus('cleanup');                      
        ! bin\rcn31.exe
        %movefile('ftn10',fname);
        copyfile('bin\rcn2.inp' ,'ftn10')
        ! bin\rcn2.exe
        waitbar(0.2)
        copyfile('ftn11','ftn10') %skips .rcf file and writes directly to .rcg
        if handles.RIXS_QUAD, rixs_ae=0; end 
        [pars_ini,pars_fin]=update_rcg_file('ftn10',handles,rixs_ae);
        %start handling .rcg file
        
        if ~cleanup
            
            copyfile('ftn10',fullfile(pathstr,[name '.rcg' versn]));
        end
        ! bin\rcg9.exe;
        waitbar(0.4)
        movefile('ftn14', 'temp.m14')
        if ~cleanup
            movefile('ftn09', fullfile(pathstr,[name '.org' versn]))
        end
        %Here we start excecuting rac file
        if handles.QUAD
            update_rac_file('Resources\templateQuad.rac',handles,42);
        elseif handles.F4
            update_rac_file('Resources\template4F.rac',handles,15);
        elseif handles.RIXS
            update_rac_file('Resources\templateRIXS.rac',handles,39);
        elseif handles.XES&&handles.d0
            update_rac_file('Resources\templateXESd0.rac',handles,23);    
        elseif handles.D3d
            update_rac_file('Resources\templateD3.rac',handles,39);
        else
            update_rac_file('Resources\template.rac',handles,39);
        end
        ! bin\racer.exe temp.m14 temp.ora <temp.rac
        waitbar(0.8)
        fclose all
        if handles.QUAD
            output_fname=fullfile(pathstr,[name '.oqa' versn]);
        elseif  handles.XES
            output_fname=fullfile(pathstr,[name '.oea' versn]);
        elseif  handles.F4
            output_fname=fullfile(pathstr,[name '.oda' versn]);    
        else
            output_fname=fullfile(pathstr,[name '.ora' versn]);
        end
        copyfile('temp.ora',output_fname);

        if ~cleanup
            copyfile('temp.rac',fullfile(pathstr,[name '.rac' versn]))  
        end
        if ChBxStatus('bundle')
            bundle_files{1}=output_fname;
            bundle_files{3}=fullfile(pathstr,[name '.param' versn]);
            bundle_files{2}=fullfile(pathstr,[name '.nfo' versn]);
            if ~cleanup
                bundle_files{4}=fullfile(pathstr,[name '.rcg' versn]);
                bundle_files{5}=fullfile(pathstr,[name '.rac' versn]);
                bundle_files{6}=fullfile(pathstr,[name '.org' versn]);
            end
        else
             bundle_files='';
        end
        
%% Executables flow no CT for F-elements
function [pars_ini,pars_fin,output_fname,bundle_files]=exe_flow_noCT_F(handles,fname,rixs_ae,rixs_quad)
        % rixs_ae indicates whether it's and ABS or EMS file
        % in EMS file the configuration lines are swapped
        % in the case of RIXS_QUAD they aren't
        [pathstr,name,ext,versn] = fileparts(fname);
        create_ftn10(handles,rixs_quad) % rixs_quad 0 means regular file handling, 1 - config strings
                                        % are taken from the excited state fields
                               
        ! bin\rcn31.exe
     %   movefile('ftn10',fname);
        copyfile('bin\rcn2.inp' ,'ftn10')
        ! bin\rcn2.exe
        copyfile('ftn11','ftn10') %skips .rcf file and writes directly to .rcg
        if handles.RIXS_QUAD, rixs_ae=0; end 
        [pars_ini,pars_fin]=update_rcg_file('ftn10',handles,rixs_ae);
        %start handling .rcg file
        if ~ChBxStatus('cleanup')
             copyfile('ftn10',fullfile(pathstr,[name '.rcg' versn]))
        end
        ! bin\rcg9.exe;
        output_fname=fullfile(pathstr,[name '.oda' versn]);    
        movefile('ftn09', output_fname);
        if ChBxStatus('bundle')
            bundle_files{1}=output_fname;
            bundle_files{3}=fullfile(pathstr,[name '.param' versn]);
            bundle_files{2}=fullfile(pathstr,[name '.nfo' versn]);
            bundle_files{4}=fullfile(pathstr,[name '.rcg' versn]);
        else
            bundle_files='';
        end
    
%% Execution of the sub-modules
% Create ftn10 file for rcf routine
function create_ftn10(handles,ct12)
    current_config=handles.Configurations{handles.currentConfigNum}; 
    atom_number=current_config{2};

    config=current_config{1};
    if ct12
        init_state=getsTag('init_state_ct'); final_state=getsTag('final_state_ct');
        init_state=init_state(1:9); 
        if handles.XPS
            final_state=final_state(1:14);
        else
            final_state=final_state(1:9);
        end
    else
        init_state=getsTag('init_state'); final_state=getsTag('final_state');
    end
    l_cfg=length(config);
    if l_cfg ==2,
        config=strcat(config,{'  '});
        config=config{1};
    elseif l_cfg ==3,
        config=strcat(config,{' '});
        config=config{1};
    end
        
    fid=fopen('ftn10','wt');
    if handles.XPS
         fprintf(fid,'22 -9    2   10  1.0    5.E-06    1.E-09-2   130   1.0  0.65  62.0 0.50 0.0  0.70 \n');
         fprintf(fid,'%s %u %s %s %s %s %s \n','  ',atom_number,'   ',config,init_state,'       ',init_state);
         fprintf(fid,'%s %u %s %s %s %s %s %s %2.1f \n','  ',atom_number,'   ',config,final_state,'  ',final_state',...
             '                            ',62.0);
    else
         fprintf(fid,'22 -9    2   10  1.0    5.E-06    1.E-09-2   130   1.0  0.65  0.0 0.50 0.0  0.70 \n');
         fprintf(fid,'%s %u %s %s %s %s %s \n','  ',atom_number,'   ',config,init_state,'       ',init_state);
         fprintf(fid,'%s %u %s %s %s %s %s \n','  ',atom_number,'   ',config,final_state,'       ',final_state);
    end
  
    fprintf(fid,'%s %d \n','  ',-1);
    
    fclose(fid);

% create RCG file for CT    
function create_rcg_ct(fname,fname1,fname2,handles) %
    space_string='                                 ';
    current_config=handles.Configurations{handles.currentConfigNum}; 
    element=current_config{1};
    pGr=current_config{3} ; %p electrons in ground state
    dGr=current_config{4} ; %d electrons in ground state
    
    fid2=fopen(fname,'wt');
    tline1   =  '    0                         80998080            8065.47900     000000';
    tline2   =  '  10             14    0    0    1    1 INTER0                           ';
    tline2q   =  '  10             14    0    0    2    2 INTER0                           ';
    tline22  =  '  10             14    0    4    0    4  SHELL30000000 SPIN30000000 INTER2';
    tline22_q  =  '  10             14    0    4    0    4  SHELL03000000 SPIN03000000 INTER2';
    tline23_e  =  '  10             14    0    4    0    4  SHELL03000000 SPIN03000000 INTER3';
    tline3_2  = '   1     2 1 12 1 10         00      9 00000000 0 8065.4790 .00       1  ';
    tline3_3=  '   1     3 1 13 1 10         00      9 00000000 0 8065.4790 .00       1  ';
    tline3_4=  '   1     4 1 14 1 10         00      9 00000000 0 8065.4790 .00       1  ';

    tline99  =  '                    -99999999.';
    tline_end=  '   -1';

    %opening first file
    fid_rcg1=fopen(fname1,'r');
    for ii=1:5, fgets(fid_rcg1); end
    [rcg1_line1,extra_flag11,rcg1_line1extra]=update_rcg_string(handles,fid_rcg1);
    [rcg1_line2,extra_flag12,rcg1_line2extra]=update_rcg_string(handles,fid_rcg1);
    fclose(fid_rcg1);
    
    %opening second file
    fid_rcg2=fopen(fname2,'r');
    for ii=1:5, fgets(fid_rcg1); end
    [rcg2_line1,extra_flag21,rcg2_line1extra]=update_rcg_string(handles,fid_rcg2);
    [rcg2_line2,extra_flag22,rcg2_line2extra]=update_rcg_string(handles,fid_rcg2);
    fclose(fid_rcg2);
    
    if handles.XPS_1s
        [rcg1_line1,extra_flag11,rcg1_line1extra]=discard_zeros_xps_s(rcg1_line1,extra_flag11,rcg1_line1extra);
        [rcg1_line2,extra_flag12,rcg1_line2extra]=discard_zeros_xps_s(rcg1_line2,extra_flag12,rcg1_line2extra);
        [rcg2_line1,extra_flag21,rcg2_line1extra]=discard_zeros_xps_s(rcg2_line1,extra_flag21,rcg2_line1extra);
        [rcg2_line2,extra_flag22,rcg2_line2extra]=discard_zeros_xps_s(rcg2_line2,extra_flag22,rcg2_line2extra);  
    end

    % writes four sections of CT rcg file
    %1
    if handles.XPS
        fprintf(fid2,'%s\n %s\n %s\n' ,tline1, tline2, tline3_3);
    elseif handles.QUAD
        fprintf(fid2,'%s\n %s\n %s\n' ,tline1, tline2q, tline3_3);
    elseif handles.XES
        fprintf(fid2,'%s\n %s\n %s\n' ,tline1, tline2, tline3_3);
    else
        fprintf(fid2,'%s\n %s\n %s\n' ,tline1, tline2, tline3_2);
    end
    if handles.XPS
        if handles.XPS_1s==0,
            tline_config1=make_config_string(pGr,dGr,0,0); 
            tline_config2=make_config_string(pGr-1,dGr,0,1);
        else
            tline_config1=make_config_string_s(dGr,2,-1,0); 
            tline_config2=make_config_string_s(dGr,1,-1,1);
        end
    elseif handles.QUAD
        tline_config1=make_config_string_q(2,dGr,10); 
        tline_config2=make_config_string_q(1,dGr+1,10); 
    elseif handles.XES
        tline_config1=make_config_string_e(1,dGr,6,0,0,0,1); 
        tline_config2=make_config_string_e(2,dGr,5,0,0,0,1); 
    else
        tline_config1=make_config_string(pGr,dGr,0,-1); 
        tline_config2=make_config_string(pGr-1,dGr+1,0,-1); 
    end

    fprintf(fid2,'%s\n',tline_config1{1});
    fprintf(fid2,'%s\n',tline_config2{1});
    tline=strcat(element,{'  '},'1',{' '},'1');fprintf(fid2,'%s\n',tline{1});
    tline=strcat(element,{'  '},'1',{' '},'2');fprintf(fid2,'%s\n',tline{1});
    fprintf(fid2,'%s\n' ,tline99); 
    
    %2
    if handles.XPS
        fprintf(fid2,'%s\n %s\n %s\n' ,tline1, tline2, tline3_4); 
    elseif handles.QUAD
        fprintf(fid2,'%s\n %s\n %s\n' ,tline1, tline2q, tline3_3); 
    elseif handles.XES
        fprintf(fid2,'%s\n %s\n %s\n' ,tline1, tline2, tline3_4); 
    else
        fprintf(fid2,'%s\n %s\n %s\n' ,tline1, tline2, tline3_3); 
    end
    if handles.XPS,
        if handles.XPS_1s==0,
            tline_config1=make_config_string(pGr,dGr+1,9,0); 
            tline_config2=make_config_string(pGr-1,dGr+1,9,1); 
        else
            tline_config1=make_config_string_s(dGr+1,2,9,0); 
            tline_config2=make_config_string_s(dGr+1,1,9,1);
        end
    elseif handles.QUAD
        tline_config1=make_config_string_q(2,dGr+1,9); 
        tline_config2=make_config_string_q(1,dGr+2,9); 
    elseif handles.XES
        tline_config1=make_config_string_e(1,dGr+1,6,9,0,0,0); 
        tline_config2=make_config_string_e(2,dGr+1,5,9,0,0,0);   
    else
        tline_config1=make_config_string(pGr,dGr+1,9,-1); 
        tline_config2=make_config_string(pGr-1,dGr+2,9,-1); 
    end

    fprintf(fid2,'%s\n',tline_config1{1});
    fprintf(fid2,'%s\n',tline_config2{1});
    tline=strcat(element,{'  '},'1',{' '},'3');fprintf(fid2,'%s\n',tline{1});
    tline=strcat(element,{'  '},'2',{' '},'3');fprintf(fid2,'%s\n',tline{1});
    fprintf(fid2,'%s\n' ,tline99);  
        
    %3
    if handles.QUAD
        fprintf(fid2,'%s\n %s\n %s\n' ,tline1, tline22_q, tline3_3);
    elseif handles.XES
        fprintf(fid2,'%s\n %s\n %s\n' ,tline1, tline22_q, tline3_3);
    else
        fprintf(fid2,'%s\n %s\n %s\n' ,tline1, tline22, tline3_3);
    end
    if handles.XPS,
        if handles.XPS_1s==0,
            tline_config1=make_config_string(pGr,dGr,10,-1);
            tline_config2=make_config_string(pGr,dGr+1,9,-1);
        else
            tline_config1=make_config_string_s(dGr,2,10,-1);
            tline_config2=make_config_string_s(dGr+1,2,9,-1);
        end
    elseif handles.QUAD
        tline_config1=make_config_string_q(2,dGr,10); 
        tline_config2=make_config_string_q(2,dGr+1,9); 
    elseif handles.XES
        tline_config1=make_config_string_e(1,dGr,6,10,0,1,0); 
        tline_config2=make_config_string_e(1,dGr+1,5,9,0,1,0);   
    else
        tline_config1=make_config_string(pGr,dGr,10,-1);
        tline_config2=make_config_string(pGr,dGr+1,9,-1);
    end
    fprintf(fid2,'%s\n',tline_config1{1});
    fprintf(fid2,'%s\n',tline_config2{1});
 
    tline=strcat(element,make_short_config_string(pGr,dGr,0));
    ll=length(tline); spacer=space_string(1:(19-ll));
    tline=strcat(tline,{spacer},rcg1_line1); tline=tline{1};
    fprintf(fid2,'%s\n',tline);
    if extra_flag11==1, 
        if handles.XPS
            fprintf(fid2,'%s',rcg1_line1extra); 
        else
            fprintf(fid2,'%s\n',rcg1_line1extra);
        end
    end
    
    tline=strcat(element,make_short_config_string(pGr-1,dGr+1,0));
    ll=length(tline); spacer=space_string(1:(19-ll));
    tline=strcat(tline,{spacer},rcg2_line1); tline=tline{1};
    fprintf(fid2,'%s\n',tline);
    if extra_flag21==1, 
        if handles.XPS
            fprintf(fid2,'%s\n',rcg2_line1extra); 
        else
            fprintf(fid2,'%s',rcg2_line1extra); 
        end
    end
    fprintf(fid2,'%s\n' ,tline99);  
    
    
    
    %4
    if handles.QUAD
        fprintf(fid2,'%s\n %s\n %s\n' ,tline1, tline22_q, tline3_3);
    elseif handles.XPS
            fprintf(fid2,'%s\n %s\n %s\n' ,tline1, tline22, tline3_4);


    elseif handles.XES
  %           fprintf(fid2,'%s\n %s\n %s\n' ,tline1, tline23_e, tline3_4);
            fprintf(fid2,'%s\n %s\n %s\n' ,tline1, tline22_q, tline3_3);
    else
            fprintf(fid2,'%s\n %s\n %s\n' ,tline1, tline22, tline3_3);
    end
    if handles.XPS,
        if handles.XPS_1s==0,
            tline_config1=make_config_string(pGr-1,dGr,10,1);
            tline_config2=make_config_string(pGr-1,dGr+1,9,1);
        else
            tline_config1=make_config_string_s(dGr,1,10,1);
            tline_config2=make_config_string_s(dGr+1,1,9,1);
        end
    elseif handles.QUAD
        tline_config1=make_config_string_q(1,dGr+1,10); 
        tline_config2=make_config_string_q(1,dGr+2,9); 
    elseif handles.XES
                 tline_config1=make_config_string_e(1,dGr,5,10,1,0,0);
                 tline_config2=make_config_string_e(1,dGr+1,5,9,1,0,0);
%         tline_config1=make_config_string_e(2,dGr,5,10,0,0,0);
%         tline_config2=make_config_string_e(2,dGr+1,5,9,0,0,0);
    else
        tline_config1=make_config_string(pGr-1,dGr+1,10,-1);
        tline_config2=make_config_string(pGr-1,dGr+2,9,-1);
    end
    fprintf(fid2,'%s\n',tline_config1{1});
    fprintf(fid2,'%s\n',tline_config2{1});
    tline=strcat(element,make_short_config_string(pGr,dGr+1,1));
    ll=length(tline); spacer=space_string(1:(19-ll));
    tline=strcat(tline,{spacer},rcg1_line2); tline=tline{1};
    
    
    fprintf(fid2,'%s\n',tline);
    if extra_flag12==1, 
        if handles.XPS
            fprintf(fid2,'%s\n',rcg1_line2extra); 
        else
            fprintf(fid2,'%s',rcg1_line2extra); 
        end
    end
    
    tline=strcat(element,make_short_config_string(pGr-1,dGr+2,1));
    ll=length(tline); spacer=space_string(1:(19-ll));
    tline=strcat(tline,{spacer},rcg2_line2); tline=tline{1};

    fprintf(fid2,'%s\n',tline);
    if extra_flag22==1, 
        if handles.XPS
            fprintf(fid2,'%s\n',rcg2_line2extra); 
        else
            fprintf(fid2,'%s',rcg2_line2extra); 
        end
    end
    
    fprintf(fid2,'%s\n' ,tline99); 
    fprintf(fid2,'%s\n' ,tline_end);
    fclose(fid2);
    delete('ftn*'); delete('FTN*');
 
% Write crystal field parameters into a .rac file
function update_rac_file(fname,handles,num_lines) 
    symmetry=getvalTag('symmetry');
    fid1=fopen(fname); 
    fid2=fopen('temp.rac','wt');
    handles.crystal(4)=handles.crystal(4)/1000;
    handles.crystal(9)=handles.crystal(9)/1000;
    handles.crystal;
    if (handles.XES&&handles.d0)||handles.F4,
        copyfile(fname,'temp.rac')
    else
        str_nums=[12 13 14 16 18 23 24 25 27 29];
        for jj=1:num_lines,
            dd=fgets(fid1);
            curr_str=find(str_nums==jj);
            if isempty(curr_str)
                fprintf(fid2,'%s',dd);
            else
                fprintf(fid2,'%s',dd(1:35));
                fprintf(fid2,'% 3.3f\n',handles.crystal(curr_str));
            end
        end
    end
    fclose(fid2);
    fclose(fid1);
    
% Create ban file
function create_ban(fname, handles)
    [pathstr,name,ext,versn] = fileparts(fname);
    fname_ban=fullfile(pathstr,[name, '.ban' versn]);
    fid2=fopen(fname_ban,'wt');
 
    fprintf(fid2,'%s\n %s\n %s\n',' erange 0.3','NCONF 2 2','N2 1');
    if handles.XES
        ban_string=strcat({' '},'def EG2 = ',{' '},num2str((handles.ct_delta-...
            handles.ct_q), '% 4.3f\n'), ' unity');
    else
        ban_string=strcat({' '},'def EG2 = ',{' '},num2str(handles.ct_delta, '% 4.3f\n'), ' unity');
    end
    fprintf(fid2,'%s\n', ban_string{1}); 
    if handles.XPS
        ban_string=strcat({' '},'def EF2 = ',{' '},num2str((handles.ct_delta-...
            handles.ct_q), '% 4.3f\n'), ' unity');
  
    elseif handles.XES
        ban_string=strcat({' '},'def EF2 = ',{' '},num2str((handles.ct_delta-...
            handles.ct_q), '% 4.3f\n'), ' unity');
    else
        ban_string=strcat({' '},'def EF2 = ',{' '},num2str((handles.ct_delta+...
            handles.ct_u-handles.ct_q), '% 4.3f\n'), ' unity');
    end
    fprintf(fid2,'%s\n', ban_string{1}); 
    fprintf(fid2,'%s % 3.3f % 3.3f % 3.3f % 3.3f\n ',' XMIX 4 ',handles.hopping_b1,...
        handles.hopping_a1,handles.hopping_b2,handles.hopping_e);
    fprintf(fid2,'%s\n ', '2   1 1 2   2 1 2')
    cf=handles.crystal_ct;
    %---------------
    %bug fix Thomas Kroll 30-Aug-2010 email from Aug 28 - 10Dq effect
    Dqeff_g=cf(1)-cf(2)*19.1703/ 3.286335345;
    Dqeff_e=cf(6)-cf(7)*19.1703/ 3.286335345;
    %end fix
    %---------------
    ban_string=strcat('XHAM 5',{'  1.0  '},num2str(Dqeff_g,'% 3.3f\n'),{' '}, ...
        num2str(cf(2),'% 3.3f\n'),{' '},num2str(cf(3),'% 3.3f\n'),{' '},...
        num2str(cf(4)/1000,'% 3.3f\n'));
    fprintf(fid2,'%s\n', ban_string{1});  
    fprintf(fid2, '%s\n',' 2   1 1   1 2')
    ban_string=strcat(' XHAM 5',{'  1.0  '},num2str(Dqeff_e,'% 3.3f\n'),{' '}, ...
        num2str(cf(7),'% 3.3f\n'),{' '},num2str(cf(8),'% 3.3f\n'),{' '},...
        num2str(cf(9)/1000,'% 3.3f\n'));
    fprintf(fid2,'%s\n', ban_string{1});  
    fprintf(fid2, '%s\n',' 2   2 1   2 2')
    fprintf(fid2, ' %s\n %s\n','TRAN  2    1 1    2 2','TRIADS');
    if handles.QUAD
        fprintf(fid2,'%s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n',...
            'S0+   0+  S0+','-S0+   0+ -S0+','S1+   0+  S1+','-S1+   0+ -S1+',...
            'S0+   2+ -S1+','-S0+   2+  S1+','S1+   2+ -S0+','-S1+   2+  S0+',...
            'S0+   1+ -S0+','-S0+   1+ -S1+','S1+   1+  S0+','-S1+   1+  S1+',...
            'S0+  -1+  S1+','-S0+  -1+  S0+','S1+  -1+ -S1+','-S1+  -1+ -S0+');
    else
        if handles.d0==1,
            fprintf(fid2,'%s\n %s\n %s\n',' 0+   1-  -1-','0+  -1-   1-',...
                '0+   0-   0-');
        else
            if handles.XES
                if (handles.even==1),
                    fprintf(fid2,'%s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n',...
                        '  S1+   1-  S0-', '-S1+   1-  S1-',' S0+  -1-  S1- ','-S0+  -1-  S0-',...
                        ' S1+  -1- -S1-', '-S1+  -1- -S0-',' S0+   0-  S0-', '-S0+   0- -S0-',...
                        ' S1+   0-  S1-','-S1+   0- -S1-',' S0+   1- -S0-','-S0+   1- -S1-')
                else
                    fprintf(fid2,'%s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n',...
                        '  0+   1-  -1-', ' 1+   1-   0-', '-1+   1-   2-',  ' 2+   1-   1-',...
                        ' 0+  -1-   1-',  ' 1+  -1-   2-', '-1+  -1-   0-',  ' 2+  -1-  -1-', ...
                        ' 0+   0-   0-', ' 1+   0-   1-', '-1+   0-  -1-', ' 2+   0-   2-') ;
                end
            else
                if (handles.even==0),
                    fprintf(fid2,'%s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n',...
                        '  S1+   1-  S0-', '-S1+   1-  S1-',' S0+  -1-  S1- ','-S0+  -1-  S0-',...
                        ' S1+  -1- -S1-', '-S1+  -1- -S0-',' S0+   0-  S0-', '-S0+   0- -S0-',...
                        ' S1+   0-  S1-','-S1+   0- -S1-',' S0+   1- -S0-','-S0+   1- -S1-')
                else
                    fprintf(fid2,'%s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n %s\n',...
                        '  0+   1-  -1-', ' 1+   1-   0-', '-1+   1-   2-',  ' 2+   1-   1-',...
                        ' 0+  -1-   1-',  ' 1+  -1-   2-', '-1+  -1-   0-',  ' 2+  -1-  -1-', ...
                        ' 0+   0-   0-', ' 1+   0-   1-', '-1+   0-  -1-', ' 2+   0-   2-') ;
                end
            end

        end
    end
    
  fclose(fid2);
%% DEALING WITH RCG FILES
% Swap parameters in RCG file    
function [pars_out_ini,pars_out_fin]=update_rcg_file(fname,handles,rixs) 
    fid_out=fopen('temp.rcg','w');
    fid1=fopen(fname,'r');
 
    if  handles.QUAD, 
        templ_rcg='Resources\templateQuad.rcg';
    elseif handles.F4
        templ_rcg='Resources\template4F.rcg';
        
    else
        templ_rcg='Resources\template.rcg';
    end
    if  handles.XES
        if handles.d0
            templ_rcg='Resources\templateXESd0.rcg';
        else
            templ_rcg='Resources\templateXES.rcg';
        end
    end
    %swapping SO couplings for F elements
    if handles.F4, swap_SO=1; else swap_SO=0; end   
    
    fid2=fopen(templ_rcg,'r');
    for ii=1:3,
        fprintf(fid_out,'%s',fgets(fid2));
    end
    for ii=1:3, fgets(fid1);    end
    tline1 = fgets(fid1);
    tline2 = fgets(fid1);
    if handles.QUAD||handles.F4
        temp_l=tline1(1:3); tline1(1:3)=tline1(6:8); tline1(6:8)=temp_l;
        temp_l=tline2(1:3); tline2(1:3)=tline2(6:8); tline2(6:8)=temp_l;
    end
    %swap D and P shells in case of XES
    if handles.XES
        d_req=length(tline1);
        if d_req>11
           temp_l=tline1(6:8); tline1(6:8)=tline1(11:13); tline1(11:13)=temp_l;
           temp_l=tline2(6:8); tline2(6:8)=tline2(11:13); tline2(11:13)=temp_l;
        end
    end 
    % in the case of RIXS the configurations are swapped

    % updating parameters  for the initial state
    [pars_out_ini,line11,line12]=update_line_slater_out(fid1,handles, 0,0, swap_SO);
    
    %updating parameters for the final state
    if handles.F4
        [pars_out_fin,line21,line22]=update_line_slater_out(fid1,handles,100,1, swap_SO);
    else
        [pars_out_fin,line21,line22]=update_line_slater_out(fid1,handles,0,1, swap_SO);
    end
    
    
    if ~rixs
        fprintf(fid_out,'%s',tline1);
        fprintf(fid_out,'%s',tline2);
        fprintf(fid_out,'%s',line11);
        if ~strcmp(line12,''), fprintf(fid_out,'%s',line12);end
        fprintf(fid_out,'%s',line21);
        if ~strcmp(line22,''), fprintf(fid_out,'%s',line22);end
    else
        fprintf(fid_out,'%s',tline2);
        fprintf(fid_out,'%s',tline1);
        fprintf(fid_out,'%s',line21);
        if ~strcmp(line22,''), fprintf(fid_out,'%s',line22);end
        fprintf(fid_out,'%s',line11);
        if ~strcmp(line12,''), fprintf(fid_out,'%s',line12);end
    end
    
    if handles.QUAD, 
        tline=fgets(fid1);
        if strcmp(tline(1),'S')==0;
            fprintf(fid_out,'%s',tline);
        end
    end
    %processing rest of the file
    while 1
        tline = fgets(fid1);
        if tline==-1, break, end;
        fprintf(fid_out,'%s',tline);
    end
    fclose(fid2); fclose(fid1);  fclose(fid_out);

   copyfile('temp.rcg',fname); 
   
% Update RCG string
function [formatted_line,extra_flag,line_extra]=update_rcg_string(handles,fid)
    line_in=fgets(fid);
    n_param=str2num(line_in(20));
    tline=line_in;
    extra_flag=0;
    line_extra='';
    if n_param==4,
            so_mod=str2num(line_in(51:59))*handles.so_reduc_3d;
            so_string=num2str(so_mod,'%5.3f\n');
            so_l=length(so_string);
            line_in((59-so_l+1):59)=so_string;
        elseif n_param==2,
            line_in(31:39);
            so_mod=str2num(line_in(31:39))*handles.so_reduc_3d;
            so_string=num2str(so_mod,'%5.3f\n');
            so_l=length(so_string);
            line_in((39-so_l+1):39)=so_string;
            
    end  %here spin orbit parameters are swapped depending on the number of
    %parameters
     if handles.XPS
            if n_param==8
                line_in(20)='6';
                spin_orbit1=line_in(31:40); %clear which parameters to swap
                spin_orbit2=line_in(41:50);
                line_in(41:50)=spin_orbit1; 
                line_in(31:40)=spin_orbit2;
                extra_flag=1; 
                line_extra=fgets(fid);
                line_extra=line_extra(1:10);
            elseif n_param==0,
                line_in(20)='8';
                spin_orbit1=line_in(51:60); %not clear which parameters to swap
                spin_orbit2=line_in(61:70);
                line_in(61:70)=spin_orbit1; 
                line_in(51:60)=spin_orbit2;
                extra_flag=1; 
                line_extra=fgets(fid);
                line_extra=line_extra(1:30);
            else
                
            end
        else
            if n_param==6
                spin_orbit1=line_in(31:40); 
                spin_orbit2=line_in(41:50);
                line_in(41:50)=spin_orbit1; 
                line_in(31:40)=spin_orbit2;
                extra_flag=1; 
                line_extra=fgets(fid);
             elseif n_param==8
                spin_orbit1=line_in(51:60); 
                spin_orbit2=line_in(61:70);
                line_in(61:70)=spin_orbit1; 
                line_in(51:60)=spin_orbit2;
                extra_flag=1; 
                line_extra=fgets(fid);
            end
    end
    formatted_line=line_in(20:end);    
 
%% Create NFO file
function create_nfo_file(fname,handles,bindE,pars_ini_in,pars_fin_in, ct)
    [pathstr,name,ext,versn] = fileparts(fname);
    fname_nfo=fullfile(pathstr,[name '.nfo' versn]);
    fid=fopen(fname_nfo,'wt');
    fprintf(fid,'%s\t %s\n','Filename:',strcat(name,ext)); 
    currentConfig=handles.Configurations{handles.currentConfigNum}; ion=currentConfig{1};
    fprintf(fid,'%s\t\t %s\n', 'Ion:',ion);
    transitions=getsTag('transition');
    if ChBxStatus('xas_2p'),   spectrum_tr='2p XAS';
        elseif ChBxStatus('xas_3p'),   spectrum_tr='3p XAS'; 
            elseif ChBxStatus('xas_4p'),   spectrum_tr='4p XAS'; 
             elseif ChBxStatus('xas_3d'),   spectrum_tr='3d XAS'; 
               elseif ChBxStatus('xas_4d'),   spectrum_tr='4d XAS'; 
                 elseif ChBxStatus('xas_5d'),   spectrum_tr='5d XAS'; 
                     elseif ChBxStatus('xas_1s'),   spectrum_tr='1s XAS'; 
        elseif ChBxStatus('xps_2p'),spectrum_tr='2p XPS'; 
            elseif ChBxStatus('xps_3p'),spectrum_tr='3p XPS'; 
                elseif ChBxStatus('xps_1s'),spectrum_tr='1s XPS'; 
                    elseif ChBxStatus('xps_2s'),spectrum_tr='2s XPS'; 
        

        elseif ChBxStatus('xes_1s2p') ,spectrum_tr='1s2p XES'; 
            elseif ChBxStatus('xes_1s3p') ,spectrum_tr='1s3p XES';
        elseif ChBxStatus('rixs_2p3d') ,spectrum_tr='2p3d RIXS';            
            elseif ChBxStatus('rixs_3p3d') ,spectrum_tr='3p3d RIXS';  
                elseif ChBxStatus('rixs_1s2p') ,spectrum_tr='1s2p RIXS';  
                       elseif ChBxStatus('rixs_1s3p') ,spectrum_tr='1s3p RIXS';  
        else   bindE=' ';
        end
    
    fprintf(fid,'%s\t %s\n', 'Spectrum:',spectrum_tr);
    fprintf(fid,'%s\t %5.1f\n', 'Binding energy (eV):',bindE);
    %deal with Slater integrals
    configuration=handles.Configurations;
    currConfig=configuration{handles.currentConfigNum};
    if ct,
        gn_i=1;
        slaterRun=2;
        if handles.oba_file
            fid_oba=fopen(handles.oba_file);
            if fid_oba~=-1,
                oba_str=1;
                jj=1;
                while oba_str~=-1
                    oba_str=fgets(fid_oba);
                    if oba_str~=-1
                        if strcmp(oba_str(2:7), 'Ground')
                            i1=strfind(oba_str,'=');
                            i2=strfind(oba_str,'(');
                            GrndEn(gn_i)=str2num(oba_str(i1+1:i2-1));
                            oba_str=fgets(fid_oba);
                            
                            w1(gn_i)=str2num(oba_str(54:60));
                            w2(gn_i)=str2num(oba_str(62:68));
                            
                            
                            gn_i=gn_i+1;
                        end
                        jj=jj+1;
                   
                    end
                end
                [a1,indx_min]=min(GrndEn);
                w1_min=w1(indx_min);
                w2_min=w2(indx_min);
                numHoles=(10-currConfig{4})*w1_min+(10-currConfig{4}-1)*w2_min;
            end
        else
            numHoles=-1;
        end
        fclose(fid_oba);
    else
        slaterRun=1;

        numHoles=10-currConfig{4};
        
    end
    
    for jj=1:slaterRun,
        if slaterRun==1,
            pars_ini=pars_ini_in;
            pars_fin=pars_fin_in;
        else
            pars_ini=pars_ini_in{jj};
            pars_fin=pars_fin_in{jj};
        end
        size_p_ini=size(pars_ini); sw2_4=0;
        F2dd_ini=0;F4dd_ini=0;LS3d_ini=0;
        for jj=1:size_p_ini(1),
            switch pars_ini(jj,1)
                case 1
                    if sw2_4==0,
                        F2dd_ini=pars_ini(jj,2)*0.8;
                        sw2_4=1;
                    else
                        F4dd_ini=pars_ini(jj,2)*0.8;
                    end
                case 2
                    LS3d_ini=pars_ini(jj,2);
            end
        end
        F2dd_fin=0;F4dd_fin=0;LS2p=0;LS3d_fin=0;F2pd=0;G1pd=0;G3pd=0;
        size_p_fin=size(pars_fin); sw2_4=0;sw1_3=0;
        for jj=1:size_p_fin(1),
            switch pars_fin(jj,1)
                case 1
                    if sw2_4==0,
                        F2dd_fin=pars_fin(jj,2)*0.8;
                        sw2_4=1;
                    else
                        F4dd_fin=pars_fin(jj,2)*0.8;
                    end
                case 2
                    if pars_fin(jj,2)>0.4,
                        LS2p=pars_fin(jj,2);
                    else
                        LS3d_fin=pars_fin(jj,2);
                    end
                case 3
                    F2pd=pars_fin(jj,2)*0.8;
                case 4
                    if sw1_3==0,
                        G1pd=pars_fin(jj,2)*0.8;
                        sw1_3=1;
                    else
                        G3pd=pars_fin(jj,2)*0.8;
                    end
            end
        end
        fprintf(fid,'%s\n', ' ');
        sl_Fdd=strcat('(',num2str(handles.slater_Fdd*100),'%)');
        sl_Fpd=strcat('(',num2str(handles.slater_Fpd*100),'%)');
        sl_Gpd=strcat('(',num2str(handles.slater_Gpd*100),'%)');
        so_2p=strcat('(',num2str(handles.so_reduc_2p*100),'%)');
        so_3d=strcat('(',num2str(handles.so_reduc_3d*100),'%)');
        fprintf(fid,'%s\t\t %5.3f %s\t  %5.3f %s\n', 'F2dd:',F2dd_ini,sl_Fdd,F2dd_fin,sl_Fdd);
        fprintf(fid,'%s\t\t %5.3f %s\t  %5.3f %s\n', 'F4dd:',F4dd_ini, sl_Fdd,F4dd_fin, sl_Fdd);
        fprintf(fid,'%s\t\t %5.3f %s\t  %5.3f %s\n', 'LS3d:',LS3d_ini,so_3d, LS3d_fin,so_3d);
        fprintf(fid,'%s\t\t\t\t  %5.3f %s\n', 'LS2p:',LS2p,so_2p);
        fprintf(fid,'%s\t\t\t\t  %5.3f %s\n', 'F2pd:',F2pd,sl_Fpd);
        fprintf(fid,'%s\t\t\t\t  %5.3f %s\n', 'G1pd:',G1pd,sl_Gpd);
        fprintf(fid,'%s\t\t\t\t  %5.3f %s\n', 'G3pd:',G3pd,sl_Gpd);
    end
    fprintf(fid,'%s\n', ' ');
    fprintf(fid,'%s\t\t %5.1f \t\t  %5.1f\n', '10Dq:',handles.crystal_ct(1),handles.crystal_ct(6));
    fprintf(fid,'%s\t\t %5.1f \t\t  %5.1f\n', 'Dt:',handles.crystal_ct(2),handles.crystal_ct(7));
    fprintf(fid,'%s\t\t %5.1f \t\t  %5.1f\n', 'Ds:',handles.crystal_ct(3),handles.crystal_ct(8));
    fprintf(fid,'%s\t\t %5.1f \t\t  %5.1f\n', 'M(meV):',handles.crystal_ct(4),handles.crystal_ct(9));
    fprintf(fid,'%s\t\t %5.1f\n', 'Delta:',handles.ct_delta);
    fprintf(fid,'%s\t\t %5.1f\n', 'Udd:',handles.ct_u);
    fprintf(fid,'%s\t\t %5.1f\n', 'Upd:',handles.ct_q);
    fprintf(fid,'%s\t\t %5.1f\n', 'T (b1):',handles.hopping_b1);
    fprintf(fid,'%s\t\t %5.1f\n', 'T (b2):',handles.hopping_b2);
    fprintf(fid,'%s\t\t %5.1f\n', 'T (a1):',handles.hopping_a1);
    fprintf(fid,'%s\t\t %5.1f\n', 'T (e):',handles.hopping_e);
    fprintf(fid,'%s\t\t %5.1f\n', 'Lorenz:', handles.lorenz);
    fprintf(fid,'%s\t\t %5.1f\n', 'Gauss:', handles.gauss);
    fprintf(fid,'%s\t %s\n', 'Num Holes:', num2str(numHoles));
    fprintf(fid,'%s\n', datestr(now,'mmm.dd,yyyy HH:MM:SS'));
    fprintf(fid,'%s\n', 'CTM4XAS 5.2 output file');
    fprintf(fid,'%s\n', '(C) Eli Stavitski and Frank de Groot, Utrecht University');

    
    fclose(fid)
    
%% COLLECT PARAMETERS AND UPDATE FIELDS
%Collects Slater and crystal field parameters  
function handles_out=collect_param(handles)
    symmetry=PopUpPick('symmetry');
    expert=ChBxStatus('expert_options') ;
    handles.plot_file=getsTag('plot_file_name');
    handles.ct_u=getvTag('ct_u');
    handles.ct_delta=getvTag('ct_delta');
    handles.ct_q=getvTag('ct_q');
    handles.lorenz=getvTag('lorenz_broad');
    handles.hopping_b1=getvTag('hopping_b1');
    handles.hopping_b2=getvTag('hopping_b2');
    handles.hopping_a1=getvTag('hopping_a1');
    handles.hopping_e=getvTag('hopping_e');
    handles.so_reduc_2p=getvTag('so_reduc_2p');
    handles.so_reduc_3d=getvTag('so_reduc_3d');
    handles.lorenz2=getvTag('lorenz_broad2');
    handles.lorenz_break=getvTag('lorenz_break');
    handles.temp=getsTag('temp_set');
    handles.gauss=getvTag('gauss_broad');
    handles.fano=99999;
    handles.range_start=getvTag('range_lo');
    handles.range_end=getvTag('range_hi');
    if expert==0
        setsTag('Dq_excited',getsTag('Dq_ground'));
        setsTag('Dt_excited',getsTag('Dt_ground'));
        setsTag('Ds_excited',getsTag('Ds_ground'));
  
    end
             
    handles.slater_Fdd=str2num(getsTag('slater1'));
    handles.slater_Fpd=str2num(getsTag('slater2'));
    handles.slater_Gpd=str2num(getsTag('slater3'));
     
    %collect crystal field parameters
    Dq_ground=getvTag('Dq_ground');
    Dt_ground=getvTag('Dt_ground');
    Ds_ground=getvTag('Ds_ground');
    spin_ground=getvTag('spin_ground');
    Dq_excited=getvTag('Dq_excited');
    Dt_excited=getvTag('Dt_excited');
    Ds_excited=getvTag('Ds_excited');
    spin_excited=getvTag('spin_excited');
    if symmetry<4,
        crystal(1)=6*sqrt(30)*Dq_ground/10-3.5*sqrt(30)*Dt_ground;
        crystal(2)=-2.5*sqrt(42)*Dt_ground;
        crystal(3)=-sqrt(70)*Ds_ground;
        crystal(4)=spin_ground;
        crystal(6)=6*sqrt(30)/10*Dq_excited-3.5*sqrt(30)*Dt_excited;
        crystal(7)=-2.5*sqrt(42)*Dt_excited;
        crystal(8)=-sqrt(70)*Ds_excited;
        crystal(9)=spin_excited;
    else
        crystal(1)=sqrt(10/3)*(18*Dq_ground+7*Dt_ground);
        crystal(2)=10*sqrt(14/3)*Dt_ground;
        crystal(3)=-sqrt(70)*Ds_ground;
        crystal(4)=spin_ground;
        crystal(6)=sqrt(10/3)*(18*Dq_excited+7*Dt_excited);
        crystal(7)=10*sqrt(14/3)*Dt_excited;
        crystal(8)=-sqrt(70)*Ds_excited;
        crystal(9)=spin_excited;
    end
    
    crystal(5)=0;
    crystal(10)=0;
    
    crystal_ct(1)=Dq_ground;
    crystal_ct(2)=Dt_ground;
    crystal_ct(3)=Ds_ground;
    crystal_ct(4)=spin_ground;
    crystal_ct(6)=Dq_excited;
    crystal_ct(7)=Dt_excited;
    crystal_ct(8)=Ds_excited;
    crystal_ct(9)=spin_excited;
    crystal_ct(5)=0;
    crystal_ct(10)=0;
    for ii=1:10,
        if crystal(ii)==0,
           crystal(ii)=str2num('0');
        end
    end
    if symmetry==1,
        for ii=2:5, crystal(ii)=0; end
        for ii=7:10, crystal(ii)=0;end
        if expert==0
            crystal(6)=crystal(1);
        end
    elseif symmetry==2,
        for ii=4:5, crystal(ii)=0; end
        for ii=9:10, crystal(ii)=0;end
        if expert==0
            crystal(6:8)=crystal(1:3);
        end
    elseif symmetry==3,
        if expert==0
            crystal(6:10)=crystal(1:5);
        end
    end
    handles.crystal_ct=crystal_ct;
    handles.crystal=crystal;
    handles_out=handles;
    
% Check whether Slater values are withing the right range and corrects them if nesessary
function check_slaters(hObject)
    sl=str2num(get(hObject,'String'));
    if sl>1.5,
        sl=1.5;
    elseif sl<0,
        sl=0;
    end
    set(hObject,'String', num2str(sl)); 
    
% Update configurations
function handles_out=update_config(handles)
    setsTag('ErrorMsg','Ready');
    ion=getsTag('element');
    load('Resources\ctm4xas5.cfg','-mat')

    if isempty(ion)
        ion='Ni2+';
        settings.ion=ion;
        setsTag('element', ion);
        
    end
    save('Resources\ctm4xas5.cfg','settings') 
    configList=handles.Configurations;
    
    handles.ion_found=0;
    for jj=1:length(configList),
        temp_config=configList{jj};
        temp_ion=temp_config{1};
        if strcmpi(ion,temp_ion)==1,
            currentConfigNum=jj;
            handles.ion_found=1;
            break
        end
    end
    enableControl({'xas_2p' 'xas_3p'  'xas_4p' 'xas_3d' 'xas_4d'  'xas_5d' 'xas_1s'...
        'xps_2p' 'xps_3p' 'xps_1s' 'xps_2s' 'xps_3s'...
        'xes_1s2p' 'xes_1s3p'...
        'rixs_2p3d' 'rixs_3p3d' 'rixs_1s2p' 'rixs_1s3p'});
    if handles.ion_found==0,
        errordlg('Configuration not found','Error')
    elseif  ~(ChBxStatus('xas_2p')||ChBxStatus('xas_3p')||ChBxStatus('xas_4p')||...
            ChBxStatus('xas_3d')||ChBxStatus('xas_4d')||ChBxStatus('xas_5d')||...
            ChBxStatus('xas_1s')||...
            ChBxStatus('xps_2p')||ChBxStatus('xps_3p')||...
            ChBxStatus('xps_1s')||ChBxStatus('xps_2s')||ChBxStatus('xps_3s')||...
            ChBxStatus('xes_1s2p')||ChBxStatus('xes_1s3p')||...
            ChBxStatus('rixs_2p3d')||ChBxStatus('rixs_3p3d')||...
            ChBxStatus('rixs_1s2p')||ChBxStatus('rixs_1s3p')),
        
        errordlg('No transition selected','Error')
        
    else
        currentConfig=configList{currentConfigNum};
        handles.row5=0;
        if within(currentConfig{2},57,71), % for lantanides
            handles.F4=1;
            if (~getvalTag('xas_3d'))&&(~getvalTag('xas_4d'))
                setvalTag('xas_3d',1);
            end
            disableControl({'xas_2p' 'xas_3p'  'xas_4p' 'xas_5d' 'xas_1s'...
                'xps_2p' 'xps_3p' 'xps_1s' 'xps_2s' 'xps_3s'...
                'xes_1s2p' 'xes_1s3p'...
                'rixs_2p3d' 'rixs_3p3d' 'rixs_1s2p' 'rixs_1s3p'});
        elseif currentConfig{2}>90, %uranium
            handles.F4=1;
            if (~getvalTag('xas_3d'))&&(~getvalTag('xas_4d'))&&(~getvalTag('xas_5d'))
            setvalTag('xas_3d',1);
            end
            disableControl({'xas_2p' 'xas_3p'  'xas_4p' 'xas_1s'...
                'xps_2p' 'xps_3p' 'xps_1s' 'xps_2s' 'xps_3s'...
                'xes_1s2p' 'xes_1s3p'...
                'rixs_2p3d' 'rixs_3p3d' 'rixs_1s2p' 'rixs_1s3p'});
        else
            handles.F4=0;
            if within(currentConfig{2},72,79), %d5 elements
                handles.row5=1;
            end
             if within(currentConfig{2},19,29), %Ca-Cu elements
                
                disableControl({  'xas_4p'})
            end
            
            if getvalTag('xas_3d')||getvalTag('xas_4d')||getvalTag('xas_5d'),
                setvalTag('xas_2p',1);
            end
            disableControl({ 'xas_3d' 'xas_4d'  'xas_5d'});
            
        end
        %here we check which spectroscopic transition is selected
        if ChBxStatus('xas_1s')
            handles.QUAD=1;
        else
            handles.QUAD=0;
        end
        if ChBxStatus('xps_2p')||ChBxStatus('xps_3p')||ChBxStatus('xps_1s')||ChBxStatus('xps_2s')||ChBxStatus('xps_3s'),  
            handles.XPS=1; 
        else
            handles.XPS=0; 
        end
        if ChBxStatus('xps_1s')||ChBxStatus('xps_2s')||ChBxStatus('xps_3s'), 
            handles.XPS_1s=1; 
        else
            handles.XPS_1s=0;
        end
        if ChBxStatus('xes_1s2p')||ChBxStatus('xes_1s3p')
            handles.XES=1; 
        else
            handles.XES=0; 
        end
        if ChBxStatus('rixs_2p3d')||ChBxStatus('rixs_3p3d')||ChBxStatus('rixs_1s2p')||ChBxStatus('rixs_1s3p'),  
            handles.RIXS=1; 
        else
            handles.RIXS=0;
        end
        if  ChBxStatus('rixs_1s2p')||ChBxStatus('rixs_1s3p'),
            handles.RIXS_QUAD=1; 
        else
            handles.RIXS_QUAD=0; 
        end

        if handles.XPS,setvalTag('radio_ct',1); end;
        if handles.QUAD||handles.RIXS||handles.row5,
            setvalTag('radio_ct',0); 
        end;
        
        handles.CT=ChBxStatus('radio_ct');   
    


        %define initial and final states
        
        if within(currentConfig{2},72,79), %4D for the 5th row elements
            d34='5D';
        elseif within(currentConfig{2},35,56), %4D for the 5th row elements
            d34='4D';
        else
            d34='3D';
        end
        if within(currentConfig{2},90,100), %4-5F for  actinides
            f45='5F';
        else
            f45='4F';
        end

            
        d_ele=currentConfig{4};
        if d_ele==0,
            handles.d0=1;
        else
            handles.d0=0;
        end
        handles.even=( (round(d_ele/2)==(d_ele/2)));
        pGr=num2strE(currentConfig{3});         pEx=num2strE(currentConfig{3}-1);
        dGr=num2strE(currentConfig{4});         dEx=num2strE(currentConfig{4}+1);
        dGrMixed=num2strE(currentConfig{4}+1);  dExMixed=num2strE(currentConfig{4}+2);
 
        if handles.XPS
            dEx=dGr;
            dExMixed=num2strE(currentConfig{4}+1);
        end
        if length(dEx)>2,  dEx=dEx(2:3); end
 
         
        if getvalTag('xas_2p')||getvalTag('xps_2p')||getvalTag('rixs_2p3d')
            Pel='2P'; eGr=pGr; eEx=pEx;
        elseif getvalTag('xas_3p')||getvalTag('xps_3p')||getvalTag('rixs_3p3d'),
            Pel='3P'; eGr=pGr; eEx=pEx;
        elseif getvalTag('xas_4p')
            Pel='4P'; eGr=pGr; eEx=pEx;
        elseif getvalTag('xas_3d')
            Pel='3D'; d34=f45; eGr=pGr; eEx=pEx;
        elseif getvalTag('xas_4d')
            Pel='4D'; d34=f45; eGr=pGr; eEx=pEx;
        elseif getvalTag('xas_5d')
            Pel='5D'; d34=f45; eGr=pGr; eEx=pEx;
        elseif getvalTag('xas_1s')||getvalTag('xps_1s')
            Pel='1S'; eGr='02'; eEx='01';
        elseif getvalTag('xps_2s')
            Pel='2S'; eGr='02'; eEx='01';
        elseif getvalTag('xps_3s')
            Pel='3S'; eGr='02'; eEx='01';
        elseif getvalTag('xes_1s2p')
            Pel='1S'; eGr='01'; eEx='01'; Pel2='2P';
        elseif getvalTag('xes_1s3p')
            Pel='1S'; eGr='01'; eEx='01'; Pel2='3P';
        elseif getvalTag('rixs_1s2p'),
            Pel='1S'; eGr='02'; eEx='01'; Pel2='2P';
        elseif getvalTag('rixs_1s3p'),
            Pel='1S'; eGr='02'; eEx='01'; Pel2='3P';
        else
            setvalTag('xas_2p',1)
            Pel='2P'; eGr=pGr; eEx=pEx;
        end
        if handles.XES
            config_ground_string=strcat(Pel,eGr,{' '},d34,dGr);
            config_excited_string=strcat(Pel2,'05',{' '},d34,dGr);
            config_ground_mixed_string=strcat(Pel,eGr,{' '},d34,dEx,{' '},'L');
            config_excited_mixed_string=strcat(Pel2,'05',{' '},d34,dEx,{' '},'L');
        elseif handles.RIXS_QUAD
            config_ground_string=strcat(Pel,eGr,{' '},d34,dGr);
            config_excited_string=strcat(Pel,eEx,{' '},d34,dEx);
            config_ground_mixed_string=strcat(Pel,eEx,{' '},d34,dEx);
            config_excited_mixed_string=strcat(Pel2,'05',{' '},d34,dEx);
        else
            config_ground_string=strcat(Pel,eGr,{' '},d34,dGr);
            config_excited_string=strcat(Pel,eEx,{' '},d34,dEx);
            config_ground_mixed_string=strcat(Pel,eGr,{' '},d34,dGrMixed,{' '},'L');
            config_excited_mixed_string=strcat(Pel,eEx,{' '},d34,dExMixed,{' '},'L');
        end 
        if handles.XPS,
            if ~handles.XPS_1s,
                config_excited_string=strcat(Pel,eEx,{' '},d34,dEx,'99S01');
                config_excited_mixed_string=strcat(Pel,eEx,{' '},d34,dExMixed,'99S01',{' '},'L');
            else
               config_excited_string=strcat(Pel,eEx,{' '},d34,dEx,'99P01');
               config_excited_mixed_string=strcat(Pel,eEx,{' '},d34,dExMixed,'99P01',{' '},'L');
            end       
        end
        
        %set the values in the States controls
        setsTag('init_state',config_ground_string{1});
        setsTag('final_state',config_excited_string{1});
        
        if handles.CT,
            enableControl({'ct_u' 'ct_delta' 'ct_q' 'hopping_b1'...
                'hopping_a1' 'hopping_b2' 'hopping_e'});
            setsTag('init_state_ct',config_ground_mixed_string{1});
            setsTag('final_state_ct',config_excited_mixed_string{1});
        elseif handles.RIXS_QUAD
            setsTag('init_state_ct',config_ground_mixed_string{1});
            setsTag('final_state_ct',config_excited_mixed_string{1});
        else
            disableControl({'ct_u' 'ct_delta' 'ct_q' 'hopping_b1'...
                'hopping_a1' 'hopping_b2' 'hopping_e'});
            setsTag('init_state_ct','');
            setsTag('final_state_ct','');
        end
        handles.currentConfigNum=currentConfigNum;
    end
    if handles.CT,
        setsTag('init_ex','Initial state (CT)');
        setsTag('fin_ex','Final state (CT)');
    elseif handles.RIXS_QUAD
        setsTag('init_ex','Initial state (Em)');
        setsTag('fin_ex','Final state (Em)'); 
    else
        setsTag('init_ex','Initial state');
        setsTag('fin_ex','Final state'); 
        
    end
    if getvalTag('symmetry')>3,handles.D3d=1; else handles.D3d=1; end
    
             if (strcmp(ion,'Cu2+')& ChBxStatus('radio_ct'))&&~handles.XPS,
                errordlg('Fully occupied 3d shell. Choose another configuration','Error');
                h1=findobj('Tag','radio_ct'); set(h1,'Value',0);
                setsTag('init_state_ct','');
                setsTag('final_state_ct','');
            
         end
    update_fields(handles)
    handles_out=handles;
    
% Update the fields depending on the status of the toggles
function update_fields(handles)
    if handles.XPS,setvalTag('radio_ct',1); end;
    if handles.QUAD,setvalTag('radio_ct',0); end;
    if handles.QUAD, 
        setsTag('plot_spec_type',{'XAS' });
    else
        setsTag('plot_spec_type',{'XAS' 'MCD' 'MLD'});
    end

    if ChBxStatus('temperature');
        enableControl({'temp_set'});
    else 
        disableControl({'temp_set'});
    end

    if ChBxStatus('lorenz_split'),
        enableControl({'lorenz_broad2' 'lorenz_break' 'read_lorenz_break'});
    else
        disableControl({'lorenz_broad2' 'lorenz_break' 'read_lorenz_break'});
    end
    symmetry=PopUpPick('symmetry');
    if symmetry>3
        setsTag('Dt_label','Dtau')
        setsTag('Ds_label','Dsigma')
    else
        setsTag('Dt_label','Dt')
        setsTag('Ds_label','Ds')
    end
    
    expert=ChBxStatus('expert_options') ;
    ct=ChBxStatus('radio_ct') ;
    if ct==1
        enableControl({'ct_u' 'ct_delta' 'ct_q'});
    else
        disableControl({'ct_u' 'ct_delta' 'ct_q'});
    end
    enableControl({ 'symmetry' 'expert_options'});
    
    if ~expert
        setsTag('Dq_excited',getsTag('Dq_ground'));
        setsTag('Dt_excited',getsTag('Dt_ground'));
        setsTag('Ds_excited',getsTag('Ds_ground'));
        setsTag('spin_excited',getsTag('spin_ground'));
    end
    disableControl({'Dq_ground'...
        'Dq_excited' 'Dt_ground'...
        'Dt_excited' 'Ds_ground'...
        'Ds_excited' 'spin_ground' 'spin_excited'});
    if symmetry==1,
        enableControl({'Dq_ground'});
        disableControl({'Dt_ground'...
            'Dt_excited' 'Ds_ground'...
            'Ds_excited' 'spin_ground' 'spin_excited'});
        %fix Ds Dt Thomas Kroll 24-Aug-2010
        setsTag('Dt_ground',0); setsTag('Dt_excited',0); 
        setsTag('Ds_ground',0); setsTag('Ds_excited',0);
        setsTag('spin_ground',0); setsTag('spin_excited',0);
        %end fix
        if expert==1
            enableControl({'Dq_excited'});
        end
        %   fix version 5.0.2 degeneracies of hopping papameters 30-Aug-2010 
        setsTag('label_hop11','T(eg)');setsTag('label_hop12','T(eg)');
        setsTag('label_hop21','T(t2g)');setsTag('label_hop22','T(t2g)');
        disableControl({'hopping_a1' 'hopping_e'})
        setsTag('hopping_a1',getsTag('hopping_b1'));
        setsTag('hopping_e',getsTag('hopping_b2'));
        %   end fix
        
    elseif (symmetry==2)||(symmetry==4),
        enableControl({'Dq_ground' 'Dt_ground' 'Ds_ground'});
        disableControl({'Dq_excited' 'Dt_excited' ...
            'Ds_excited' 'spin_ground' 'spin_excited' });
        setsTag('spin_ground',0); setsTag('spin_excited',0);
        if expert==1
            enableControl({'Dq_excited' 'Dt_excited' 'Ds_excited'});
        end
        setsTag('label_hop11','T(b1)');setsTag('label_hop12','T(a1)');
        setsTag('label_hop21','T(b2)');setsTag('label_hop22','T(e)');
        if ct
        enableControl({'hopping_a1' 'hopping_e'});
        end
    elseif (symmetry==3)||(symmetry==5),
        enableControl({'Dq_ground' 'Dq_ground' 'Dt_ground' 'Ds_ground' 'spin_ground'});
        disableControl({'Dq_excited' 'Dt_excited' 'Ds_excited' 'spin_excited'});
        if expert==1
            enableControl({'Dq_excited' 'Dt_excited' 'Ds_excited' 'spin_excited'});
        end
        setsTag('label_hop11','T(b1)');setsTag('label_hop12','T(a1)');
        setsTag('label_hop21','T(b2)');setsTag('label_hop22','T(e)');
        if ct
        enableControl({'hopping_a1' 'hopping_e'})
        end
    end
    %addition for lantanides 
    if handles.F4,
        disableControl({ 'symmetry' 'Dq_ground' 'Dq_ground' 'Dt_ground' 'Ds_ground' 'spin_ground'...
            'Dq_excited' 'Dt_excited' 'Ds_excited' 'spin_excited'});
        setsTag('Dq_ground',0);setsTag('Dq_escited',0);
    else
        enableControl({ 'symmetry' 'Dq_ground'});
    end
    
%% PLOT SPECTRA SECTION
function plot_spec_Callback(hObject, eventdata, handles)
    legend_list='';
    nfo=0;
    list_files2plot=getsTag('plot_file_name');
    if not(isempty(list_files2plot))
        h1=findobj('Tag','plot_exists');
        if isempty(h1),
            h1=figure; set(h1,'Tag','plot_exists');
            h1a=gca(h1);
        else
            h1a=get(h1,'CurrentAxes');
        end
        if ~handles.report
            if ChBxStatus('stack'),
                set(h1,'Position',[680 558 560 420]);
            else
                set(h1,'Position',[680 158 560 620]);
            end
        end
        hold(h1a,'off')
        for jj=1:length(list_files2plot);
            fid=fopen(list_files2plot{jj});
            if fid~=-1,
                fclose(fid)
                [bl,name,fext,bl] = fileparts(list_files2plot{jj});
                if strcmpi(fext,'.ctm');
                    [list_files2plot{jj}, nfo]=unbundle(list_files2plot{jj},0);
                end
                %here we read .nfo file and see if there are number of
                %holes is 
                
    
  
        
        [pathstr,name,ext,versn] = fileparts(list_files2plot{jj});
        nfofile=fullfile( pathstr,[name,'.nfo',versn]);
        fid_nfo=fopen(nfofile);
        num_holes=-1;
        if fid_nfo~=-1,

            nfo_str=1;
           % jj=1;
            while nfo_str~=-1
                nfo_str=fgets(fid_nfo);
                if nfo_str~=-1
                    if length(nfo_str)>9,
                        if strcmp(nfo_str(1:9), 'Num Holes'),
                        num_holes=str2num(nfo_str(11:end));
                        end 
                    end
                end
            end
            fclose(fid_nfo);
            setsTag('ErrorMsg','Ready');
        else
            setsTag('ErrorMsg','NFO file not found. Can not normalize');
         
        end

    
                legend_list{jj}=name;
                [created,quadTr,xes,bindE]=make_plot_files(handles,list_files2plot{jj});
                if created
                    if ~ChBxStatus('stack'),indx_stack=length(list_files2plot)-jj+1; else indx_stack=1; end
                    plot_spectrum(list_files2plot{jj},jj,quadTr,xes,bindE,h1a,indx_stack,num_holes);
                    hold(h1a,'on');
                end
            end
            fclose all
            if nfo
                delete(nfo);
            end
            if strcmpi(fext,'.ctm');
                 delete(list_files2plot{jj});
            end
            
        end
     delete('ftn*'); delete('FTN*'); delete('temp*');delete('fort*'); delete('*.m14'); delete('*.m15'); 
 
    end
    
% Plot spectra
function plot_spectrum(file2plot,indx,quadTr,xes,bindE,h1a,jj,num_holes)  
    no_plot=0;
    color_arr='gbrm'; 
    curr_indx=rem(indx,length(color_arr))+1;
    curr_color=color_arr(curr_indx);
    type_of_plot=getvalTag('plot_spec_type');
    mesh_spline=3000;
    %read data
    if (quadTr==0)
        [l_conv, l_sticks]=read_frank_spec('temp_left.dat');
        fid=fopen('temp_right.dat');
        if fid==-1,
            [r_conv, r_sticks]=read_frank_spec('temp_left.dat');
        else
            [r_conv, r_sticks]=read_frank_spec('temp_right.dat');
        end   
        fid=fopen('temp_zero.dat');
        if fid==-1,
              [z_conv, z_sticks]=read_frank_spec('temp_left.dat');
         else
              [z_conv, z_sticks]=read_frank_spec('temp_zero.dat');
         end
        %make identical limits for all the spectra
        lo_lim=max([min(r_conv(:,1)) min(l_conv(:,1)) min(z_conv(:,1))]);
        hi_lim=min([max(r_conv(:,1)) max(l_conv(:,1)) max(z_conv(:,1))]);
        spec_to_plot(:,1)=lo_lim:((hi_lim-lo_lim)/mesh_spline):hi_lim;
        r_conv_spl=spline(r_conv(:,1), r_conv(:,2),spec_to_plot(:,1));
        l_conv_spl=spline(l_conv(:,1), l_conv(:,2),spec_to_plot(:,1));
        z_conv_spl=spline(z_conv(:,1), z_conv(:,2),spec_to_plot(:,1));
        if (isempty(r_sticks))&(isempty(l_sticks))&(isempty(z_sticks)),
            errordlg('No transitions found. Expand energy range','Error');
            no_plot=1;
        else
            stick_integral=-1;
            switch type_of_plot
                case 1
                    sticks_to_plot=[l_sticks; r_sticks; z_sticks];
                    r_coef=1;l_coef=1;z_coef=1;
                    disp(['Overall stick intesity:',num2str(sum(sticks_to_plot(:,2)))]);
                    stick_integral=sum(sticks_to_plot(:,2));
                case 2
                    if ~isempty(r_sticks),
                        r_sticks(:,2)=-r_sticks(:,2);
                    end
                    sticks_to_plot=[l_sticks; r_sticks];
                    r_coef=-1;l_coef=1;z_coef=0;
                case 3
                    if ~isempty(l_sticks),
                        l_sticks(:,2)=0.5*l_sticks(:,2);
                    end
                    if ~isempty(r_sticks),
                        r_sticks(:,2)=0.5*r_sticks(:,2);
                    end
                    z_sticks(:,2)=-z_sticks(:,2);
                    sticks_to_plot=[l_sticks; r_sticks; z_sticks];
                    r_coef=0.5;l_coef=0.5;z_coef=-1;
            end
            spec_to_plot(:,2)=r_coef*r_conv_spl+l_coef*l_conv_spl+...
                z_coef*z_conv_spl;
            spec_to_save=[spec_to_plot(:,1) r_conv_spl l_conv_spl z_conv_spl];
        end
    else
        [s0_conv, s0_sticks]=read_frank_spec('temp_0.dat');
        [s2_conv, s2_sticks]=read_frank_spec('temp_2.dat');
        [s1_conv, s1_sticks]=read_frank_spec('temp_1.dat');
        [s1n_conv, s1n_sticks]=read_frank_spec('temp_1n.dat');
        if isempty(s0_sticks)&isempty(s2_sticks)&...
                isempty(s1_sticks)&isempty(s1n_sticks),
            errordlg('No transitions found. Expand energy range','Error');
            no_plot=1;
        else
            lo_lim=min([min(s0_conv(:,1)) min(s2_conv(:,1)) ...
                min(s1_conv(:,1)) min(s1n_conv(:,1))])-1;
            hi_lim=max([max(s0_conv(:,1)) max(s2_conv(:,1))...
                max(s1_conv(:,1)) max(s1n_conv(:,1))])+1;
            size(s0_conv)
            s0_padded=[lo_lim  0; s0_conv; hi_lim 0] ;
            s1_padded=[lo_lim  0; s1_conv; hi_lim 0] ;
            s1n_padded=[lo_lim  0; s1n_conv; hi_lim 0] ;
            s2_padded=[lo_lim  0; s2_conv; hi_lim 0] ;
            spec_to_plot(:,1)=lo_lim:((hi_lim-lo_lim)/mesh_spline):hi_lim;
            s0_2plot=spline(s0_padded(:,1), s0_padded(:,2),spec_to_plot(:,1));
            s1_2plot=spline(s1_padded(:,1), s1_padded(:,2),spec_to_plot(:,1));
            s1n_2plot=spline(s1n_padded(:,1), s1n_padded(:,2),spec_to_plot(:,1));
            s2_2plot=spline(s2_padded(:,1), s2_padded(:,2),spec_to_plot(:,1));
            sticks_to_plot=[s0_sticks;  s2_sticks; s1_sticks ; s1n_sticks];
            disp(['Overall sticks intesity:',num2str(sum(sticks_to_plot(:,2)))]);
                    stick_integral=sum(sticks_to_plot(:,2));
            spec_to_plot(:,2)= s0_2plot + s1_2plot+ s1n_2plot+ s2_2plot;
            spec_to_save=[spec_to_plot(:,1) s0_2plot s1_2plot s1n_2plot s2_2plot];
            
        end
    end
    if ~no_plot
        if ChBxStatus('nonorm')
            if (stick_integral~=-1)&(num_holes~=-1),
                norm_factor=num_holes/stick_integral;
                spec_to_plot(:,2)=spec_to_plot(:,2)*norm_factor;
                sticks_to_plot(:,2)=sticks_to_plot(:,2)*norm_factor;
                spec_to_save(:,2:end)=spec_to_save(:,2:end)*norm_factor;
            end
        end
        bindE=str2num(bindE);
        if xes
            a_x=-spec_to_plot(:,1)+2*bindE;
            a_x_s=-sticks_to_plot(:,1)+2*bindE;
        else
             a_x=spec_to_plot(:,1);
             a_x_s=sticks_to_plot(:,1);
        end
        plot(h1a,a_x,spec_to_plot(:,2)+jj-1,curr_color);  
        axes(h1a)
        xlabel('Energy /eV');
        ylabel('Absorption crossection /a.u.');
        if ~ChBxStatus('no_sticks')
            for ii=1:length(sticks_to_plot(:,2))
                line([a_x_s(ii),a_x_s(ii)],...
                    [jj-1, sticks_to_plot(ii,2)+jj-1],'Color',curr_color)
            end
        end

         %save data in a .xy file
        [pathstr,name,ext,versn] = fileparts(file2plot);
        fname_new=fullfile(pathstr,[strcat(name), '.xy', versn]);
        save(fname_new,'spec_to_save','-ascii')
        %save sticks in the _sticks.xy file
        if ~ChBxStatus('no_sticks')
            fname_sticks=fullfile(pathstr,[strcat(name,'_sticks'), '.xy', versn]);
            fid=fopen(fname_sticks,'wt');
            if ~quadTr
                fprintf(fid, '%s\n\r', 'L Sticks');
                fprintf(fid, '% 6.4f % 6.5f\n', l_sticks');
                fprintf(fid, '%s\n\r', 'R Sticks');
                fprintf(fid, '% 6.4f % 6.5f\n', r_sticks');
                fprintf(fid, '%s\n\r', 'Z Sticks');
                fprintf(fid, '% 6.4f % 6.5f\n', z_sticks');
            else
                fprintf(fid, '%s\n\r', '0 Sticks');
                fprintf(fid, '% 6.4f % 6.5f\n', s0_sticks');
                fprintf(fid, '%s\n\r', '2 Sticks');
                fprintf(fid, '% 6.4f % 6.5f\n', s2_sticks');
                fprintf(fid, '%s\n\r', '+1 Sticks');
                fprintf(fid, '% 6.4f % 6.5f\n', s1_sticks');
                fprintf(fid, '%s\n\r', '-1 Sticks');
                fprintf(fid, '% 6.4f % 6.5f\n', s1n_sticks');
            end
            fclose(fid)
        end
    end
    
% Dealing with plot files
function [file_created,quadTr,xes,bindEs]=make_plot_files(handles,file2plot)
    handles=collect_param(handles);
    copyfile(file2plot,'temp.ora')
    fid_test=fopen(file2plot);
    BEflag=0;
    if fid_test==-1
        errordlg('Invalid file name. Check File field','File Error');
        file_created=0;
    else
        [pathstr,name,ext,versn] = fileparts(file2plot);
        %check if file with binding energy exists
        binEfile=fullfile( pathstr,[name,'.erg',versn]);
        NFOfile=fullfile( pathstr,[name,'.nfo',versn]);
        fid_BE=fopen(binEfile);
        fid_NFO=fopen(NFOfile);
        if fid_BE~=-1,
            BEflag=1;
            bindEs=fgets(fid_BE);
            fclose(fid_BE);
        end
        if fid_NFO~=-1,
            BEflag=1;
            for jj=1:8, 
                bindln=fgets(fid_NFO);
                if strcmp( bindln(1:2),'Bi');
                    break
                end
            end
            bindEs=bindln(21:end);
            bindEs=num2str(str2num(bindEs));
            fclose(fid_NFO);
        end
        if ~BEflag
            bindEs='0';
        end
        spectra=3;
        if (strcmp(ext,'.oqa'))||(strcmp(ext,'.oca')), quadTr=1; else quadTr=0; end
        if (strcmp(ext,'.oea'))||(strcmp(ext,'.ofa')), xes=1; else xes=0; end
        if (strcmp(ext,'.oda')), F4=1; else F4=0; end
        if (strcmp(ext,'.ora')||strcmp(ext,'.oqa'))||(strcmp(ext,'.oea'))
            cmd_plot='old_racah';
        elseif (strcmp(ext,'.oba'))||(strcmp(ext,'.oca'))||(strcmp(ext,'.ofa'))
            cmd_plot='band';
        elseif (strcmp(ext,'.oda'))
            cmd_plot='rcg9';
        end
        if quadTr==1, 
            spectra=4;
            if ChBxStatus('lorenz_split')
                fid1=fopen('Resources\template_split_quad.plo');
            else
                fid1=fopen('Resources\template_quad.plo');
            end
        elseif F4==1,
            spectra=1;
            if ChBxStatus('lorenz_split')
                fid1=fopen('Resources\template4F_split.plo');
            else
                fid1=fopen('Resources\template4F.plo');
            end
        else
            if ChBxStatus('lorenz_split')
                fid1=fopen('Resources\template_split.plo');
            else
                fid1=fopen('Resources\template.plo');
            end
        end
        fid2=fopen('temp.plo','wt');
                   
        if ChBxStatus('lorenz_split')
            dd=fgets(fid1);
            fprintf(fid2,'%s',dd(1:11));
            fprintf(fid2,'%3.2f %3.2f',[handles.lorenz handles.fano]);
            fprintf(fid2,'%s %4.0f\n',' range 0', handles.lorenz_break);
            dd=fgets(fid1);
            fprintf(fid2,'%s',dd(1:11));
            fprintf(fid2,'%3.2f %3.2f',[handles.lorenz2 handles.fano]);
            fprintf(fid2,'%s %4.0f %s\n',' range', handles.lorenz_break,' 9999');
        else
            dd=fgets(fid1);
            fprintf(fid2,'%s',dd(1:11)); fprintf(fid2,'%3.2f %3.2f\n',...
                [handles.lorenz handles.fano]);
        end
        dd=fgets(fid1);
        fprintf(fid2,'%s',dd(1:9)); fprintf(fid2,'%3.2f\n',handles.gauss);
        %Force range
        if ChBxStatus('force_range')
            fprintf(fid2,'%s','energy_range '); fprintf(fid2,'%3.2f %3.2f\n'...
                ,[handles.range_start handles.range_end]);
        end
        %account for the temperature
        if ChBxStatus('temperature')
            Temp=strcat( {' temp '},handles.temp);
        else
            Temp={''};
        end
        fprintf(fid2,'%s %s',cmd_plot,' '); fprintf(fid2,'%s\n','temp.ora');
        dd=fgets(fid1); fprintf(fid2,'%s',dd);
        if F4,
            len_spec_line=16;
        else
            len_spec_line=29;
        end
        
        for ii=1:(spectra),
            dd=fgets(fid1); 
            fprintf(fid2,'%s',dd);
            dd=fgets(fid1);
        
            if BEflag
                line_st=strcat(dd(1:len_spec_line),bindEs,Temp );
            else
               line_st=strcat(dd(1:len_spec_line+2),Temp );
            end
            fprintf(fid2,'%s\n',line_st{1});
        end
        dd=fgets(fid1); fprintf(fid2,'%s',dd);

        fclose(fid1);
        fclose(fid2);
        %invoke PLO routine
        dos('bin\plo1.exe <temp.plo');
        %F write .plo file
        if ~ChBxStatus('cleanup')
            movefile('temp.plo',fullfile(pathstr,[name '.plo' versn]));
        end
        file_created=1;
    end
    
function [conv, sticks]=read_frank_spec(file_in)
    fid=fopen(file_in);
    conv=fscanf(fid,'%f %f',[2,1000]); conv=conv';
    fscanf(fid,'%s',1);
    sticks=fscanf(fid,'%f %f',[2 inf]); sticks= sticks';
    fclose(fid);
        
% Add and remove files from the list to plot   
function open_file_plot_Callback(hObject, eventdata, handles)
    [fn,dn]=uigetfileE({'*.o?a', 'Simulation results(*.o?a)';'*.ctm', 'Simulation bundles(*.ctm)'},...
        'Select file to plot...','Resources\ctm4xas5.cfg',1);
    if dn~=0,    
        files2plot=getsTag('plot_file_name');
        num_files2plot=length(getsTag('plot_file_name'));
        if iscell(fn)
            for jj=1:length(fn);
               files2plot{num_files2plot+jj}=strcat(dn,fn{jj});
            end
        else
            files2plot{num_files2plot+1}=strcat(dn,fn);
        end
        setsTag('plot_file_name',files2plot);
        setvalTag('plot_file_name',num_files2plot+1);
%        [pathstr,name,ext,versn] = fileparts(strcat(dn,fn));
%         if strcmp(ext,'.oqa')||strcmp(ext,'.ofa'), 
%             quadTr=1;
%             setsTag('plot_spec_type',{'XAS' });
%         else
%             setsTag('plot_spec_type',{'XAS' 'MCD' 'MLD'});
%         end
    end
    
function rem_file_list_Callback(hObject, eventdata, handles)
    remove_list('plot_file_name');
   
function info_file_plot_Callback(hObject, eventdata, handles)
	list_files2plot=getsTag('plot_file_name');
    
    if ~isempty(list_files2plot)
        indx_files2plot=getvalTag('plot_file_name');
        [pathstr,name,ext,versn] = fileparts(list_files2plot{indx_files2plot});
        nfofile=fullfile( pathstr,[name,'.nfo',versn]);
        fid_nfo=fopen(nfofile);
        if fid_nfo~=-1,

            nfo_str=1;
            jj=1;
            while nfo_str~=-1
                nfo_str=fgets(fid_nfo);
                if nfo_str~=-1
                    file_info{jj}=nfo_str;
                    jj=jj+1;
                end
            end
            fclose(fid_nfo)
            listdlg('PromptString','File information',...
                'SelectionMode','single',...
                'ListString',file_info)
        else
            errordlg('NFO file not found','Error')
        end

    end
    
%% UPDATE STRINGS AND MAKE CONFIGURATION
% create electronic configuration string
function out_cfg_string=make_short_config_string(p_el, d_el, l_el)
    if l_el==0,
        out_cfg_string=strcat('P', num2str(p_el), 'D', num2str(d_el), 'L');
    else
        out_cfg_string=strcat('P', num2str(p_el), 'D', num2str(d_el), 'L2');
    end
    
% create short electronic configuration string
function out_cfg_string=make_config_string(p_el, d_el, l_el,f_el)
    p_str=strcat({'  P0'},num2str(p_el));
    d_str=strcat('D',num2strE(d_el));
    if l_el~=0, l_str=strcat({'  D'},num2strE(l_el)); else l_str=''; end
    if f_el~=-1, f_str=strcat({'  S'},num2strE(f_el)); else f_str=''; end 
    out_cfg_string=strcat(d_str,p_str,l_str,f_str);
 
% create short electronic configuration string for 1-3s XPS  
function out_cfg_string=make_config_string_s(d_el, s_el, d_el_ex,p_el)
    d_str=strcat('D',num2strE(d_el));
    s_str=strcat({'  S0'},num2str(s_el));
    
    if d_el_ex~=-1, 
        d_str_ex=strcat({'  D'},num2strE(d_el_ex)); 
    else
        d_str_ex=''; 
    end
    if p_el~=-1, 
        p_str=strcat({'  P0'},num2str(p_el));
    else
        p_str=''; 
    end
  
    out_cfg_string=strcat(d_str,s_str,d_str_ex,p_str);
    
% create short electronic configuration string for 1s XAS with CT  
function out_cfg_string=make_config_string_q(s_el, d_el, d_el_ex)
    d_str=strcat({'  D'},num2strE(d_el)); 
    s_str=strcat('S0',num2str(s_el));
    
    d_str_ex=strcat({'  D'},num2strE(d_el_ex));
    out_cfg_string=strcat(s_str,d_str,d_str_ex);  

% create short electronic configuration string for XES with CT  
function out_cfg_string=make_config_string_e(s_el, d_el, p_el,hole_el, drop_s, drop_p, drop_h)
    e1=strcat({'S0'},num2str(s_el)); 
    e2=strcat('D',num2strE(d_el));
    e3=strcat({'P0'},num2str(p_el)); 
    e4=strcat({'D'},num2strE(hole_el)); 
    if drop_h, e4=''; end
    if drop_p, e3=e4; e4=''; end
    if drop_s, e1=e3; e3=e4; e4=''; end
    out_cfg_string=strcat(e1,{'  '},e2,{'  '  },e3,{'  '  }, e4);   

% discard zero parameters for the case of xps 1-3s
function [line1_out,extra_flag_out,line2_out]=discard_zeros_xps_s(line1_in,extra_flag_in,line2_in)
    n_param=str2num(line1_in(1:2));
    clear arr_param
    for ii=1:5
        arr_param{ii}= line1_in((6+10*(ii-1)):(10*ii));
    end
    if extra_flag_in
        for ii=6:n_param
            jj=ii-5;
            arr_param{ii}= line2_in((5+10*(jj-1)):(10*jj-1));
        end
    end
    ii=2;
    arr_param_nonzero{1}=arr_param(1);
    for jj=2:length(arr_param)
        if str2num(arr_param{jj})==0
        else
            arr_param_nonzero{ii}=arr_param(jj);
            ii=ii+1;
        end
    end
    n_param=length(arr_param_nonzero);
    
      
    line_in_old=line1_in;
    
    line1_in(1)=num2str(n_param);
    for jj=1:5
        if jj<=(length(arr_param_nonzero))
            par_in=arr_param_nonzero{jj};
            line1_in((6+10*(jj-1)):(10*jj))=par_in{1};
        else
            line1_in((6+10*(jj-1)):(10*jj))='0.000';
        end
    end
    
    if n_param>5
        for jj=1:(n_param-5),
            line2_in((5+10*(jj-1)):(10*jj-1))=arr_param_nonzero{jj+5};
        end
        extra_flag_out=1;
    else
        line2_in='';
        extra_flag_out=0;
    end 
    
    line1_out=line1_in;
    line2_out=line2_in;

%% Panels toggle

function plot_panel_on_Callback(hObject, eventdata, handles)
    if ChBxStatus('batch_panel_on')||ChBxStatus('analize_panel_on')||ChBxStatus('fit_panel_on')
        setvalTag('plot_panel_on',1);
        setvalTag('fit_panel_on',0);
        setvalTag('batch_panel_on',0);
        setvalTag('analize_panel_on',0);
        hideControl({'analize_panel' 'batch_panel' 'fit_panel'});
        showControl({'plot_panel'});
    else
        setvalTag('plot_panel_on',1);
    end   

function batch_panel_on_Callback(hObject, eventdata, handles)
    if ChBxStatus('plot_panel_on')||ChBxStatus('analize_panel_on')||ChBxStatus('fit_panel_on')
        setvalTag('batch_panel_on',1);
        setvalTag('plot_panel_on',0);
        setvalTag('fit_panel_on',0);
        setvalTag('analize_panel_on',0);
        hideControl({'plot_panel' 'analize_panel' 'fit_panel'});
        showControl({'batch_panel'});
    else
        setvalTag('batch_panel_on',1);
    end

function analize_panel_on_Callback(hObject, eventdata, handles)
    if ChBxStatus('plot_panel_on')||ChBxStatus('batch_panel_on')||ChBxStatus('fit_panel_on')
        setvalTag('batch_panel_on',0);
        setvalTag('plot_panel_on',0);
        setvalTag('fit_panel_on',0);
        setvalTag('analize_panel_on',1);
        hideControl({'plot_panel' 'batch_panel' 'fit_panel'});
        showControl({'analize_panel'});
    else
        setvalTag('analize_panel_on',1);
    end
    
function fit_panel_on_Callback(hObject, eventdata, handles)
    if ChBxStatus('plot_panel_on')||ChBxStatus('batch_panel_on')||ChBxStatus('analize_panel_on')
        setvalTag('batch_panel_on',0);
        setvalTag('plot_panel_on',0);
        setvalTag('fit_panel_on',1);
        setvalTag('analize_panel_on',0);
        hideControl({'plot_panel' 'batch_panel' 'analize_panel'});
        showControl({'fit_panel'});
    else
        setvalTag('fit_panel_on',1);
    end
    
%% BATCH CALCULATION 
function batch_calc_Callback(hObject, eventdata, handles)  
    [fn,dn]=uiputfileE('*.rcg','Select batch calculation output file','Resources\ctm4xas5.cfg');
    handles.batch=1;
    setvalTag('autoplot',0)
    if fn~=0,
        handles.batch_dn=dn;
        fname=strcat(dn,fn);
        [pathstr,name,ext,versn] = fileparts(fname);
        num_batch_param=1;
        if ChBxStatus('batch_param2_on'), num_batch_param=2; end;
        if ChBxStatus('batch_param3_on'), num_batch_param=3; end;
        batch_param1_mesh= getvTag('batch_param1_from'):...
            (getvTag('batch_param1_to')-getvTag('batch_param1_from'))/(getvTag('batch_param1_step')'):...
            getvTag('batch_param1_to');
        if num_batch_param>1
            batch_param2_mesh= getvTag('batch_param2_from'):...
                (getvTag('batch_param2_to')-getvTag('batch_param2_from'))/(getvTag('batch_param2_step')'):...
                getvTag('batch_param2_to');
        else
            batch_param2_mesh=1;
        end
        if num_batch_param>2
            batch_param3_mesh= getvTag('batch_param3_from'):...
                (getvTag('batch_param3_to')-getvTag('batch_param3_from'))/(getvTag('batch_param3_step')'):...
                getvTag('batch_param3_to');
        else
            batch_param3_mesh=1;
        end
        

        %start the loop
        mesh_size=length(batch_param1_mesh)*length(batch_param2_mesh)*length(batch_param3_mesh);
        showControl({'stop_batch'});
        for jj_1=1:length(batch_param1_mesh)
            for jj_2=1:length( batch_param2_mesh)
                for jj_3=1:length( batch_param3_mesh)
                    if ChBxStatus('stop_batch'),
                        hideControl({'stop_batch'});
                        setvalTag('stop_batch',0);
                        close(h)
                        return
                    end
                    setsTag('stop_batch', strcat('STOP-',num2str( jj_1*jj_2*jj_3),'/',num2str(mesh_size)));
                    %set parameters
                    batch_param1_n=getvalTag('batch_param1'); batch_param1_s=getsTag('batch_param1');
                    batch_param1=batch_param1_s{batch_param1_n};
                    batch_param2_n=getvalTag('batch_param2'); batch_param2_s=getsTag('batch_param2');
                    batch_param2=batch_param2_s{batch_param2_n};
                    batch_param3_n=getvalTag('batch_param3'); batch_param3_s=getsTag('batch_param3');
                    batch_param3=batch_param3_s{batch_param3_n};
                    %loop over 1st parameter
                    switch batch_param1
                        case 'Slater'
                            tag_param1{1}='slater1';tag_param1{2}='slater2';tag_param1{3}='slater3';
                        case 'SO'
                            tag_param1{1}='so_reduc_2p';tag_param1{2}='so_reduc_3d';
                        case '10Dq'
                            tag_param1{1}='Dq_ground';tag_param1{2}='Dq_excited';
                        case 'Dt'
                            tag_param1{1}='Dt_ground';tag_param1{2}='Dt_excited';
                        case 'Ds'
                            tag_param1{1}='Ds_ground';tag_param1{2}='Ds_excited';
                        case 'M'
                            tag_param1{1}='spin_ground';tag_param1{2}='spin_excited';
                        case 'Delta'
                            tag_param1{1}='ct_delta';
                        case 'Udd'
                            tag_param1{1}='ct_u';
                        case 'Upd'
                            tag_param1{1}='ct_q';
                        case 'T_eg'
                            tag_param1{1}='hopping_a1'; tag_param1{2}='hopping_b1';
                        case 'T_t2g'
                            tag_param1{1}='hopping_b2'; tag_param1{2}='hopping_e';
                    end
                    %loop over 2nd parameter
                    switch batch_param2
                        case 'Slater'
                            tag_param2{1}='slater1';tag_param2{2}='slater2';tag_param2{3}='slater3';
                        case 'SO'
                            tag_param2{1}='so_reduc_2p';tag_param2{2}='so_reduc_3d';
                        case '10Dq'
                            tag_param2{1}='Dq_ground';tag_param2{2}='Dq_excited';
                        case 'Dt'
                            tag_param2{1}='Dt_ground';tag_param2{2}='Dt_excited';
                        case 'Ds'
                            tag_param2{1}='Ds_ground';tag_param2{2}='Ds_excited';
                        case 'M'
                            tag_param2{1}='spin_ground';tag_param2{2}='spin_excited';
                        case 'Delta'
                            tag_param2{1}='ct_delta';
                        case 'Udd'
                            tag_param2{1}='ct_u';
                        case 'Upd'
                            tag_param2{1}='ct_q';
                        case 'T_eg'
                            tag_param2{1}='hopping_a1'; tag_param2{2}='hopping_b1';
                        case 'T_t2g'
                            tag_param2{1}='hopping_b2'; tag_param2{2}='hopping_e';
                    end
                    %loop over 3rd parameter
                    switch batch_param3
                        case 'Slater'
                            tag_param3{1}='slater1';tag_param3{2}='slater2';tag_param3{3}='slater3';
                        case 'SO'
                            tag_param3{1}='so_reduc_2p';tag_param3{2}='so_reduc_3d';
                        case '10Dq'
                            tag_param3{1}='Dq_ground';tag_param3{2}='Dq_excited';
                        case 'Dt'
                            tag_param3{1}='Dt_ground';tag_param3{2}='Dt_excited';
                        case 'Ds'
                            tag_param3{1}='Ds_ground';tag_param3{2}='Ds_excited';
                        case 'M'
                            tag_param3{1}='spin_ground';tag_param3{2}='spin_excited';
                        case 'Delta'
                            tag_param3{1}='ct_delta';
                        case 'Udd'
                            tag_param3{1}='ct_u';
                        case 'Upd'
                            tag_param3{1}='ct_q';
                        case 'T_eg'
                            tag_param3{1}='hopping_a1'; tag_param3{2}='hopping_b1';
                        case 'T_t2g'
                            tag_param3{1}='hopping_b2'; tag_param3{2}='hopping_e';
                    end
                    %end loop over parameters

                    %put parameters into the fields
                    for ii=1:length(tag_param1)
                        setvTag(tag_param1{ii},batch_param1_mesh(jj_1))
                        fn_ext1=strcat({' '},batch_param1,{' '},num2str(batch_param1_mesh(jj_1),'%5.1f'));
                    end
                    if num_batch_param>1
                        for ii=1:length(tag_param2)
                            setvTag(tag_param2{ii},batch_param2_mesh(jj_2))
                        end
                        fn_ext2=strcat({' '},batch_param2,{' '},num2str(batch_param2_mesh(jj_2),'%5.1f'));
                    else
                        fn_ext2='';
                    end
                    if num_batch_param>2
                        for ii=1:length(tag_param3)
                            setvTag(tag_param3{ii},batch_param3_mesh(jj_3))
                        end
                        fn_ext3=strcat({' '},batch_param3,{' '},num2str(batch_param3_mesh(jj_3),'%5.1f'));
                    else
                        fn_ext3='';
                    end
                    
                    %create new filename
                    [pathstr,name,ext,versn] = fileparts(fname);
                    fname_full=strcat(name,fn_ext1,fn_ext2,fn_ext3,ext);
                    handles.batch_fn=fname_full{1};
                    calc_spec_Callback(hObject, eventdata, handles)
                end
            end
        end
        handles.batch=0;
        hideControl({'stop_batch'});
      end

function auto_name_Callback(hObject, eventdata, handles)       
    auto_name_params={'10Dq' 'Dt' 'Ds' 'Slater' 'SO' 'Delta' 'Udd' 'Upd' 'T_eg' 'T_t2g' };
    tag_list={'Dq_label', 'Dt_label', 'Ds_label', 'slater_label','so_label','Delta_label',...
        'Udd_label','Upd_label','label_hop12','label_hop22'};

    if ~get(hObject,'Value');
        for jj=1:length(auto_name_params),
            set(findobj('Tag',tag_list{jj}),'BackgroundColor',[0.941 0.941 0.941]);

        end
    else

        [s,v] = listdlg('PromptString','Select fields:',  'ListString',auto_name_params);
        if ~v
            set(hObject,'Value',0);
            handles.autoname='';
        else
            for jj=1:length(s)
                select_p{jj}=auto_name_params(s(jj));
            end
            for jj=1:length(auto_name_params),
                found=find(s==jj);
                if isempty(found),
                    set(findobj('Tag',tag_list{jj}),'BackgroundColor',[0.941 0.941 0.941]);
                else
                    set(findobj('Tag',tag_list{jj}),'BackgroundColor',[1 0.6 0.78]);
                end
            end
            handles.autoname=select_p;
        end
    end
    guidata(hObject,handles)
    
function [fn,dn]=autoname(handles)
    autoname_param=handles.autoname;
    fn=getsTag('element');
    for jj=1:length(autoname_param),
        an_param=autoname_param{jj};
        switch an_param{1},
            case 'Slater'
                tag_param1='slater1';
            case 'SO'
                tag_param1='so_reduc_2p';
            case '10Dq'
                tag_param1='Dq_ground';
            case 'Dt'
                tag_param1='Dt_ground';
            case 'Ds'
                tag_param1='Ds_ground';
            case 'M'
                tag_param1='spin_ground';
            case 'Delta'
                tag_param1='ct_delta';
            case 'Udd'
                tag_param1='ct_u';
            case 'Upd'
                tag_param1='ct_q';
            case 'T_eg'
                tag_param1='hopping_a1';
            case 'T_t2g'
                tag_param1='hopping_b2';
        end
        fn= strcat(fn,{' '},autoname_param{jj},{' '},getsTag(tag_param1));
    end
    fn= strcat(fn,'.rcg');
    fid=fopen('Resources\ctm4xas5.cfg','r');
    if fid>-1,
        fclose(fid);
        load('Resources\ctm4xas5.cfg','-mat');
        dn=settings.last_dn;
    else
        dn='';
    end
    fn=fn{1};
         
%% ANALYZE SECTION
function analyze_Callback(hObject, eventdata, handles)
    file2analize=getsTag('analize_file_name');
     [Kommentar,transtriadA,transsymgA,transsymoA,transsymfA,actorA,EgroundA,EfinalA,MtransA]=readspec( file2analize,0);
 
     
    handles.symmetriesG=transsymgA; % cell array of all ground state symmetries
    handles.symmetriesF=transsymfA;
    handles.actors=actorA;
    handles.Eground=EgroundA;
    handles.Efinal=EfinalA;
    handles.Mtrans=MtransA;
  
    setsTag('anl_opers',handles.actors);
    setsTag('anl_sym_G',handles.symmetriesG);
    setsTag('anl_sym_F',handles.symmetriesF);
    trans_indx=getvalTag('anl_opers');
    setsTag('anl_enrg_G',EgroundA{trans_indx});
    setsTag('anl_enrg_F',EfinalA{trans_indx});
    enrgG_indx=getvalTag('anl_enrg_G');
    enrgF_indx=getvalTag('anl_enrg_F');
    trans_int=MtransA{trans_indx};
    setvTag('anl_trans',trans_int(enrgG_indx,enrgF_indx));
    handles.anl_file_loaded=1;
    guidata(hObject,handles)
    
clear transtriadA transsymgA transsymoA transsymfA actorA EgroundA EfinalA MtransA symmetriesGA actorsoA symmetriesFA EG EGpos
clear transtriad transsymg transsymo transsymf actor Eground Efinal Mtrans symmetriesG actorso symmetriesF EG EGpos

function open_file_analize_Callback(hObject, eventdata, handles)
    [fn,dn]=uigetfileE({'*.o?a', 'Simulation results(*.o?a)'},...
        'Select file to analize...','Resources\ctm4xas5.cfg');
    if dn~=0,    
        file2analize=strcat(dn,fn);
        setsTag('analize_file_name',file2analize);
    end
    
function analize_file_name_Callback(hObject, eventdata, handles)

function anl_opers_Callback(hObject, eventdata, handles)
     analize_update_fields(handles, hObject) 

function anl_opers_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
    
function anl_sym_G_Callback(hObject, eventdata, handles)
    analize_update_fields(handles, hObject)

function anl_sym_G_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function anl_sym_F_Callback(hObject, eventdata, handles)
    analize_update_fields(handles, hObject)

function anl_sym_F_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function anl_enrg_G_Callback(hObject, eventdata, handles)
    analize_update_fields(handles, hObject)

function anl_enrg_G_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function anl_enrg_F_Callback(hObject, eventdata, handles)
    analize_update_fields(handles, hObject)

function anl_enrg_F_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function anl_trans_Callback(hObject, eventdata, handles)

function anl_trans_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function analize_update_fields(handles, hObject)
    field_tag=get(hObject,'Tag');
    if strcmp(field_tag,'anl_sym_G')||strcmp(field_tag,'anl_sym_F')||strcmp(field_tag,'anl_opers'),
        trans_indx=get(hObject, 'Value');
        setvalTag('anl_opers',trans_indx);
        setvalTag('anl_sym_G',trans_indx);
        setvalTag('anl_sym_F',trans_indx);
        Eground=handles.Eground;
        Efinal=handles.Efinal;
        Mtrans=handles.Mtrans;
        trans_int=Mtrans{trans_indx};
        setsTag('anl_enrg_G',Eground{trans_indx});
        setsTag('anl_enrg_F',Efinal{trans_indx});
        setvalTag('anl_enrg_G',1);
        setvalTag('anl_enrg_F',1);
        setvTag('anl_trans',trans_int(1,1));
    elseif strcmp(field_tag,'anl_enrg_G')||strcmp(field_tag,'anl_enrg_F')
        enrgG_indx=getvalTag('anl_enrg_G');
        enrgF_indx=getvalTag('anl_enrg_F');
        trans_indx=getvalTag('anl_opers');
        Mtrans=handles.Mtrans;
        trans_int=Mtrans{trans_indx};
        setvTag('anl_trans',trans_int(enrgG_indx,enrgF_indx));
    end
 
%%  FIT PANEL
function fit_Callback(hObject, eventdata, handles)
    sim_exist=0;
    exp2fit=getsTag('fit_exp_file');
    exp2fit_indx=getvalTag('fit_exp_file');
    if iscell(exp2fit),
        exp2fit=exp2fit{exp2fit_indx};
    end
    sims2fit=getsTag('fit_sim_files');
    coefs2fit=getsTag('fit_sim_coefs');
    legend_fname='';
    max_exp=1;
    if ChBxStatus('fit_flip'), flip=-1; else flip=1; end
    if ~(isempty(exp2fit)&&isempty(sims2fit))
        h1=findobj('Tag','plot_exists');
        if isempty(h1),
            h1=figure; set(h1,'Tag','plot_exists');
            h1a=gca(h1);
        else
            h1a=get(h1,'CurrentAxes');
        end
        hold(h1a,'off')
        %open experimental file      
        fid=fopen(exp2fit);
        if fid~=-1;
            fclose(fid)
            exp_file=load(exp2fit);
            col_y=getvTag('col_y');
            [length_exp cols_exp]=size(exp_file);
            if col_y<2,
                errordlg('Wrong experimental file format!','Error');
            else
                if col_y>cols_exp
                    setvTag('col_y',cols_exp);
                end
                exp_y=exp_file(:,getvTag('col_y'));
                exp_y=exp_y-mean(exp_y(1:5));
                max_exp=maxE(exp_y);
                exp_x=exp_file(:,getvTag('col_x'));
                exp_plot=plot(h1a,exp_x,exp_y,'b','LineWidth',1 );
                handles.fit_exp_x=exp_x;
                handles.fit_exp_y=exp_y;
                hold(h1a,'on');
                [pathstr,name,ext,versn] = fileparts(exp2fit);
                legend_fname{1}=name;
                if ChBxStatus('edge_jump') %substract edge jump
                    L3_edge=getvTag('L3_edge');
                    L2_edge=getvTag('L2_edge');
                    post_edge=getvTag('post_edge');
                    indx_post_edge=findval_c(exp_x,post_edge);
                    min_exp_x=min(exp_x); max_exp_x=max(exp_x);
                    if ~within(L2_edge,min_exp_x,max_exp_x)||~within(post_edge,min_exp_x,max_exp_x)||...
                            ~within(L3_edge,min_exp_x,max_exp_x),
                        errordlg('Edge jump parameters out of range','Error')
                    else

                        for jj=1:length(exp_x)
                            if exp_x(jj)>L3_edge,
                                edge_jump1(jj)=atan((exp_x(jj)-L3_edge)/getvTag('jump_slope'));
                            else
                                edge_jump1(jj)=0;
                            end
                            if exp_x(jj)>L2_edge,
                                edge_jump2(jj)=atan((exp_x(jj)-L2_edge)/getvTag('jump_slope'));
                            else
                               edge_jump2(jj)=0;
                            end
                        end
                        edge_jump_y=(2*edge_jump1+1*edge_jump2);
                        edge_jump_y=normalize(edge_jump_y)*exp_y(indx_post_edge);
                        jump_plot=plot(h1a,exp_x,edge_jump_y,'r','LineWidth',1 );
                        exp_y_substr=exp_y-edge_jump_y';
                        handles.fit_exp_y=exp_y_substr;
                        if ChBxStatus('show_raw')
                            delete(jump_plot); delete(exp_plot);
                            plot(h1a,exp_x,exp_y_substr,'b','LineWidth',1 );
                        else
                            plot(h1a,exp_x,exp_y_substr,'m','LineWidth',1 );
                        end
                        
                        max_exp=maxE(exp_y-edge_jump_y');
                    end
                end
            end

        end
        
        %open simulation files
        if ~isempty(sims2fit)
            for jj=1:length(sims2fit)
                hold(h1a,'on');
                sim_file=load(sims2fit{jj});
                XX{jj}=sim_file(:,1);
                x_min(jj)=min(XX{jj});
                x_max(jj)=max(XX{jj});
                switch getvalTag('fit_spec_type')
                    case 1
                        y=sim_file(:,2)+sim_file(:,3)+sim_file(:,4);
                    case 2
                        y=+sim_file(:,2)-sim_file(:,3);
                      case 3
                        y=0.5*sim_file(:,2)+0.5*sim_file(:,3)-sim_file(:,4);  
                end
                YY{jj}=y*str2num(coefs2fit{jj});
                
                [pathstr,name,ext,versn] = fileparts(sims2fit{jj});
                if ~isempty(legend_fname)
                    legend_fname{end+1}=[name ':' coefs2fit{jj}];
                else
                    legend_fname{1}=[name ':' coefs2fit{jj}];
                end
    
                 
            end
            legend_fname{end+1}='Sum';
            %determine spline limits
            min_x=max(x_min);
            max_x=min(x_max); 
            x_spl=min_x:((max_x-min_x)/3000):max_x;
            YY_spl_sum=zeros(size(x_spl));
            for jj=1:length(sims2fit),
                YY_spl{jj}=spline(XX{jj}, YY{jj}, x_spl);
                YY_spl_sum=YY_spl_sum+YY_spl{jj};
            end
            %YY_spl_sum_norm=YY_spl_sum;
            YY_spl_sum_norm=normalize(YY_spl_sum,1);
            norm_fct=maxE(YY_spl_sum_norm)/maxE(YY_spl_sum);
            
            x_spl=x_spl+getvTag('fit_offset');
            handles.fit_calc_x=x_spl;
            handles.fit_calc_y{jj}=flip*YY_spl{jj}/str2num(coefs2fit{jj});
            for jj=1:length(sims2fit),
                plot(h1a,x_spl,flip*YY_spl{jj}*norm_fct*max_exp,'m');
            end
            %  hold(h1a,'on');
            %   set(fit_parts,'Tag','fit_parts');
            plot(h1a,x_spl,flip*YY_spl_sum_norm*max_exp,'r','LineWidth',0.5);
            
            sim_exist=1;
        end
        if sim_exist, %if simulations are plotted, change axis limits
            lims=axis(h1a);
            axis(h1a,[min_x max_x lims(3) lims(4)]);
        end
        %add legend and axis titles
        legend(h1a,legend_fname);
        xlabel(h1a,'Energy /eV');
        ylabel(h1a,'Absorption crossection /a.u.');
    end
    guidata(hObject, handles);
    
function optimize_Callback(hObject, eventdata, handles)
    try
        handles.fit_calc_x;
    catch
        errordlg('Please select experimental and simulation files and click Fit','Error')
        return
    end
    try
        handles.fit_exp_x;
    catch
        errordlg('Please select experimental and simulation files and click Fit','Error')
        return
    end
    coefs2fit=getsTag('fit_sim_coefs');
    calc_x=handles.fit_calc_x;
    calc_y=handles.fit_calc_y;
    exp_x=handles.fit_exp_x;
    exp_y=handles.fit_exp_y;
    
    exp_y_spl=spline(exp_x,exp_y,calc_x);
    len_calc_y=length(calc_y);
    if len_calc_y>3,
        warndlg('Only three simulations will be considered','Warning');
    end
    if len_calc_y>3,
        warndlg('Only three simulations will be considered','Warning');
    elseif len_calc_y==1,
        errordlg('Please select at least two simulations for fitting','Error');
        return
    end
    if len_calc_y==2,
         fitfunc=@(a)sum((exp_y_spl-a(1)*calc_y{1}-a(2)*calc_y{2}).^2);
         [x,fval] = fminsearch(fitfunc,[str2num(coefs2fit{1}), str2num(coefs2fit{2})]);
    else
        fitfunc=@(a)sum((exp_y_spl-a(1)*calc_y{1}-a(2)*calc_y{2}-a(3)*calc_y{3}).^2);
        [x,fval] = fminsearch(fitfunc,[str2num(coefs2fit{1}),str2num(coefs2fit{2}), str2num(coefs2fit{3})]) ;
    end
    x=x/maxE(x);
    
    for jj=1:len_calc_y,
        coefs2fit{jj}=num2str(x(jj));
    end 
    setsTag('fit_sim_coefs',coefs2fit); 
    fit_Callback(hObject, eventdata, handles)

function fit_exp_file_Callback(hObject, eventdata, handles)
    fit_exp=getsTag('fit_exp_file');
    if strcmpi(fit_exp,'Select file to fit...')
        open_fit_exp_Callback(hObject, eventdata, handles)
    end
        
function fit_exp_file_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function open_fit_exp_Callback(hObject, eventdata, handles)
    [fn,dn]=uigetfileE({ '*.dat','Experimental files (*.dat)'},...
        'Select experimental file to fit...','Resources\ctm4xas5.cfg',1);
    if dn~=0,    
        file2fit=strcat(dn,fn);
        setsTag('fit_exp_file',file2fit);
    else
        handles.fit_exp=0;
    end
    setvalTag('fit_exp_file',1);
    guidata(hObject, handles);

function remove_fit_exp_Callback(hObject, eventdata, handles)
    rem_line='Select file to fit...';
    setsTag('fit_exp_file',rem_line);
    setvalTag('fit_exp_file',1);
    
function open_fit_sim_Callback(hObject, eventdata, handles)
  [fn,dn]=uigetfileE({ '*.xy','Simulation files (*_data.xy)'},...
        'Select simulation files files to fit...','Resources\ctm4xas5.cfg',1);
    if dn~=0,
        sims2fit=getsTag('fit_sim_files');
        coefs2fit=getsTag('fit_sim_coefs');
        
        num_sims2fit=length(getsTag('fit_sim_files'));
        
        if iscell(fn), n_new_fits=length(fn); else n_new_fits=1; end
        if iscell(fn),
            for jj=1:length(fn),
               sims2fit{num_sims2fit+jj}=strcat(dn,fn{jj});
               coefs2fit{num_sims2fit+jj}='1';  
            end
        else
             sims2fit{num_sims2fit+1}=strcat(dn,fn);
             coefs2fit{num_sims2fit+1}='1';  
        end
        setsTag('fit_sim_files',sims2fit);
        setsTag('fit_sim_coefs',coefs2fit); 
        setvalTag('fit_sim_files',length(sims2fit));
        setvalTag('fit_sim_coefs',length(sims2fit));   
    end

function remove_fit_sim_Callback(hObject, eventdata, handles)
        remove_list('fit_sim_files');
        remove_list('fit_sim_coefs');

function fit_sim_files_Callback(hObject, eventdata, handles)
    curr_pick=getvalTag('fit_sim_files');
    setvalTag('fit_sim_coefs',curr_pick);

function fit_sim_files_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fit_sim_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fit_sim_coefs_Callback(hObject, eventdata, handles)
     curr_pick=getvalTag('fit_sim_coefs');
     setvalTag('fit_sim_files',curr_pick);

function fit_sim_coefs_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fit_coef_upup_Callback(hObject, eventdata, handles)
    inc_coef=0.1;
    curr_pick=getvalTag('fit_sim_coefs');
    sim_coefs=getsTag('fit_sim_coefs');
    len_coef=length(sim_coefs);
    for jj=1:len_coef,
        if jj==curr_pick;
            sim_coefs{jj}=num2str(str2num(sim_coefs{jj})+inc_coef);
        end
    end
    setsTag('fit_sim_coefs',sim_coefs)
    if ChBxStatus('fit_live')
        fit_Callback(hObject, eventdata, handles)
    end
    
function fit_coef_up_Callback(hObject, eventdata, handles)
    inc_coef=0.01;
    curr_pick=getvalTag('fit_sim_coefs');
    sim_coefs=getsTag('fit_sim_coefs');
    len_coef=length(sim_coefs);
    for jj=1:len_coef,
        if jj==curr_pick;
            sim_coefs{jj}=num2str(str2num(sim_coefs{jj})+inc_coef);
        end
    end
    setsTag('fit_sim_coefs',sim_coefs)
    if ChBxStatus('fit_live')
        fit_Callback(hObject, eventdata, handles)
    end
    
function fit_coef_dn_Callback(hObject, eventdata, handles)
    inc_coef=-0.01;
    curr_pick=getvalTag('fit_sim_coefs');
    sim_coefs=getsTag('fit_sim_coefs');
    len_coef=length(sim_coefs);
    for jj=1:len_coef,
        if jj==curr_pick;
            sim_coefs{jj}=num2str(str2num(sim_coefs{jj})+inc_coef);
        end
    end
    setsTag('fit_sim_coefs',sim_coefs)
    if ChBxStatus('fit_live')
        fit_Callback(hObject, eventdata, handles)
    end

function fit_coef_dndn_Callback(hObject, eventdata, handles)
    inc_coef=-0.1;
    curr_pick=getvalTag('fit_sim_coefs');
    sim_coefs=getsTag('fit_sim_coefs');
    len_coef=length(sim_coefs);
    for jj=1:len_coef,
        if jj==curr_pick;
            sim_coefs{jj}=num2str(str2num(sim_coefs{jj})+inc_coef);
        end
    end
    setsTag('fit_sim_coefs',sim_coefs)
    if ChBxStatus('fit_live')
        fit_Callback(hObject, eventdata, handles)
    end

function fit_coef_0_Callback(hObject, eventdata, handles)
    curr_pick=getvalTag('fit_sim_coefs');
    sim_coefs=getsTag('fit_sim_coefs');
    inc_coef=-str2num(sim_coefs{curr_pick});
    len_coef=length(sim_coefs);
    for jj=1:len_coef,
        if jj==curr_pick;
            sim_coefs{jj}=num2str(str2num(sim_coefs{jj})+inc_coef);
        end
    end
    setsTag('fit_sim_coefs',sim_coefs)
    if ChBxStatus('fit_live')
        fit_Callback(hObject, eventdata, handles)
    end

function fit_coef_1_Callback(hObject, eventdata, handles)
    curr_pick=getvalTag('fit_sim_coefs');
    sim_coefs=getsTag('fit_sim_coefs');
    len_coef=length(sim_coefs);
    for jj=1:len_coef,
        if jj==curr_pick;
            sim_coefs{jj}='1';
        else
            sim_coefs{jj}='0';
        end
    end
    setsTag('fit_sim_coefs',sim_coefs)
    if ChBxStatus('fit_live')
        fit_Callback(hObject, eventdata, handles)
    end
    
function fit_offset_Callback(hObject, eventdata, handles)
    if ChBxStatus('fit_live')
        fit_Callback(hObject, eventdata, handles)
    end
    
function fit_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fit_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fit_live_Callback(hObject, eventdata, handles) 

function info_file_fit_Callback(hObject, eventdata, handles)
	list_files2plot=getsTag('fit_sim_files');
    if ~isempty(list_files2plot)
        indx_files2plot=getvalTag('fit_sim_files');
        [pathstr,name,ext,versn] = fileparts(list_files2plot{indx_files2plot});
        nfofile=fullfile( pathstr,[name(1:end-5),'.nfo',versn]);
        fid_nfo=fopen(nfofile);
        if fid_nfo~=-1,

            nfo_str=1;
            jj=1;
            while nfo_str~=-1
                nfo_str=fgets(fid_nfo);
                if nfo_str~=-1
                    file_info{jj}=nfo_str;
                    jj=jj+1;
                end
            end
            fclose(fid_nfo)
            listdlg('PromptString','File information',...
                'SelectionMode','single',...
                'ListString',file_info)
        else
            errordlg('NFO file not found','Error')
        end

    end  

function save_fit_Callback(hObject, eventdata, handles)
    h1=findobj('Tag','fit_sum');
    h2=findobj('Tag','fit_parts');
    if ~(isempty(h1)||isempty(h2))
        d1=get(h1);
        fit_data(:,1)=d1.XData;
        for jj=1:length(h2)
            d2=get(h2(jj));
            fit_data(:,jj+1)=d2.YData;
        end
        fit_data(:,jj+2)=d1.YData;
    end
    
   
    exp2fit=getsTag('fit_exp_file');
    exp2fit_indx=getvalTag('fit_exp_file');
    if iscell(exp2fit),
        exp2fit=exp2fit{exp2fit_indx};
    end
    [pathstr,name,ext,versn] = fileparts(exp2fit);
    fname=fullfile(pathstr,[name '_fit.dat' versn]);
    [fn,dn]=uiputfileE(fname,'Select fit output file','Resources\ctm4xas5.cfg');
    if fn~=0,
            fname=strcat(dn,fn);
            save(fname,'fit_data','-ascii')
    end
%% Edge Jump subtraction  + Fitting session  

function pick_edge_Callback(hObject, eventdata, handles)
    h1=findobj('Tag','plot_exists');

    if ~isempty(h1), 
        h1a=get(h1,'CurrentAxes');
        axes(h1a)
        [x,y]=ginput(3);
        x=sort(x);
        setvTag('L3_edge',round(x(1)))
        setvTag('L2_edge',round(x(2)))
        setvTag('post_edge',round(x(3)))
   end
        
function save_fit_session_Callback(hObject, eventdata, handles)
    if ChBxStatus('fit_panel_on')
        no_files_line='Select file to fit...';
        exp_files=getsTag('fit_exp_file');
        if (~iscell(exp_files))&&(strcmpi(exp_files, no_files_line))
            a=~iscell(exp_files)
            b=~strcmpi(exp_files, no_files_line)
            errordlg('Select experimental file to fit','Error')
            return
        end
        if iscell(exp_files),
            exp_files_indx=getvalTag('fit_exp_file');
            exp_files=exp_files{exp_files_indx};
        end
        [pathstr,name,ext,versn] = fileparts(exp_files);
        fname=fullfile(pathstr,[name '.fit' versn]);
        [fn,dn]=uiputfileE(fname,'Save fitting session...','Resources\ctm4xas5.cfg');
        if fn ~= 0,
            fit_session.exp_files=exp_files;
            fit_session.fit_files=getsTag('fit_sim_files');
            fit_session.fit_coefs=getsTag('fit_sim_coefs');
            fit_session.pre_edge=getvTag('post_edge');
            fit_session.L3_edge=getvTag('L3_edge');
            fit_session.L2_edge=getvTag('L2_edge');
            fit_session.post_edge=getvTag('post_edge');
            fit_session.edge_jump=ChBxStatus('edge_jump');
            fit_session.offset=getvTag('fit_offset');
            save([dn fn],'fit_session')
        end
    else
        errordlg('Please select Fit checkbox first!','Error')
    end
    
function load_fit_session_Callback(hObject, eventdata, handles)
    
        fit_panel_on_Callback(hObject, eventdata, handles)
      	[fn,dn]=uigetfileE('*.fit','Load fitting session...','Resources\ctm4xas5.cfg');
      	if fn ~= 0,
            fit_session_saved=load([dn,fn],'-mat');
            fit_session=fit_session_saved.fit_session;
            setsTag('fit_exp_file',fit_session.exp_files)
            setvalTag('fit_exp_file',1)
            setsTag('fit_sim_files',fit_session.fit_files);
            setvalTag('fit_sim_files',1)
            setsTag('fit_sim_coefs',fit_session.fit_coefs);
            setvalTag('fit_sim_coefs',1)
            setvTag('L3_edge',fit_session.L3_edge);  
            setvTag('L2_edge',fit_session.L2_edge);
            setvTag('post_edge',fit_session.post_edge);
            setvalTag('edge_jump', fit_session.edge_jump);
            setvTag('fit_offset',fit_session.offset);
        end
     
%% About the program (credits)

function credits()
h2=findobj('Tag','credit_window');
if isempty(h2),
    h1=figure; set(h1,'Tag','credit_window');
    
    pos(1)=10; pos(2)=300; pos(3)=550; pos(4)=300;
    set(h1,'MenuBar','none','Name','CTM4XAS credits','NumberTitle','off','Position',pos);
    a1=axes;

    axis off 
    axis image
    k1=imread('Resources\ctm4xas_about5.jpg');
    image(k1);
    set(a1,'Position',[0 0 1 1],'TickLength',[0 0])
    pause(1)
end

%% ELEMENT CHANGE

function element_Callback(hObject, eventdata, handles)
    handles=update_config(handles);
    guidata(hObject, handles);
    
function select_element_Callback(hObject, eventdata, handles)
    elementPT=periodic_table;
    if ~isempty(elementPT)
        setsTag('element',elementPT);
        handles=update_config(handles);
        guidata(hObject, handles);
    end
    
function element=periodic_table()
    h2=findobj('Tag','periodic_table');
    close(h2)
    h1=figure; 
    set(h1,'Tag','periodic_table');
    pos(3)=684;pos(1)=10;pos(2)=50;pos(4)=361;
    set(h1,'MenuBar','none','Name','Periodic table',...
        'NumberTitle','off','Resize','off','Position',pos);
    a1=axes;
    axis off 
    axis image
    image(imread('Resources\pt.jpg'));
    set(a1,'Position',[0 0 1 1],'TickLength',[0 0])
    flag=1; deleted=0;
    while flag 
        try
            [x,y]=ginput(1);
        catch
            deleted=1;
            break
        end
        xpos=ceil(x/38);
        if within(y,116,155)&&xpos<12;
            ypos=1; flag=0;
        elseif within(y,155,188)&&xpos<12;
            ypos=2; flag=0;
        elseif within(y,189,227)&&(xpos>3)&&(xpos<12);
            ypos=3; flag=0;
        elseif within(y,287,323)&&(xpos<18)&&(xpos>3);  
            ypos=4;flag=0;
        elseif within(y,325,360)&&(xpos<8)&&(xpos>6);  
            ypos=5;flag=0;    
        end
    end
    if ~deleted
        load 'Resources\ConfigPT.mat'
        element=Elements.table{ypos,xpos};
        for jj=1:length(Elements.valencies),
            valency=Elements.valencies{jj};
            if strcmp(valency{1},element)
                for ii=2:(length(valency))
                    strConfig{ii-1}=strcat(valency{1},num2str(valency{ii}),'+');
                end
                [s,v] = listdlg('PromptString','Select configuration:',...
                    'SelectionMode','single',...
                    'ListString',strConfig);
                break
            end
        end
        if v
            element=strConfig{s};
        else
            element=[];
        end
        close(h1)
    else
        element=[];
    end

%% BUNDLE
function bundle_file=make_bundles(bundle_files,cleanup)
    if cleanup, n_files=3; else n_files=length(bundle_files); end
    for jj=1:n_files,
        file_str=0;
        if jj~=3
             ii=1;
             fid=fopen(bundle_files{jj}); 
                while file_str~=-1,
                    file_str=fgets(fid);
                    if file_str~=-1
                        file_bundle{ii}=file_str;
                        ii=ii+1;
                    end
                end
              fclose(fid)
        else
            p_in=load(bundle_files{jj},'-mat');
            file_bundle=p_in.savePars; 
        end
        bundle_data{jj,1}=bundle_files{jj};
        bundle_data{jj,2}=file_bundle;
        clear file_bundle
        delete(bundle_files{jj});
    end
    [pathstr,name,ext,versn] = fileparts(bundle_files{1});
    bundle_file2save=fullfile(pathstr,[name '.ctm' versn]);
    save(bundle_file2save,'bundle_data','-mat')
    bundle_file=bundle_file2save;
    
function [output_file, nfo]=unbundle(fname, all_files)
    dd=load(fname,'-mat');
    bundle_data=dd.bundle_data;
    [pathstr_file,name,ext,versn] = fileparts(fname);
    if all_files,
        [len, a]=size(bundle_data);
    else
        len=2;
    end   
    for jj=1:len,
        if ~strcmp(bundle_data{jj,1},'');
            data2save=bundle_data{jj,2};
            [pathstr,name,ext,versn] = fileparts(bundle_data{jj,1});
            file2save=fullfile(pathstr_file,[name ext versn]);
            if jj~=3
                fid=fopen(file2save,'wt');
                for ii=1:length(data2save),
                    fprintf(fid,'%s',data2save{ii});
                end
                fclose(fid);
            else
                savePars=data2save;
                save(file2save,'savePars')
            end
        end
        
    end
    output_file=bundle_data{1,1};
    nfo=bundle_data{2,1};
    fclose all
    

%% MENU HANDLING

function bundle_menu_Callback(hObject, eventdata, handles)
    start_indx=4;
   [fn,dn]=uigetfileE({'*.o?a', 'Simulation results(*.o?a)'},...
        'Select file to make a bundle...','Resources\ctm4xas5.cfg',0);
    if fn~=0,
        [pathstr,name,ext_output,versn] = fileparts(strcat(dn,fn));
        files2bundle=dir(fullfile(pathstr,[name '.*' versn]));
        for jj=1:length(files2bundle);
            file_str=0;
            file_t=files2bundle(jj);
            fname=[pathstr '\' file_t.name];
            [tt,name_str,ext,versn] = fileparts(fname);
            switch ext
                case ext_output
                    indx=1;
                    ii=1;
                    fid=fopen(fname);
                    while file_str~=-1,
                        file_str=fgets(fid);
                        if file_str~=-1
                            file_bundle{ii}=file_str;
                            ii=ii+1;
                        end
                    end
                    fclose(fid)

                case '.param'
                    p_in=load(fname,'-mat');
                    file_bundle=p_in.savePars;
                    indx=3;
                case '.nfo'
                    indx=2;
                    ii=1;
                    fid=fopen(fname);
                    while file_str~=-1,
                        file_str=fgets(fid);
                        if file_str~=-1
                            file_bundle{ii}=file_str;
                            ii=ii+1;
                        end
                    end
                    fclose(fid)
                otherwise
                    indx=start_indx;
                    ii=1;
                    fid=fopen(fname);
                    while file_str~=-1,
                        file_str=fgets(fid);
                        if file_str~=-1
                            file_bundle{ii}=file_str;
                            ii=ii+1;
                        end
                    end
                    fclose(fid)
                    start_indx=start_indx+1;
            end
            bundle_data{indx,1}=fname;
            bundle_data{indx,2}=file_bundle;
            clear file_bundle;
            delete(fname);
        end
        bundle_file2save=fullfile(pathstr,[name '.ctm' versn]);
        save(bundle_file2save,'bundle_data','-mat')
    end
    
function unbundle_menu_Callback(hObject, eventdata, handles)
[fn,dn]=uigetfileE({'*.ctm', 'Simulation bundles (*.ctm)'},...
        'Select a bundle...','Resources\ctm4xas5.cfg',0);
    if fn~=0,
        unbundle(strcat(dn,fn), 1)
    end

function report_Callback(hObject, eventdata, handles)
    go_plot=0;
    if ChBxStatus('plot_panel_on')
        list_files=getsTag('plot_file_name');
        if ~isempty(list_files)
            go_plot=1;
        end
    elseif ChBxStatus('fit_panel_on')
        list_files=getsTag('fit_sim_files');
        if ~isempty(list_files)
            go_plot=1;
        end
    end
    if go_plot
        h0=findobj('Tag','plot_exists');
        close(h0);
        h1=figure;
        set(h1,'Tag','plot_exists','Position',[400 200 600 800],...
            'Color', [0.941176 0.941176 0.941176], 'Name','CTM4XAS report',...
            'PaperPositionMode','auto')
        h1a=axes;
        set(h1a,'Position',[0.1 0.45 0.8 0.48])
        uicontrol('Style', 'text', 'String', 'CTM4XAS report',...
            'Position', [40 770 190 20],'FontSize',14,'FontWeight','bold')
         uicontrol('Style', 'edit', 'String', 'Your comments...',...
            'Position', [234 763 250 30])
         uicontrol('Style', 'Pushbutton', 'String', 'Print',...
            'Position', [500 763 100 30],'Callback','printdlg')
        report_head={'Filename','Ion' ,'Spectrum' , 'Binding energy (eV)', 'F2dd', 'F4dd','LS3d'...
            'LS2p','F2pd','G1pd','G3pd','10Dq','Dt','Ds','M(meV)','Delta','Udd','Upd','T (b1)',...\
            'T (b2)','T (a1)','T (e)','Date created',...
            '', 'CTM4XAS 5.2 (C) Eli Stavitski and Frank de Groot, Utrecht University/NSLS'};
        for jj=1:length(report_head),
            uicontrol('Style', 'text', 'String',report_head{jj} ,...
                'Position', [20 310-jj*12 400 20],'FontSize',7,'FontWeight','bold',...
                'HorizontalAlignment','left')
        end
        if ChBxStatus('plot_panel_on')
            handles_report=1;
            plot_spec_Callback(hObject, eventdata, handles)
            handles.report=0;
        elseif ChBxStatus('fit_panel_on')
            fit_Callback(hObject, eventdata, handles)
        end 
            if length(list_files)>3, jj_max=3; else jj_max=length(list_files); end
            for jj=1:jj_max,
                [pathstr,name,ext,versn] = fileparts(list_files{jj});
                nfo_file=fullfile(pathstr,[name(1:(end-5)) '.nfo' versn]);
                fid=fopen(nfo_file);
                if fid~=-1
                          for ii=1:28,
                            nfo_str{ii}=fgets(fid);
                          end
                        fclose(fid);
                        pos_nfo=[12 8 12 23 9 9 9 12 12 12 12 11 9 9 13 12 10 10 ...
                            13 13 13 12 1];
                        lines_nfo=[1 2 3 4 6 7 8 9 10 11 12 14 15 16 17 18 19 20 21 22 23 24 28];
                        for ii=1:23,
                            temp_str=nfo_str{lines_nfo(ii)};
                            report_nfo{ii}=temp_str(pos_nfo(ii):end);
                        end
                        12
                        for ii=1:23,
                            uicontrol('Style', 'text', 'String',report_nfo{ii} ,...
                                'Position', [120+(jj-1)*130 310-ii*12 400 20],'FontSize',7,...
                                'HorizontalAlignment','left');
                        end

                        
                        
                end    
            end   
        
        set(h1,'Tag','report')
    end
 
function Untitled_1_Callback(hObject, eventdata, handles)

function Untitled_8_Callback(hObject, eventdata, handles)

function plot_spec_menu_Callback(hObject, eventdata, handles)
plot_spec_Callback(hObject, eventdata, handles)

function save_fig_menu_Callback(hObject, eventdata, handles)
h1=findobj('Tag','plot_exists');
if isempty(h1)
    errordlg('Figure is not found. Use Plot first','Figure Error');
else
    [fn,dn]=uiputfileE( ...
        {  '*.jpg',  'JPEG file (*.jpg)'; ...
        '*.tif','TIFF file (*.tif)'; ...
        '*.eps','PDF file(*.pdf)'; ...
        '*.ai','Adobe Illustrator file (*.ai)'}, ...
        'Choose a file and a format','Resources\ctm4xas5.cfg');
    if fn~=-0
        fname=strcat(dn,fn);
        [pathstr,name,ext,versn] = fileparts(fname);
        if strcmpi(ext,'.jpg')
            print(h1,'-djpeg','-r300',fname);
        elseif strcmpi(ext,'.tif')
            print(h1,'-dtiff','-r300',fname);
        elseif strcmpi(ext,'.pdf')
            print(h1,'-dpdf',fname);
         elseif strcmpi(ext,'.ai')
            print(h1,'-dill',fname);  
        else
            errordlg('Invalid file format','File Error');
        end

    end
end

function calc_spec_menu_Callback(hObject, eventdata, handles)
calc_spec_Callback(hObject, eventdata, handles)

function save_param_menu_Callback(hObject, eventdata, handles)
    savePars.expert=ChBxStatus('expert_options');
    savePars.ct=ChBxStatus('radio_ct');
    savePars.symmetry=PopUpPick('symmetry');
    savePars.Dq_excited=getvTag('Dq_excited');
    savePars.Dt_excited=getvTag('Dt_excited');
    savePars.Ds_excited=getvTag('Ds_excited');
    savePars.spin_excited=getvTag('spin_excited');
    savePars.Dq_ground=getvTag('Dq_ground');
    savePars.Dt_ground=getvTag('Dt_ground');
    savePars.Ds_ground=getvTag('Ds_ground');
    savePars.spin_ground=getvTag('spin_ground');  
    savePars.slater1=getvTag('slater1');
    savePars.slater2=getvTag('slater2');
    savePars.slater3=getvTag('slater3');
    savePars.so_reduc_2p=getvTag('so_reduc_2p');
    savePars.so_reduc_3d=getvTag('so_reduc_3d');
    savePars.ct_u=getvTag('ct_u');
    savePars.ct_delta=getvTag('ct_delta');
    savePars.ct_q=getvTag('ct_q');
    savePars.hopping_b1=getvTag('hopping_b1');
    savePars.hopping_a1=getvTag('hopping_a1');
    savePars.hopping_b2=getvTag('hopping_b2');
    savePars.hopping_e=getvTag('hopping_e');
    if handles.params_save;
        param_fname=handles.param_file;
        fn=1;
    else
        [fn,dn]=uiputfileE( {'*.param', 'Parameter file (*.param)'},...
            'Save parameters as','Resources\ctm4xas5.cfg');
        if fn~=0,
            param_fname=strcat(dn,fn);
        end
    end
    if fn~=0,
        save(param_fname,'savePars')
    end

function load_param_menu_Callback(hObject, eventdata, handles)
    [fn,dn]=uigetfileE('*.param','Load parameters file','Resources\ctm4xas5.cfg');
     if fn~=0,
        p_in=load(strcat(dn,fn),'-mat');
        loadPars=p_in.savePars;
        h1=findobj('Tag','expert_options');  
        set(h1,'Value',loadPars.expert)
        h1=findobj('Tag','radio_ct'); 
        set(h1,'Value',loadPars.ct)
        h1=findobj('Tag','symmetry'); 
        h1=findobj('Tag','symmetry'); 
        set(h1,'Value',loadPars.symmetry)
        setvTag('Dq_excited',loadPars.Dq_excited);
        setvTag('Dt_excited',loadPars.Dt_excited);
        setvTag('Ds_excited',loadPars.Ds_excited);
        setvTag('spin_excited',loadPars.spin_excited);
        setvTag('Dq_ground',loadPars.Dq_ground);
        setvTag('Dt_ground',loadPars.Dt_ground);
        setvTag('Ds_ground',loadPars.Ds_ground);
        setvTag('spin_ground',loadPars.spin_ground);
        setvTag('slater1',loadPars.slater1);
        setvTag('slater2',loadPars.slater2);
        setvTag('slater3',loadPars.slater3);
        setvTag('ct_u',loadPars.ct_u);
        setvTag('ct_delta',loadPars.ct_delta);
        setvTag('ct_q',loadPars.ct_q);
            
        setvTag('so_reduc_2p',loadPars.so_reduc_2p);
        setvTag('so_reduc_3d',loadPars.so_reduc_3d);
        setvTag('hopping_b1',loadPars.hopping_b1);
        setvTag('hopping_b1',loadPars.hopping_b1);
        setvTag('hopping_a1',loadPars.hopping_a1);
        setvTag('hopping_b2',loadPars.hopping_b2);
        setvTag('hopping_e',loadPars.hopping_e);
        update_config(handles);
        update_fields(handles);
    end

function exit_menu_Callback(hObject, eventdata, handles)
h1=findobj('Tag','gui_frank_main');
close(h1)

function blank_Callback(hObject, eventdata, handles)

function help_menu_Callback(hObject, eventdata, handles)

function about_menu_Callback(hObject, eventdata, handles)
    credits
    
%% Rest of control handling
    
function element_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function spectrum_type_Callback(hObject, eventdata, handles)
    update_fields(handles);

function transition_Callback(hObject, eventdata, handles)
        handles=update_config(handles);
        update_fields(handles)
        guidata(hObject, handles);
        
function spectrum_type_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function symmetry_Callback(hObject, eventdata, handles)
    update_fields(handles);

function symmetry_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function expert_options_Callback(hObject, eventdata, handles)
    update_fields(handles);
    
function Dq_ground_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Dq_excited_Callback(hObject, eventdata, handles)
    update_fields(handles)

function Dq_excited_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Dt_ground_Callback(hObject, eventdata, handles)
    update_fields(handles)

function Dt_ground_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Dt_excited2_Callback(hObject, eventdata, handles)
    update_fields(handles)

function crystal_excited2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function spin_ground_Callback(hObject, eventdata, handles)
    update_fields(handles)

function spin_ground_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Ds_ground_Callback(hObject, eventdata, handles)
    update_fields(handles)

function Ds_ground_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Ds_excited_Callback(hObject, eventdata, handles)
    update_fields(handles)

function Ds_excited_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function spin_excited_Callback(hObject, eventdata, handles)
    update_fields(handles)

function spin_excited_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function slater1_Callback(hObject, eventdata, handles)
    check_slaters(hObject);
    update_fields(handles)

function slater1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function slater2_Callback(hObject, eventdata, handles)
     check_slaters(hObject);
     update_fields(handles)

function slater2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function slater3_Callback(hObject, eventdata, handles)
    check_slaters(hObject);
    update_fields(handles)

function slater3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Dq_ground_Callback(hObject, eventdata, handles)
        update_fields(handles)

function init_state_Callback(hObject, eventdata, handles)

function init_state_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function final_state_Callback(hObject, eventdata, handles)

function final_state_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function lorenz_broad_Callback(hObject, eventdata, handles)

function lorenz_broad_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function gauss_broad_Callback(hObject, eventdata, handles)

function gauss_broad_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fano_broad_Callback(hObject, eventdata, handles)

function fano_broad_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function range_lo_Callback(hObject, eventdata, handles)

function range_lo_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function range_hi_Callback(hObject, eventdata, handles)

function range_hi_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function plot_file_name_Callback(hObject, eventdata, handles)
 
function plot_file_name_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function append_plot_Callback(hObject, eventdata, handles)
 
function plot_spec_type_Callback(hObject, eventdata, handles)

function plot_spec_type_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function popupmenu7_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function element_ct_Callback(hObject, eventdata, handles)
% hObject    handle to element_ct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function element_ct_CreateFcn(hObject, eventdata, handles)
% hObject    handle to element_ct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function init_state_ct_Callback(hObject, eventdata, handles)
% hObject    handle to init_state_ct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function init_state_ct_CreateFcn(hObject, eventdata, handles)
% hObject    handle to init_state_ct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function init_state_ct_mixed_Callback(hObject, eventdata, handles)

function init_state_ct_mixed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to init_state_ct_mixed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function final_state_ct_Callback(hObject, eventdata, handles)

function final_state_ct_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function final_state_ct_mixed_Callback(hObject, eventdata, handles)

function final_state_ct_mixed_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function radio_ct_Callback(hObject, eventdata, handles)
    if handles.RIXS||handles.QUAD
        setvalTag('radio_ct',0)
    end
    handles=update_config(handles);
    update_fields(handles)
    guidata(hObject, handles);

function ct_u_Callback(hObject, eventdata, handles)

function ct_u_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ct_delta_Callback(hObject, eventdata, handles)

function ct_delta_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ct_q_Callback(hObject, eventdata, handles)

function ct_q_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function lorenz_broad2_Callback(hObject, eventdata, handles)
% hObject    handle to lorenz_broad2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function lorenz_broad2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function lorenz_split_Callback(hObject, eventdata, handles)
    update_fields(handles)



function lorenz_break_Callback(hObject, eventdata, handles)
% hObject    handle to lorenz_break (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function lorenz_break_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lorenz_break (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function read_lorenz_break_Callback(hObject, eventdata, handles)
    handles=collect_param(handles);
    [pathstr,name,ext,versn] = fileparts(handles.plot_file);
    fname_ban=fullfile(pathstr,[name '.ban' versn]);
    fid=fopen(fname_ban);
    if fid==-1
        errordlg('No ban file found','File Error');
        return
    end
    fclose(fid);

function hopping_b1_Callback(hObject, eventdata, handles)
         update_fields(handles)

function hopping_b1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hopping_b1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hopping_a1_Callback(hObject, eventdata, handles)

 update_fields(handles)

function hopping_a1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hopping_b2_Callback(hObject, eventdata, handles)
     update_fields(handles)

function hopping_b2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hopping_b2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hopping_e_Callback(hObject, eventdata, handles)
 update_fields(handles)


function hopping_e_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hopping_e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit53_Callback(hObject, eventdata, handles)
% hObject    handle to edit53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function edit53_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit54_Callback(hObject, eventdata, handles)
% hObject    handle to edit54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit54 as text
%        str2double(get(hObject,'String')) returns contents of edit54 as a double


% --- Executes during object creation, after setting all properties.
function edit54_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function autoplot_Callback(hObject, eventdata, handles)

function force_range_Callback(hObject, eventdata, handles)
% hObject    handle to force_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function no_sticks_Callback(hObject, eventdata, handles)
% hObject    handle to no_sticks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function so_reduc_2p_Callback(hObject, eventdata, handles)
% hObject    handle to so_reduc_2p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function so_reduc_2p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to so_reduc_2p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function temperature_Callback(hObject, eventdata, handles)
  update_fields(handles)

function temp_set_Callback(hObject, eventdata, handles)

function temp_set_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function xas_2p_Callback(hObject, eventdata, handles)
    handles=update_config(handles);
    update_fields(handles)
    guidata(hObject, handles);
   
function xas_3p_Callback(hObject, eventdata, handles)
    handles=update_config(handles);
    update_fields(handles)
    guidata(hObject, handles); 

function xas_4p_Callback(hObject, eventdata, handles)
    handles=update_config(handles);
    update_fields(handles)
    guidata(hObject, handles);
   
function xas_3d_Callback(hObject, eventdata, handles)
    handles=update_config(handles);
    update_fields(handles)
    guidata(hObject, handles); 
    
function xas_4d_Callback(hObject, eventdata, handles)
    handles=update_config(handles);
    update_fields(handles)
    guidata(hObject, handles); 
    
function xas_5d_Callback(hObject, eventdata, handles)
    handles=update_config(handles);
    update_fields(handles)
    guidata(hObject, handles); 

function xas_1s_Callback(hObject, eventdata, handles)
    handles=update_config(handles);
    update_fields(handles)
    guidata(hObject, handles); 



% --- Executes on button press in stop_batch.
function stop_batch_Callback(hObject, eventdata, handles)
% hObject    handle to stop_batch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit57_Callback(hObject, eventdata, handles)
% hObject    handle to edit57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function edit57_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit58_Callback(hObject, eventdata, handles)
% hObject    handle to edit58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function edit58_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit59_Callback(hObject, eventdata, handles)
% hObject    handle to edit59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function edit59_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit60_Callback(hObject, eventdata, handles)
% hObject    handle to edit60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function edit60_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function analize_file_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to analize_file_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu14_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function popupmenu14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit61_Callback(hObject, eventdata, handles)
% hObject    handle to edit61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function edit61_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function checkbox13_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function edit62_Callback(hObject, eventdata, handles)
% hObject    handle to edit62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function edit62_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox14.
function checkbox14_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox14


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox15.
function checkbox15_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox15


% --- Executes on button press in checkbox16.
function checkbox16_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox16



function edit63_Callback(hObject, eventdata, handles)
% hObject    handle to edit63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit63 as text
%        str2double(get(hObject,'String')) returns contents of edit63 as a double


% --- Executes during object creation, after setting all properties.
function edit63_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox17.
function checkbox17_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox17



function batch_param1_from_Callback(hObject, eventdata, handles)
% hObject    handle to batch_param1_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of batch_param1_from as text
%        str2double(get(hObject,'String')) returns contents of batch_param1_from as a double


% --- Executes during object creation, after setting all properties.
function batch_param1_from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to batch_param1_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit65_Callback(hObject, eventdata, handles)
% hObject    handle to edit65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit65 as text
%        str2double(get(hObject,'String')) returns contents of edit65 as a double


% --- Executes during object creation, after setting all properties.
function edit65_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit66_Callback(hObject, eventdata, handles)
% hObject    handle to edit66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit66 as text
%        str2double(get(hObject,'String')) returns contents of edit66 as a double


% --- Executes during object creation, after setting all properties.
function edit66_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit67_Callback(hObject, eventdata, handles)
% hObject    handle to edit67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit67 as text
%        str2double(get(hObject,'String')) returns contents of edit67 as a double


% --- Executes during object creation, after setting all properties.
function edit67_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in batch_param1.
function batch_param1_Callback(hObject, eventdata, handles)
% hObject    handle to batch_param1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns batch_param1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from batch_param1


% --- Executes during object creation, after setting all properties.
function batch_param1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to batch_param1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit68_Callback(hObject, eventdata, handles)
% hObject    handle to edit68 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit68 as text
%        str2double(get(hObject,'String')) returns contents of edit68 as a double


% --- Executes during object creation, after setting all properties.
function edit68_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit68 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox18.
function checkbox18_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox18



function edit69_Callback(hObject, eventdata, handles)
% hObject    handle to edit69 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit69 as text
%        str2double(get(hObject,'String')) returns contents of edit69 as a double


% --- Executes during object creation, after setting all properties.
function edit69_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit69 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox19.
function checkbox19_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox19


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox20.
function checkbox20_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox20


% --- Executes on button press in batch_param1_on.
function batch_param1_on_Callback(hObject, eventdata, handles)
% hObject    handle to batch_param1_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of batch_param1_on



function edit70_Callback(hObject, eventdata, handles)
% hObject    handle to edit70 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit70 as text
%        str2double(get(hObject,'String')) returns contents of edit70 as a double


% --- Executes during object creation, after setting all properties.
function edit70_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit70 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in checkbox22.
function checkbox22_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox22



function batch_param1_to_Callback(hObject, eventdata, handles)
% hObject    handle to batch_param1_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of batch_param1_to as text
%        str2double(get(hObject,'String')) returns contents of batch_param1_to as a double


% --- Executes during object creation, after setting all properties.
function batch_param1_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to batch_param1_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function batch_param1_step_Callback(hObject, eventdata, handles)
% hObject    handle to batch_param1_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of batch_param1_step as text
%        str2double(get(hObject,'String')) returns contents of batch_param1_step as a double


% --- Executes during object creation, after setting all properties.
function batch_param1_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to batch_param1_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function batch_param2_from_Callback(hObject, eventdata, handles)
% hObject    handle to batch_param2_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of batch_param2_from as text
%        str2double(get(hObject,'String')) returns contents of batch_param2_from as a double


% --- Executes during object creation, after setting all properties.
function batch_param2_from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to batch_param2_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in batch_param2.
function batch_param2_Callback(hObject, eventdata, handles)
% hObject    handle to batch_param2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns batch_param2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from batch_param2


% --- Executes during object creation, after setting all properties.
function batch_param2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to batch_param2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in batch_param2_on.
function batch_param2_on_Callback(hObject, eventdata, handles)
% hObject    handle to batch_param2_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of batch_param2_on



function batch_param2_to_Callback(hObject, eventdata, handles)
% hObject    handle to batch_param2_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of batch_param2_to as text
%        str2double(get(hObject,'String')) returns contents of batch_param2_to as a double


% --- Executes during object creation, after setting all properties.
function batch_param2_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to batch_param2_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function batch_param2_step_Callback(hObject, eventdata, handles)
% hObject    handle to batch_param2_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of batch_param2_step as text
%        str2double(get(hObject,'String')) returns contents of batch_param2_step as a double


% --- Executes during object creation, after setting all properties.
function batch_param2_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to batch_param2_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function batch_param3_from_Callback(hObject, eventdata, handles)
% hObject    handle to batch_param3_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of batch_param3_from as text
%        str2double(get(hObject,'String')) returns contents of batch_param3_from as a double


% --- Executes during object creation, after setting all properties.
function batch_param3_from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to batch_param3_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in batch_param3.
function batch_param3_Callback(hObject, eventdata, handles)
% hObject    handle to batch_param3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns batch_param3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from batch_param3


% --- Executes during object creation, after setting all properties.
function batch_param3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to batch_param3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in batch_param3_on.
function batch_param3_on_Callback(hObject, eventdata, handles)
% hObject    handle to batch_param3_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of batch_param3_on



function batch_param3_to_Callback(hObject, eventdata, handles)
% hObject    handle to batch_param3_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of batch_param3_to as text
%        str2double(get(hObject,'String')) returns contents of batch_param3_to as a double


% --- Executes during object creation, after setting all properties.
function batch_param3_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to batch_param3_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function batch_param3_step_Callback(hObject, eventdata, handles)
% hObject    handle to batch_param3_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of batch_param3_step as text
%        str2double(get(hObject,'String')) returns contents of batch_param3_step as a double


% --- Executes during object creation, after setting all properties.
function batch_param3_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to batch_param3_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function col_x_Callback(hObject, eventdata, handles)
% hObject    handle to col_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of col_x as text
%        str2double(get(hObject,'String')) returns contents of col_x as a double


% --- Executes during object creation, after setting all properties.
function col_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to col_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function col_y_Callback(hObject, eventdata, handles)
% hObject    handle to col_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of col_y as text
%        str2double(get(hObject,'String')) returns contents of col_y as a double


% --- Executes during object creation, after setting all properties.
function col_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to col_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes on selection change in fit_spec_type.
function fit_spec_type_Callback(hObject, eventdata, handles)
% hObject    handle to fit_spec_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns fit_spec_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fit_spec_type


% --- Executes during object creation, after setting all properties.
function fit_spec_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fit_spec_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end









% --- Executes on button press in fit_flip.
function fit_flip_Callback(hObject, eventdata, handles)
% hObject    handle to fit_flip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fit_flip




% --- Executes on button press in cleanup.
function cleanup_Callback(hObject, eventdata, handles)
% hObject    handle to cleanup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cleanup


% --- Executes on button press in nonorm.
function nonorm_Callback(hObject, eventdata, handles)
% hObject    handle to nonorm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of nonorm






% --- Executes on button press in bundle.
function bundle_Callback(hObject, eventdata, handles)
% hObject    handle to bundle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bundle




% --- Executes on button press in stack.
function stack_Callback(hObject, eventdata, handles)
% hObject    handle to stack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stack




% --------------------------------------------------------------------
function Untitled_9_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes on button press in nonorm_fit.
function nonorm_fit_Callback(hObject, eventdata, handles)
% hObject    handle to nonorm_fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of nonorm_fit






% --------------------------------------------------------------------
function Untitled_10_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






function L3_edge_Callback(hObject, eventdata, handles)
% hObject    handle to L3_edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of L3_edge as text
%        str2double(get(hObject,'String')) returns contents of L3_edge as a double


% --- Executes during object creation, after setting all properties.
function L3_edge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to L3_edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function L2_edge_Callback(hObject, eventdata, handles)
% hObject    handle to L2_edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of L2_edge as text
%        str2double(get(hObject,'String')) returns contents of L2_edge as a double


% --- Executes during object creation, after setting all properties.
function L2_edge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to L2_edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pre_edge_Callback(hObject, eventdata, handles)
% hObject    handle to pre_edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pre_edge as text
%        str2double(get(hObject,'String')) returns contents of pre_edge as a double


% --- Executes during object creation, after setting all properties.
function pre_edge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pre_edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function post_edge_Callback(hObject, eventdata, handles)
% hObject    handle to post_edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of post_edge as text
%        str2double(get(hObject,'String')) returns contents of post_edge as a double


% --- Executes during object creation, after setting all properties.
function post_edge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to post_edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in edge_jump.
function edge_jump_Callback(hObject, eventdata, handles)





% --- Executes on button press in show_raw.
function show_raw_Callback(hObject, eventdata, handles)
% hObject    handle to show_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of show_raw




% --------------------------------------------------------------------
function Untitled_11_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)







function jump_slope_Callback(hObject, eventdata, handles)
% hObject    handle to jump_slope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of jump_slope as text
%        str2double(get(hObject,'String')) returns contents of jump_slope as a double


% --- Executes during object creation, after setting all properties.
function jump_slope_CreateFcn(hObject, eventdata, handles)
% hObject    handle to jump_slope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






