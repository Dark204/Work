function [G_mean,AUC,Balance]=Once(data,km,numHN,C)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%test_sensitivity, test_specificity, test_gmean
[NumS,NumF]=size(data);  
indices=zeros(1,NumS);
rand_samples=rand(1,NumS);   %先把样本集顺序打乱
[r1,r2]=sort(rand_samples);  %对矩阵rand_samples进行排序，返回的r1是rand_samples升序排列后的值，r2是索引值，就是r1中对应位置的值在原来rand_samples中的位置
temp=floor(NumS/10);          %floor向负无穷大方向取整
for i=1:temp                 %五折交叉可以这么做，对每个样本赋予一个折标签
   indices(1,r2(1,i))=1;
end
for i=(temp+1):(2*temp)
   indices(1,r2(1,i))=2;
end
for i=(2*temp+1):(3*temp)
   indices(1,r2(1,i))=3;
end
for i=(3*temp+1):(4*temp)
   indices(1,r2(1,i))=4;
end
for i=(4*temp+1):(5*temp)
   indices(1,r2(1,i))=5;
end
for i=(5*temp+1):(6*temp)
   indices(1,r2(1,i))=6;
end
for i=(6*temp+1):(7*temp)
   indices(1,r2(1,i))=7;
end
for i=(7*temp+1):(8*temp)
   indices(1,r2(1,i))=8;
end
for i=(8*temp+1):(9*temp)
   indices(1,r2(1,i))=9;
end
for i=(9*temp+1):NumS
   indices(1,r2(1,i))=10;
end

for i=1:10             %用for循环顺序运行每一折
   test = (indices==i);  %本次循环用对应标签作为测试样本的折数
   train =~test;
   train_input=data(train,:); %剩余九折放训练集里
   test_input=data(test,:);  %下面几行把训练样本集和测试样本集中的训练数据和类标分离


% WELM_DenE
   train_input1=cal_same(train_input);%去重
   [dataG,weight]=DenE(train_input1,km); %把训练集放到DenE函数中，重新调整训练样本排列顺序，并计算对应权重
   [test_gmean(1,i),test_AUC(1,i),test_balance(1,i)] = ELM_regularized_LXL(dataG,test_input,1, numHN,'sig',C, weight);
   clear train_input1;
   clear dataG;
   clear weight;

%ELM
   [test_gmean(2,i),test_AUC(2,i),test_balance(2,i)] = ELM(train_input, test_input, 1, numHN,'sig',C);

%ELM_RUS
   train_input1=RUS(train_input);
   [test_gmean(3,i),test_AUC(3,i),test_balance(3,i)] = ELM(train_input1, test_input, 1, numHN,'sig',C);
   clear train_input1;

%ELM_ROS
   train_input1=ROS(train_input);
   [test_gmean(4,i),test_AUC(4,i),test_balance(4,i)] = ELM(train_input1, test_input, 1, numHN,'sig',C);
   clear train_input1;

%ELM_SMOTE
   train_input1=Smote(train_input);
   [test_gmean(5,i),test_AUC(5,i),test_balance(5,i)] = ELM(train_input1, test_input, 1, numHN,'sig',C);
   clear train_input1;

%WELM1
   [test_gmean(6,i),test_AUC(6,i),test_balance(6,i)] = ELM_regularized_NXN2(train_input, test_input, 1, numHN,'sig',C);

%WELM2
   [test_gmean(7,i),test_AUC(7,i),test_balance(7,i)] = ELM_regularized_LXL2(train_input, test_input, 1, numHN,'sig',C);   
end
G_mean=mean(test_gmean,2)';
AUC=mean(test_AUC,2)';
Balance=mean(test_balance,2)';
