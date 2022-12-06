inputSize=[800 900];
firstFolderName='original';
secondFolderName='fuzzy';
original = imageDatastore(strcat(firstFolderName,filesep), 'IncludeSubfolders',true, 'LabelSource','foldernames');
fuzzy = imageDatastore(strcat(secondFolderName,filesep), 'IncludeSubfolders',true, 'LabelSource','foldernames');

classes = categories(original.Labels);
