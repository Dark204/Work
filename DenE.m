function [dataG,weight]=DenE(data,km)

[N,P]=size(data); 
num1=0;
num2=0;
for i=1:N
   if(data(i,P)==1)
      num1=num1+1;
      data1(num1,1:P-1)=data(i,1:P-1); 
   else
      num2=num2+1;
      data2(num2,1:P-1)=data(i,1:P-1); 
   end
end

IR=num2/num1; 
K1=ceil(sqrt(num1)*km); 
K2=ceil(sqrt(num2)*km);


for i=1:num1
  temp=[];
  for j=1:num1
   temp(1,j)=norm(data1(i,:)-data1(j,:)); 
  end
  [s1,s2]=sort(temp);                     
  dis1(1,i)=1/temp(1,s2(1,K1+1));         
end

for i=1:num2
  temp=[];
  for j=1:num2
   temp(1,j)=norm(data2(i,:)-data2(j,:));
  end
  [s1,s2]=sort(temp);
  dis2(1,i)=1/temp(1,s2(1,K2+1));
end
sum1=sum(dis1);         
sum2=sum(dis2);            

for i=1:num1
   weight(1,i)=dis1(1,i)*num2/sum1;  
end
for i=1:num2
   weight(1,num1+i)=dis2(1,i)*num2/sum2;   
end


dataG(1:num1,:)=data1;       
dataG(1:num1,P)=1;          
dataS(1:num2,:)=data2;       
dataS(1:num2,P)=2;          
dataG(num1+1:num1+num2,:)=dataS; 
