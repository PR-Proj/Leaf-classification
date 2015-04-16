%% This function iterates over the images of leaves and gets the feature vector over the image by HOG

function [Data_Images,train_set,test_set,train_hog,test_hog] = getFeatures(Wx, Wy)
    Data_Images = {100}; %zeros(15,1600)';
    count2 = 1;
    files = dir('100_leaves_plant_species/red_data');
    for i= 3 : length(files)
        images = dir(strcat('100_leaves_plant_species/red_data/',files(i).name));
        class_img={16};
        count=1;
        for j = 3: length(images)
            I = imread(strcat('100_leaves_plant_species/red_data/',files(i).name,'/',images(j).name));
            %J= imresize(I, 0.75);
            class_img{count} = I;
            count= count+1;
        end
        Data_Images{count2}= class_img;
        count2= count2+1;
    end 
    %Divding training and test set
    train_hog=zeros(500,Wx*Wy*9+1);
    test_hog=zeros(1100,Wx*Wy*9+1);
    train_set={500};
    test_set={1100};
    s = RandStream('mt19937ar','Seed',0);
    for i= 1 : length(Data_Images)
        test_img={11};
        train_img={5};
        test_cnt=1;
        train_cnt=1;
        r = randperm(s,16,5);
        for j = 1:16
            H= HOG(Data_Images{i}{j},Wx, Wy)';
            H= [i H];
            if j~=r(1) && j~=r(2) && j~=r(3) && j~=r(4) && j~=r(5)
                test_img{test_cnt}= Data_Images{i}{j};
                test_hog((i-1)*11+test_cnt,:) = H;
                test_cnt= test_cnt+1;
            else 
                train_img{train_cnt}= Data_Images{i}{j};
                train_hog((i-1)*5+train_cnt,:) = H;
                train_cnt= train_cnt+1;
            end
        end
        train_set{i}= train_img;
        test_set{i}= test_img;
    end
    
%     for i= 1 : length(Data_Images)
%         
%     end
end

