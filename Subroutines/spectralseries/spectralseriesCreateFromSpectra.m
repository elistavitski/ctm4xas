function spectral_series=spectralseriesCreateFromSpectra(spectra) 
if iscell(spectra)
    spectral_series.name=spectra{1}.name;
    spectral_series.energy=spectra{1}.x;
    spectral_series.spectra(:,1)=spectra{1}.y;
    for jj=2:length(spectra)
        if length(spectral_series.energy)~=length(spectra{1}.x);
            disp('Dimensions mismatch');
             spectral_series='';
             return
        else
            spectral_series.spectra(:,jj) =spectra{jj}.y;
        end
    end       
    spectral_series.time=1:1:length(spectra); 
else
    spectral_series='';
end
            