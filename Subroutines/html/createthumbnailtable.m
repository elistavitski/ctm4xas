function createThumbnailTable(Dir,addLine,HtmlName, TSize, imagesPerRow)

% generate thumbnails:
dir_thumbnails = 'Thumbnails';
mkdir(Dir,dir_thumbnails);
resizeImageDir(Dir,dir_thumbnails,'ThumbNail_',TSize);

D = dir([Dir '\*.jpg']);
numOfCells = 0;

% Start writing the html file:
fp = fopen(HtmlName,'wt');
fprintf(fp,'<html>\n');
fprintf(fp,'<body bgcolor="aaccdd">\n');

fprintf(fp,'<p align = ''center''><font size = "4" color = "003388">Thumbnails for the images in the folder <b>''%s''</b></font>\n',Dir);
fprintf(fp,'<p align = ''center''><font size = "4" color = "003388"> ''%s''</font>\n',addLine);
fprintf(fp,'<table width="100%%" border="1" cellpadding="0">\n');
for i=1:length(D)           
    curFileName = D(i).name;
    curThumbName = ['ThumbNail_' D(i).name];
    if (mod(numOfCells, imagesPerRow)==0)
        if (numOfCells>0)
            fprintf(fp, '</tr>\n');
        end
        fprintf(fp, '<tr>\n');
    end
    fprintf(fp, '  <td align = ''center''>\n  <a href = "file:///%s/%s" target = "new"> <img src="file:///%s/%s/%s"> </a> </td>\n',...
        Dir, curFileName, Dir, dir_thumbnails, curThumbName);
    numOfCells = numOfCells + 1;
end
if (numOfCells>0)
    fprintf(fp, '</tr>\n');
end
fprintf(fp,'</table>\n');

fprintf(fp,'</body>\n');
fprintf(fp,'</html>\n');
fclose(fp);
