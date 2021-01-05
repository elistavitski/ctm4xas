function arr_norm=normalize(arr_in, scaling, varargin)
if nargin<2,
    scale_fac=1;
else
    if abs(max(scaling))>=abs(min(scaling))
        scale_fac=max(scaling);
    else
        scale_fac=abs(min(arr_in));
    end
end
if isempty(varargin)


    % normalize spectrum
    if abs(max(arr_in))>=abs(min(arr_in))
        arr_norm=arr_in/max(arr_in)*scale_fac;
    else
        arr_norm=arr_in/abs(min(arr_in)*scale_fac);
    end
elseif strcmp(varargin{1},'positive')
    arr_in=arr_in-min(arr_in);
    arr_norm=arr_in/max(arr_in);
end
    