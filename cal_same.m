function[data]=cal_same(data)
[m,~]=size(data);
s=[];
number=0;
for i=1:m-1
    for j=i+1:m
        if data(i,:)==data(j,:)
            number=number+1;
            s(number)=i;
         end
    end
end
data(s,:)=[];