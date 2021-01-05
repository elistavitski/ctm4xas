function string_out=inputdlgShow(  prompt,name,defaultanswer)    
        numlines=1;
        options.Resize='on';
        options.WindowStyle='normal';
        answer=inputdlg(prompt,name,numlines,defaultanswer,options);
        if ~isempty(answer)
            string_out=answer{1};
        else
            string_out=[];
        end