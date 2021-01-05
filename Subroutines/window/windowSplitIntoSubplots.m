function handles_subplots=windowSplitIntoSubplots(handle_window,n_subplots,varargin)
    if isempty(varargin)
        flip_dimensions=0;
    else
        flip_dimensions=1;
    end
    
size_old=get(handle_window,'Position');
children_list=get(handle_window,'Children');
if ~isempty(children_list),
    n_subplots_old=0;
    for jj=1:length(children_list)
        if strcmp(get(children_list(jj),'Type'),'axes');
            n_subplots_old=n_subplots_old+1;
        end
    end
else
    n_subplots_old=1;
end
    
m_old=ceil(sqrt(n_subplots_old)); 
n_old=ceil(n_subplots_old/m_old);

m_new=ceil(sqrt(n_subplots)); 
n_new=ceil(n_subplots/m_new);
factor_m=m_new/m_old;
factor_n=n_new/n_old;




if ~flip_dimensions        
    set(handle_window,'Position',[size_old(1) size_old(2)...
            size_old(3)*factor_m size_old(4)*factor_n]);
    for jj=1:n_subplots,
        handles_subplots{jj}=subplot(n_new,m_new,jj);

    end
else
    set(handle_window,'Position',[size_old(1) size_old(2)...
            size_old(3)*factor_n size_old(4)*factor_m]);
    for jj=1:n_subplots,
        handles_subplots{jj}=subplot(m_new,n_new,jj);
      
    end
end