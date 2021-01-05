function load_n_plot(filename)
dd=load(filename);
hold on
plot(dd(:,1),dd(:,2),'b')