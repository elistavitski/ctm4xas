function [handles_axes handles_waveforms]=plotSpectraToAxes(spectra,handles_axes)

    
handles_waveforms='';
if nargin<2,
    figure;
    handles_axes=axes; 
end


axesSetHold(handles_axes,'off');

for jj=1:length(spectra)
    handles_waveforms{jj}=plot(handles_axes,spectra{jj}.x,spectra{jj}.y);
    if isfield(spectra{jj},'name')
        set(handles_waveforms{jj},'DisplayName',spectra{jj}.name);
    else
        set(handles_waveforms{jj},'DisplayName','');
    end
    axis(handles_axes,'tight');
    axesSetHold(handles_axes,'on')
end
