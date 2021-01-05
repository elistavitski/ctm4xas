function y=guicomponentGetNumber(handle_in)
%GETVTAG gets numeric value from the control bearing tag tagIn

    y=str2num(get(handle_in,'String'));
    