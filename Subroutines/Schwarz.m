function Schwarz(FL,size_secondary)
if nargin<1
    FL=input('Enter focal length: ');
end
im2secondary=sqrt(5)*FL;
secondary2primary=2*FL;
r_secondary=(sqrt(5)-1)*FL;
r_primary=(sqrt(5)+1)*FL;

disp(['Distance from image to secondary: ' num2str(im2secondary)]);
disp(['Distance from secondary to primary: ' num2str(secondary2primary)]);
disp(['Secondary radius: ' num2str(r_secondary)]);
disp(['Primary radius: ' num2str(r_primary)]);
if nargin<2
    size_secondary=input('Enter diameter of the secondary: ');
end
size_primary=size_secondary*(sqrt(5)+2);
disp(['Primary diameter: ' num2str(size_primary)]);





