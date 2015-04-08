%% This function iterates over the images of leaves and gets the feature vector over the image by HOG

function Data = getFeatures(Win_X, Win_Y)
    Data = zeros(Win_X*Win_Y*9+1,1600)';
    Count = 1;
    files = dir('100_leaves_plant_species/data');
    for i= 3 : length(files)
        images = dir(strcat('100_leaves_plant_species/data/',files(i).name));
        for j = 3: length(images)
            I = imread(strcat('100_leaves_plant_species/data/',files(i).name,'/',images(j).name));
            H= HOG(I,Win_X, Win_Y)';
            H= [H i-2];
            Data(Count,:) = H;
            Count = Count+1;
        end
    end    
end