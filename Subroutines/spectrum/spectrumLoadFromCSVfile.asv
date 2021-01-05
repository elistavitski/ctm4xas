function spectra_out=spectrumLoadFromCSVfile(csv_file_list)
if ~isempty(csv_file_list);
    for jj=1:length(csv_file_list)
        [pathstr, name, ext, versn] = fileparts(csv_file_list{jj});
        delim=',';
        header_ln=0;
        datatxt=textread(csv_file_list{jj},'%f','delimiter',delim,'headerlines',header_ln);
        for ii=1:length(datatxt)/2,
            spectrum.x(ii)=datatxt(ii*2-1);
            spectrum.y(ii)=datatxt(ii*2);
            spectrum.name=name;
        end
        spectra_out{jj}=spectrum;
    end
else
    spectra_out='';
end
    
