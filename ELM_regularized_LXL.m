function [test_gmean,test_AUC,test_balance] = ELM_regularized_LXL(TrainingData_File, TestingData_File, Elm_Type, NumberofHiddenNeurons, ActivationFunction,C,weight)


%%%%%%%%%%% Macro definition
REGRESSION=0;
CLASSIFIER=1;

%%%%%%%%%%% Load training dataset
train_data=TrainingData_File;
T=train_data(:,end)';
P=train_data(:,1:size(train_data,2)-1)';
clear train_data;                       %   Release raw training data array

%%%%%%%%%%% Load testing dataset
test_data=TestingData_File;
TV.T=test_data(:,end)';
test_label=TV.T;
TV.P=test_data(:,1:size(test_data,2)-1)';
clear test_data;         

NumberofTrainingData=size(P,2);
NumberofTestingData=size(TV.P,2);
NumberofInputNeurons=size(P,1);


%W=diag(weight);
W=weight;


if Elm_Type~=REGRESSION
    %%%%%%%%%%%% Preprocessing the data of classification
    sorted_target=sort(cat(2,T,TV.T),2);
    label=zeros(1,1);                               %   Find and save in 'label' class label from training and testing data sets
    label(1,1)=sorted_target(1,1);
    j=1;
    for i = 2:(NumberofTrainingData+NumberofTestingData)
        if sorted_target(1,i) ~= label(1,j)
            j=j+1;
            label(1,j) = sorted_target(1,i);
        end
    end
    number_class=j;
    NumberofOutputNeurons=number_class;
    
    %%%%%%%%%% Processing the targets of training
    temp_T=zeros(NumberofOutputNeurons, NumberofTrainingData);
    for i = 1:NumberofTrainingData
        for j = 1:number_class
            if label(1,j) == T(1,i)
                break; 
            end
        end
        temp_T(j,i)=1;
    end
    T=temp_T*2-1;

    %%%%%%%%%% Processing the targets of testing
    temp_TV_T=zeros(NumberofOutputNeurons, NumberofTestingData);
    for i = 1:NumberofTestingData
        for j = 1:number_class
            if label(1,j) == TV.T(1,i)
                break; 
            end
        end
        temp_TV_T(j,i)=1;
    end
    TV.T=temp_TV_T*2-1;
end                                                 %   end if of Elm_Type



%%%%%%%%%%% Calculate weights & biases
% start_time_train=cputime;
tic;
%%%%%%%%%%% Random generate input weights InputWeight (w_i) and biases BiasofHiddenNeurons (b_i) of hidden neurons
InputWeight=rand(NumberofHiddenNeurons,NumberofInputNeurons)*2-1;
BiasofHiddenNeurons=rand(NumberofHiddenNeurons,1);
tempH=InputWeight*P;
ind=ones(1,NumberofTrainingData);
BiasMatrix=BiasofHiddenNeurons(:,ind);              %   Extend the bias matrix BiasofHiddenNeurons to match the demention of H
tempH=tempH+BiasMatrix;

%%%%%%%%%%% Calculate hidden neuron output matrix H
switch lower(ActivationFunction)
    case {'sig','sigmoid'}
        %%%%%%%% Sigmoid 
        H = 1 ./ (1 + exp(-tempH));
    case {'sin','sine'}
        %%%%%%%% Sine
        H = sin(tempH);    
    case {'hardlim'}
        %%%%%%%% Hard Limit
        H = double(hardlim(tempH));
    case {'tribas'}
        %%%%%%%% Triangular basis function
        H = tribas(tempH);
    case {'radbas'}
        %%%%%%%% Radial basis function
        H = radbas(tempH);
        %%%%%%%% More activation functions can be added here                
end
clear tempH;                                        %   Release the temparary array for calculation of hidden neuron output matrix H

%%%%%%%%%%% Calculate output weights OutputWeight (beta_i)
n = NumberofHiddenNeurons;
[d1,d2]=size(H);
for mm=1:d2
  OOO(:,mm)=H(:,mm)*W(1,mm);
end

OutputWeight=((OOO*H'+speye(n)/C)\(OOO*T')); 
TrainingTime=toc;
%%%%%%%%%%% Calculate the training accuracy
Y=(H' * OutputWeight)';                             %   Y: the actual output of the training data
if Elm_Type == REGRESSION
    TrainingAccuracy=sqrt(mse(T - Y))  ;             %   Calculate training accuracy (RMSE) for regression case
end
clear H;

%%%%%%%%%%% Calculate the output of testing input
start_time_test=cputime;
tempH_test=InputWeight*TV.P;
clear TV.P;             %   Release input of testing data             
ind=ones(1,NumberofTestingData);
BiasMatrix=BiasofHiddenNeurons(:,ind);              %   Extend the bias matrix BiasofHiddenNeurons to match the demention of H
tempH_test=tempH_test + BiasMatrix;
switch lower(ActivationFunction)
    case {'sig','sigmoid'}
        %%%%%%%% Sigmoid 
        H_test = 1 ./ (1 + exp(-tempH_test));
    case {'sin','sine'}
        %%%%%%%% Sine
        H_test = sin(tempH_test);        
    case {'hardlim'}
        %%%%%%%% Hard Limit
        H_test = hardlim(tempH_test);        
    case {'tribas'}
        %%%%%%%% Triangular basis function
        H_test = tribas(tempH_test);        
    case {'radbas'}
        %%%%%%%% Radial basis function
        H_test = radbas(tempH_test);        
        %%%%%%%% More activation functions can be added here        
end
TY=(H_test' * OutputWeight)';                       %   TY: the actual output of the testing data
end_time_test=cputime;
TestingTime=end_time_test-start_time_test      ;     %   Calculate CPU time (seconds) spent by ELM predicting the whole testing data

if Elm_Type == REGRESSION
    TestingAccuracy=sqrt(mse(TV.T - TY))       ;     %   Calculate testing accuracy (RMSE) for regression case
end

if Elm_Type == CLASSIFIER
%%%%%%%%%% Calculate training & testing classification accuracy
    TP=0;
    TN=0;
    FP=0;
    FN=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1 : size(T, 2)
        [x, label_index_expected]=max(T(:,i));
        [x, label_index_actual]=max(Y(:,i));
        if label_index_expected == 1 & label_index_actual ==1
            TP = TP + 1;
        elseif label_index_expected == 1 & label_index_actual ==2
            FN = FN + 1;
        elseif label_index_expected == 2 & label_index_actual ==1
            FP = FP + 1;
        elseif label_index_expected == 2 & label_index_actual ==2
            TN = TN + 1;
        end
    end


    train_sensitivity = TP/(TP+FN); %recall
    train_specificity = TN/(TN+FP); 
    train_gmean = sqrt(train_sensitivity * train_specificity);
    
    TP=0;
    TN=0;
    FP=0;
    FN=0;
    for i = 1 : size(TV.T, 2)
        [x, label_index_expected]=max(TV.T(:,i));
        [x, label_index_actual]=max(TY(:,i));
        if label_index_expected == 1 & label_index_actual ==1
            TP = TP + 1;
        elseif label_index_expected == 1 & label_index_actual ==2
            FN = FN + 1;
        elseif label_index_expected == 2 & label_index_actual ==1
            FP = FP + 1;
        elseif label_index_expected == 2 & label_index_actual ==2
            TN = TN + 1;
        end
    end ;
    if(TP+FN==0)
       test_sensitivity = 0;
    else
       test_sensitivity = TP/(TP+FN);
    end
    if(TN+FP==0)
       test_specificity = 0;
    else
       test_specificity = TN/(TN+FP);
    end
    %% FP_rate
    if(TN+FP==0)
       test_FPR =0;
    else
       test_FPR = FP/(TN+FP);
    end
    test_gmean = sqrt(test_sensitivity * test_specificity);
    test_AUC = ROC(TY(1,:),test_label,1,2);
    %% balance
    test_balance = 1-sqrt((0-test_FPR)^2+(1-test_sensitivity)^2)/sqrt(2);
end