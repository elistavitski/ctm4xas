function spectral_series=spectralseriesSetTimeFromOMNICTimestamp(spectral_series,spectra)
if length(spectra)~=length(spectral_series.time),
    disp('Dimensions mismatch')
else
    for jj=1:length(spectra),
        name=spectra{jj}.name;
        n=name(end-31:end-12);
        date_string=[n(5:6) '-' n(1:3) '-' n(end-3:end)...
            ' ' n(8:9) ':' n(11:12) ':'  n(14:15) ];
        date_recorded(jj)=datenum(date_string,0);
    end
    spectral_series.date_recorded=date_recorded; 
    spectral_series.time=(date_recorded-date_recorded(1))*86400;
end