function [baseline min1 max1 min2 max2]=spectrumAnalyzeInterferogram(spectrum_in)
baseline=mean(spectrum_in.y(1:round(length(spectrum_in.y)/10)));
min1=min(spectrum_in.y(1:round(end/2)));
max1=max(spectrum_in.y(1:round(end/2)));
min2=min(spectrum_in.y(round(end/2):end));
max2=max(spectrum_in.y(1:round(end/2):end));

