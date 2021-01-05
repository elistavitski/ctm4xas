function [handles_axes handles_waveforms]=plotSpectralSeriesAsSurface(spectral_series,handles_axes)
handles_waveforms='';
if nargin<2,
    figure;
    handles_axes=axes;
end
[xx,yy]=meshgrid(spectral_series.energy, spectral_series.time);
handles_waveforms=surf(xx,yy,spectral_series.spectra');
set(handles_waveforms,'Clipping','on')
axis tight
shading interp
