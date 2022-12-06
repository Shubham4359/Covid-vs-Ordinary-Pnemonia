% save metadata for all samples in indivdual MAT-files
save('sample1.mat','original','fuzzy','label')

% create a fileDatastore from MAT-files using a custom "ReadFcn"
trainds = fileDatastore(matFileFolder,'./','FileExtensions','.mat','ReadFcn',@matRead);

function output = matRead(fn)
s = load(fn);
img1 = imread(s.filepath1);
img2 = imread(s.filepath2);
label = s.label;
output = {img1,img2,label};
end