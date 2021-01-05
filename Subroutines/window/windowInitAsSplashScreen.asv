function windowInitAsSplashScreen(image_file,duration)
img = imread(image_file);  %# A sample image to display
jimg = im2java(img);
frame = javax.swing.JFrame;
frame.setUndecorated(true);
icon = javax.swing.ImageIcon(jimg);
label = javax.swing.JLabel(icon);
frame.getContentPane.add(label);
frame.pack;
imgSize = size(img);
frame.setSize(imgSize(2),imgSize(1));
screenSize = get(0,'ScreenSize');  %# Get the screen size from the root object
frame.setLocation((screenSize(3)-imgSize(2))/2,...  %# Center on the screen
                  (screenSize(4)-imgSize(1))/2);
frame.show;  %# You can hide it again with frame.hide
pause(duration)
frame.hide;