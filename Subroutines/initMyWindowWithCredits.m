function initMyWindowWithCredits(window_title, window_bckg_file,window_position)
    if nargin<3,
        window_position(1)=10; window_position(2)=300;
        window_position(3)=550; window_position(4)=300;
    end
    h2=findobj('Tag','credit_window');
    if isempty(h2),
        h1=figure; set(h1,'Tag','credit_window');
        set(h1,'MenuBar','none','Name',window_title,'NumberTitle','off','Position',window_position);
        a1=axes;
        axis off 
        axis image
        k1=imread(window_bckg_file);
        image(k1);
        set(a1,'Position',[0 0 1 1],'TickLength',[0 0])
        pause(1)
    end   