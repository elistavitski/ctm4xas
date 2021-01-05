
    function spectrum=stick2spec(sticks)
    %% Translate sticks into spectrum
        stick_len=length(sticks(:,1));
        spectrum=zeros(stick_len*3,2);
        for jj=1:stick_len,
            spectrum(jj*3-2,1)=sticks(jj,1)-0.00001;
            spectrum(jj*3-1,1)=sticks(jj,1);
            spectrum(jj*3,1)=sticks(jj,1)+0.00001;
            spectrum(jj*3-2,2)=0;
            spectrum(jj*3-1,2)=sticks(jj,2);
            spectrum(jj*3,2)=0;
        end
   
        