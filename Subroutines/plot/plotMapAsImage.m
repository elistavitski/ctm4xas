function [handles_axes]=plotMapAsImage(map,handles_axes,varargin)
%image_params=parseArguments(varargin);
if nargin<2,
    figure;
    handles_axes=axes;
end
map=mapNormalize(map, 56);
image(map.XX(1,:),map.YY(:,1), map.ZZ,'Parent',handles_axes,varargin{:})
 set(handles_axes,'YDir','normal')
 axis(handles_axes, 'image'); 


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
        