function [dataG,weight]=DenE(data,km)
%%%%%%%%%%%%%%%%%%%
%dataG�Ǵ���õ�ѵ�����ݣ�����˳���weight��˳���Ӧ
%weight��һ���������洢��׼����fuzzyϵ��
%data���㴫��ȥ��ѵ������
%km��һ������������ȷ��ÿ����k���ڵ��Ǹ�����k,kmͨ��ȡΪ1
%%%%%%%%%%%%%%%%%%%%%%%%%
[N,P]=size(data); 
num1=0;
num2=0;
for i=1:N
   if(data(i,P)==1)
      num1=num1+1;
      data1(num1,1:P-1)=data(i,1:P-1); %ͳ�Ƶ�һ��������(��ȱ����������ǩ0)
   else
      num2=num2+1;
      data2(num2,1:P-1)=data(i,1:P-1); %ͳ�Ƶڶ�������������ȱ����������ǩ1��
   end
end

IR=num2/num1; %IRΪ���ƽ�����(��/��)
K1=ceil(sqrt(num1)*km); %��kmȷ�������еĽ��ڲ���k
K2=ceil(sqrt(num2)*km);


for i=1:num1
  temp=[];
  for j=1:num1
   temp(1,j)=norm(data1(i,:)-data1(j,:)); %�ڵ�һ���ڼ���ÿ������������������������
  end
  [s1,s2]=sort(temp);                     %���������밴��С�����������
  dis1(1,i)=1/temp(1,s2(1,K1+1));         %��ΪҲ��������������ľ��룬������ȡ��k�����ڼ���k+1������ֵ��ȡ�䵹��������k����Խ�����ܶ�Խ��k����ԽԶ���ܶ�ԽС
end

for i=1:num2
  temp=[];
  for j=1:num2
   temp(1,j)=norm(data2(i,:)-data2(j,:));%�ڶ���Ҳ���������̵���ͳ��
  end
  [s1,s2]=sort(temp);
  dis2(1,i)=1/temp(1,s2(1,K2+1));
end
sum1=sum(dis1);          %�����һ�����������ܶ��ۺϣ���һ����
sum2=sum(dis2);            %����ڶ������������ܶ��ۺϣ���һ����

for i=1:num1
   weight(1,i)=dis1(1,i)*num2/sum1;  %�����ö����࣬���ڶ������������к͹�һ��ϵ����ͳ��ÿ�������ܶ��������������ܶ��еı�����Ȼ������к�ϵ������ΪȨ��
end
for i=1:num2
   weight(1,num1+i)=dis2(1,i)*num2/sum2;   %ͬ�ϣ�������һ��
end


dataG(1:num1,:)=data1;       %��һ�������ŵ����������dataG��
dataG(1:num1,P)=1;           %�����һ��������ǩ
dataS(1:num2,:)=data2;       %�ڶ��������ȷ���datas��
dataS(1:num2,P)=2;          %�ڶ���������ǩ������WELM�п��Ի���2��������-1
dataG(num1+1:num1+num2,:)=dataS; %��dataS����dataGԭ���������棬�����µ���˳����������������ˣ���ģ��Ȩ��weight�Ǻ�����˳��һһ��Ӧ�� 