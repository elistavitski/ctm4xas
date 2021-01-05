%loads IR spectra calculated by Ingmar
function [wavenm,intens]=load_calc_ir()
[fn,dn]=uigetfile('*.dat','Pick a file','D:\Projects\IR\Calculations\')
aa=load(strcat(dn,fn));
wavenm=0:0.01:4000;
calc_wn=aa(:,1);
calc_int=aa(:,2);
wn_new=zeros(length(calc_wn)*3,1);
for jj=1:length(calc_wn),
    wn_new(jj*3-2)=calc_wn(jj)-0.01;intens_new(jj*3-2)=0;
    wn_new(jj*3-1)=calc_wn(jj);intens_new(jj*3-1)=calc_int(jj);
   wn_new(jj*3)=calc_wn(jj)+0.01;intens_new(jj*3)=0;
end

wavenm=wn_new;
intens=intens_new';
