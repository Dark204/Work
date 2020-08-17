function [coeff,score]=prin(data)

X=data(:,1:end-1);
[coeff,score] = princomp(X);

[l1,l2]=size(X);
num1=0;
num2=0;
X1=[];
X2=[];
for i=1:l1
   if(data(i,end)==1)
      num1=num1+1;
      X1(num1,1:2)=score(i,1:2);
   else
      num2=num2+1;
      X2(num2,1:2)=score(i,1:2);
   end
end

scatter(X1(:,1),X1(:,2),'r');
hold on;
scatter(X2(:,1),X2(:,2),'b');
hold off;