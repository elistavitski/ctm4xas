function spectra_out=spectrumTruncate(spectra_in,limits)
if ~iscell(spectra_in), temp{1}=spectra_in; spectra_in=temp; end
for jj=1:length(spectra_in)
    if isstruct(spectra_in{jj})
        spectra_out{jj}=spectra_in{jj};
            limit_lo=findval_c(spectra_in{jj}.x,limits(1));
            limit_hi=findval_c(spectra_in{jj}.x,limits(2));
            limit_min=min([limit_lo limit_hi ]);
             limit_max=max([limit_lo limit_hi ]);
            spectra_out{jj}.x=spectra_in{jj}.x(limit_min:limit_max);
            spectra_out{jj}.y=spectra_in{jj}.y(limit_min:limit_max);
    end
end
