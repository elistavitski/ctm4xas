function [handle_window handle_axes]=windowInit(varargin)
    handle_window=figure;
    if ~isempty(varargin),
        set(handle_window, varargin{:});
    end
    handle_axes=axes;
    
    