function y=getvTagM(tagIn)
%GETVTAG gets numeric value from the control bearing tag tagIn
    clear y
    h1=findobj('Tag',tagIn);
    mul_str=get(h1,'String');
    if isempty(mul_str)
        y='';
    else
        for jj=1:length(mul_str),
            y(jj)=str2num(mul_str{jj});
        end
    end

    