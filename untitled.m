close all;
clc;

folderinput='train\COVID19';
folderinput_1='train\PNEUMONIA';
folderinput_2='train\NORMAL';
A=imageDatastore(folderinput_1);
limit = length(A.Files);
for i=1:limit
    I = imread(A.Files{i});
    ss = size(I); 
    type = size(ss);
    type = type(1,2) ;
    if(type==3)
        I = rgb2gray(I);
    end
    I = imresize(I ,[800,900]);
    I_final = edge_detection(I); 
    new_Img=imfuse(I,I_final);
    path = strcat('Data\PNEUMONIA',num2str(i),'.jpeg');
    imwrite(new_Img,path)
end
