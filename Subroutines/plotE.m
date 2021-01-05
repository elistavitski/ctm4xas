function plotE(a,clrplot,bias,factP)
if nargin<3, bias=0; factP=1; end
if nargin<2, clrplot='b';  end
plot(a(:,1),(a(:,2)-bias)/factP,clrplot)