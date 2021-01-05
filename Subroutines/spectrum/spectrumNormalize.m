function spectra_out=spectrumNormalize(spectra_in,varargin)  
    if ~iscell(spectra_in),
        spectra_out=spectra_in;
        spectra_out.y=normalize(spectra_in.y,1,varargin{:});
    else

        for jj=1:length(spectra_in)
            if isstruct(spectra_in{jj})
                spectra_out{jj}=spectra_in{jj};
                spectra_out{jj}.y=normalize(spectra_in{jj}.y,1,varargin{:});
            end
        end
    end

