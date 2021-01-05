function striptime=striptime(filen)
finfo=dir(filen);
fdate=finfo.date;
hours=str2num(fdate(13:14));
mins=str2num(fdate(16:17));
secs=str2num(fdate(19:20));
striptime=hours*3600+mins*60+secs;