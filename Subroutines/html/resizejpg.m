function resizejpg(fileName,newFileName,preferredW)
RGB = imread(fileName);
[H,W,t] = size(RGB);
if (W>H)
    ratio = preferredW / W;
else
    ratio = preferredW / H;
end
RGBnew = imresize(RGB,ratio);
[X,map] = rgb2ind(RGBnew);
[M,N] = size(X);
imwrite(RGBnew,newFileName,'Quality',100,'BitDepth',8);