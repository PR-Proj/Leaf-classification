%Assignment 4 Q1 Gagan Khanijau 2011046

% clc
% clear
%%data loading and division
No_of_Samples= 1600;
No_of_features= 81;
DataSet = Data_tmp; %importdata('E:\datat\data.txt');
Indices_crossValidated= crossvalind('Kfold',No_of_Samples,2);
%creating traing and testing matrices

DataSet_train = zeros(1400,No_of_features+1);
DataSet_test = zeros(200,No_of_features+1);
r = randi([1 16],1,2);
for i=1:No_of_Samples
    ndx= mod(i,16);
    ndx(ndx == 0) = 16;
    if ndx ~= r(1) && ndx ~=r(2)
        DataSet_train(i,1:No_of_features+1) = DataSet(i,1:No_of_features+1);
    else
        DataSet_test(i,1:No_of_features+1) = DataSet(i,1:No_of_features+1);
    end
end

DataSet_train(all(~DataSet_train,2), : ) = [];  
DataSet_test( all(~DataSet_test,2), : ) = [];

%random initial centres k=100
%InitialRandomCentres= randperm(1400,100);
CentreFeatures= zeros(100,81);
% counter= 1;
for i=1:100
      CentreFeatures(i,1:81)= DataSet_train(InitialRandomCentres(i),2:82);
%       CentreFeatures(i,1:81)= DataSet_train(counter,2:82);
%       counter= counter+14;
end
% CentreFeatures(1,1:4)= DataSet_train(InitialRandomCentres(1),2:5);
% CentreFeatures(2,1:4)= DataSet_train(InitialRandomCentres(2),2:5);
% CentreFeatures(3,1:4)= DataSet_train(InitialRandomCentres(3),2:5);


Train_assignedCluster= zeros(1400,1);
%stopping flag

flag= 1;

%algorithm k means
while(flag)
    flag=0;
    for i = 1:1400
        DistanceFromCentres= zeros(100,1);
        for j=1:100
            DistanceFromCentres(j)= norm(DataSet_train(i,2:82)- CentreFeatures(j,1:81));
        end
%         DistanceFromCentres(1)= norm(DataSet_train(i,2:5)- CentreFeatures(1,1:4));
%         DistanceFromCentres(2)= norm(DataSet_train(i,2:5)- CentreFeatures(2,1:4));
%         DistanceFromCentres(3)= norm(DataSet_train(i,2:5)- CentreFeatures(3,1:4));
        [sortedValues, sortedIndex]= sort(DistanceFromCentres,'ascend');
        if Train_assignedCluster(i)~=sortedIndex(1)
            Train_assignedCluster(i)=sortedIndex(1);
            flag=1;
        end    
    end 
    CentreFeatures= zeros(100,81);
    PointsinCluster=zeros(100,1);
    for j=1:1400
        CentreFeatures(Train_assignedCluster(j),:) = CentreFeatures(Train_assignedCluster(j),:) + DataSet_train(j,2:82); 
        PointsinCluster(Train_assignedCluster(j))=PointsinCluster(Train_assignedCluster(j))+1;
    end
    for j=1:100
        CentreFeatures(j,:)= CentreFeatures(j,:)/PointsinCluster(j);
    end
%     CentreFeatures(1,:)= CentreFeatures(1,:)/PointsinCluster(1);
%     CentreFeatures(2,:)= CentreFeatures(2,:)/PointsinCluster(2);
%     CentreFeatures(3,:)= CentreFeatures(3,:)/PointsinCluster(3);
end


%%training data accuracy
TrainingFrequencyMatrix=zeros(100);

for i=1:1400
    TrainingFrequencyMatrix(Train_assignedCluster(i),DataSet_train(i))=TrainingFrequencyMatrix(Train_assignedCluster(i),DataSet_train(i))+1;
end

TrainingOutputLabels= zeros(1400,1);
for i=1:1400
    [val,ndx]=max(TrainingFrequencyMatrix(Train_assignedCluster(i),:));
    TrainingOutputLabels(i)= ndx;
end

Correct=0;
for i=1:1400
    if TrainingOutputLabels(i)==DataSet_train(i,1)
        Correct=Correct+1;
    end    
end

AccuracyTraining = Correct/1400;
Training_Error = 1- AccuracyTraining
%plotconfusion(training_data(:,1),train_outputLbls)

%%testing data accuracy 

Test_AssignedCluster= zeros(200,1);
for i = 1:200
        DistanceFromCentres= zeros(100,1);
        for j=1:100
            DistanceFromCentres(j)= norm(DataSet_test(i,2:82)- CentreFeatures(j,1:81));
        end
%         DistanceFromCentres(1)= norm(DataSet_test(i,2:5)- CentreFeatures(1,1:4));
%         DistanceFromCentres(2)= norm(DataSet_test(i,2:5)- CentreFeatures(2,1:4));
%         DistanceFromCentres(3)= norm(DataSet_test(i,2:5)- CentreFeatures(3,1:4));
        [sortedValues, sortedIndex]= sort(DistanceFromCentres,'ascend');
        Test_AssignedCluster(i)=sortedIndex(1);
end

TestingFrequencyMatrix=zeros(100);

for i=1:200
    TestingFrequencyMatrix(Test_AssignedCluster(i),DataSet_test(i))=TestingFrequencyMatrix(Test_AssignedCluster(i),DataSet_test(i))+1;
end

TestingOutputLabels= zeros(200,1);
for i=1:200
    [val,ndx]=max(TestingFrequencyMatrix(Test_AssignedCluster(i),:));
    TestingOutputLabels(i)= ndx;
end

Correct=0;
for i=1:200
    if TestingOutputLabels(i)==DataSet_test(i,1)
        Correct=Correct+1;
    end    
end

accuracytest = Correct/200;
Testing_Error= 1-accuracytest

%plotconfusion(testing_data(:,1),test_outputLbls)