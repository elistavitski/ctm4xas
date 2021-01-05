function x=readtxt(filen)
[pathstr, name, ext, versn] = fileparts(filen);

    if ext=='.tat',
        delim=';';
        header_ln=7;
    elseif ext=='.CSV',
              delim=',';
        header_ln=0;
    else
        delim='';
        header_ln=0;
    end
if delim==''
    x=load(filen);
else
    datatxt=textread(filen,'%f','delimiter',delim,'headerlines',header_ln);
    warning off
    len=size(datatxt);
    x=zeros(round(len/2),2);
    for ii=1:len/2,
        x(ii,1)=datatxt(ii*2-1);
        x(ii,2)=datatxt(ii*2);
    end
end
warning on