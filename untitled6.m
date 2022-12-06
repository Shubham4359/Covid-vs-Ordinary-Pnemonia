folderinput='original\NORMAL';
A=imageDatastore(folderinput);
limit = 150;

for i=1:limit
    I = imread(A.Files{i});
    ss = size(I); 
    type = size(ss);
    type = type(1,2) ;
    if(type==3)
        I = rgb2gray(I);
    end
    I = imresize(I ,[800,900]); 
    path = strcat('original\nn\',num2str(i),'.jpeg');
    imwrite(I,path)
end