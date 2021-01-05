function waveformAlternateColors(waveforms)

color_list={[     0     0     1];[1     0     0];[0    0.4980         0];[0.7490         0    0.7490];...
    [0     0     0];[0.0784    0.1686    0.5490];[0.8471    0.1608         0];...
    [0.1647    0.3843    0.2745];[0.0431    0.5176    0.7804];[ 0.6824    0.4667         0];...
    [0.3490    0.2000    0.3294];[0.8706    0.4902         0];[0.3216    0.1882    0.1882];...
    [0.4784    0.0627    0.8941]};

n_colors=length(color_list);
n_waveforms=length(waveforms);
for jj=1:n_waveforms,
    color_index=rem(jj,n_colors); if ~color_index, color_index=n_colors; end
    try
        set(waveforms{jj},'Color',color_list{color_index});
    catch
    end
    try
        set(waveforms{jj},'FaceColor',color_list{color_index});
    catch
    end
end
    






    

