function [dataG,weight]=DenE(data,km)
%%%%%%%%%%%%%%%%%%%
%dataG是处理好的训练数据，它的顺序和weight的顺序对应
%weight是一个向量，存储标准化的fuzzy系数
%data是你传进去的训练数据
%km是一个参数，用于确定每类内k近邻的那个参数k,km通常取为1
%%%%%%%%%%%%%%%%%%%%%%%%%
[N,P]=size(data); 
num1=0;
num2=0;
for i=1:N
   if(data(i,P)==1)
      num1=num1+1;
      data1(num1,1:P-1)=data(i,1:P-1); %统计第一类样本数(有缺陷样本，标签0)
   else
      num2=num2+1;
      data2(num2,1:P-1)=data(i,1:P-1); %统计第二类样本数（无缺陷样本，标签1）
   end
end

IR=num2/num1; %IR为类别不平衡比率(多/少)
K1=ceil(sqrt(num1)*km); %用km确定各类中的近邻参数k
K2=ceil(sqrt(num2)*km);


for i=1:num1
  temp=[];
  for j=1:num1
   temp(1,j)=norm(data1(i,:)-data1(j,:)); %在第一类内计算每个样本到类内所有样本距离
  end
  [s1,s2]=sort(temp);                     %对上述距离按从小到大进行排序
  dis1(1,i)=1/temp(1,s2(1,K1+1));         %因为也算了样本到自身的距离，所以提取第k个近邻即第k+1个排序值，取其倒数保留，k近邻越近，密度越大，k近邻越远，密度越小
end

for i=1:num2
  temp=[];
  for j=1:num2
   temp(1,j)=norm(data2(i,:)-data2(j,:));%第二类也是上述过程单独统计
  end
  [s1,s2]=sort(temp);
  dis2(1,i)=1/temp(1,s2(1,K2+1));
end
sum1=sum(dis1);          %计算第一类所有样本密度综合，归一化用
sum2=sum(dis2);            %计算第二类所有样本密度综合，归一化用

for i=1:num1
   weight(1,i)=dis1(1,i)*num2/sum1;  %我们用多数类，即第二类样本数做中和归一化系数，统计每个样本密度在类内样本总密度中的比例，然后乘以中和系数，作为权重
end
for i=1:num2
   weight(1,num1+i)=dis2(1,i)*num2/sum2;   %同上，换成另一类
end


dataG(1:num1,:)=data1;       %第一类样本放到输出样本集dataG中
dataG(1:num1,P)=1;           %赋予第一类样本标签
dataS(1:num2,:)=data2;       %第二类样本先放在datas中
dataS(1:num2,P)=2;          %第二类样本标签，你在WELM中可以换成2，而不是-1
dataG(num1+1:num1+num2,:)=dataS; %把dataS放在dataG原有样本后面，所以新的有顺序的样本集就生成了，而模糊权重weight是和它的顺序一一对应的 