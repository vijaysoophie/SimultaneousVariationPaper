function RF = make2DRF_fixedperiphery(latticeSize, r1, vals)

x = (1:latticeSize) - (latticeSize-1)/2 -1;
y = (1:latticeSize) - (latticeSize-1)/2 -1;

[X,Y] = meshgrid(x,y);

distance = X.^2 + Y.^2;

RF = distance < r1^2;
RF = 2*RF-1;
RF(RF>0) = vals(1);
RF(RF<0) = vals(2);


% figure;
% subplot(1,3,1);
% imagesc(Gauss1)
% 
% subplot(1,3,2);
% imagesc(Gauss2)
% 
% subplot(1,3,3);
% imagesc(Gauss1-Gauss2);
% title('title');
