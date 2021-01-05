function a=within(val,dn_lim,up_lim, varargin)
   
dn_lim1=min(dn_lim,up_lim);
up_lim1=max(dn_lim,up_lim);
a=(val>dn_lim1)&&(val<up_lim1);
if ~isempty(varargin)&&(strcmp(varargin{1},'Strict')),
    a=(val>=dn_lim1)&&(val<=up_lim1);
end