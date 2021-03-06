function [handles_axes ]=plotMapAsMesh(map,handles_axes,varargin)
mesh_params=parseArguments(varargin);
   
if nargin<2,
    figure;
    handles_axes=axes;
end
s_h=surf(handles_axes,map.XX,map.YY, double(map.ZZ));
set(s_h,'EdgeAlpha',0.5)

grid(handles_axes,'off');
camproj(handles_axes,'perspective');
axis(handles_axes, 'tight');
if mesh_params.color
    colormap jet
else
    colormap([0 0 0])
end
if mesh_params.square;
    aspect_ratio=get(handles_axes,'DataAspectRatio');
    if aspect_ratio(1)>aspect_ratio(2),
        set(handles_axes,'DataAspectRatio',[aspect_ratio(1) aspect_ratio(1) aspect_ratio(3)] );
    else
        set(handles_axes,'DataAspectRatio',[aspect_ratio(2) aspect_ratio(2) aspect_ratio(3)] );
    end
end


function mesh_params=parseArguments(arg_in)
mesh_params.color=1;
mesh_params.square=0;

if ~isempty(arg_in)
    for jj=1:length(arg_in)
        switch arg_in{jj}
            case 'b&w'
                mesh_params.color=0;
            case 'color'
                mesh_params.color=1;
            case 'square_pixels'
                mesh_params.square=1;
        end
                
    end
end
        
