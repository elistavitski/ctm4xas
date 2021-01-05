function load_n_plot(filename, color)
dd=load(filename);
hold on
plot(dd(:,1),dd(:,2),color)