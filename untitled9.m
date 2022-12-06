clc;
clear all;
close all;
clear workspace;
I = imread('image.jpg');
Igray = rgb2gray(I);
Img = im2double(Igray);
GImgx = [-1 1];
GImgy = GImgx' ;
Imgx = conv2(Img, GImgx,'same');
Imgy = conv2(Img, GImgy,'same');
figure(1)
image(Imgx,'CDataMapping','scaled')
colormap('gray')
title('Imgx')
figure(2)
image(Imgy,'CDataMapping','scaled')
colormap('gray')
title('Imgy')
%Edge detection Fuzzy inference system gets image gradient as input to
%detect break in image
edgeFIS = mamfis('Name','edgeDetection');
edgeFIS = addInput(edgeFIS,[-1 1],'Name','Imgx');
edgeFIS = addInput(edgeFIS,[-1 1],'Name','Imgy');
% lesser the deviation more perfect the result
sx=0.1;
sy=0.1;
edgeFIS = addMF(edgeFIS,'Imgx','gaussmf',[sx 0],'Name','zero');
edgeFIS = addMF(edgeFIS,'Imgy','gaussmf',[sy 0],'Name','zero');
edgeFIS = addOutput(edgeFIS,[0 1],'Name','Iout');
d1=0.1;
d2=1;
d3=1;
d4=0;
d5=0;
d6=0.7;
% defining membership functions
edgeFIS = addMF(edgeFIS,'Iout','trimf',[d1 d2 d3],'Name','white');
edgeFIS = addMF(edgeFIS,'Iout','trimf',[d4 d5 d6],'Name','black');
figure(3)
subplot(2,2,1)
plotmf(edgeFIS,'input',1)
title('Imgx')
subplot(2,2,2)
plotmf(edgeFIS,'input',2)
title('Imgy')
subplot(2,2,[3 4])
plotmf(edgeFIS,'output',1)
title('Iout')
% defining the rules for belonginess/ when to consider a point on edge or
% otherwise
r1="If Imgx is zero and Imgy is zero then Iout is white";
r2="If Imgx is not zero and Imgy is not zero then Iout is black";
edgeFIS = addRule(edgeFIS,[r1 r2]);
edgeFIS.Rules
Ieval = zeros(size(Img));
% interatting over each row of image to check for its belongingness
for ii = 1:size(Img,1)
    Ieval(ii,:)= evalfis(edgeFIS,[(Imgx(ii,:));(Imgy(ii,:))]');
end
figure(4)
image(Img,'CDataMapping','scaled')
colormap('gray')
title('Orignal GrayScale Image')
figure(5)
image(Ieval,'CDataMapping','scaled')
colormap('gray')
title('Edge Detection using Fuzzy Logic')