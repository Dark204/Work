function outputmatrix = LearningPro(data,km)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numHN=[10,20,50,100,200,300];
C=[10,50,100,1000,10000,100000,1000000];
for m=1:6 %˳��ɨ�貢��¼��������ϵ�����
 for n=1:7
    for i=1:10
        [G_mean,A_U_C,Balance] = Once(data,km,numHN(1,m),C(1,n));
        Gmean_temp(i,:)=G_mean;
        Auc_temp(i,:)=A_U_C;
        %%
        Balance_temp(i,:)=Balance;
    end
    outputmatrix1(1,:,m,n)=mean(Gmean_temp,1); %��һ�м�¼�����㷨GMEAN
    outputmatrix1(2,:,m,n)=std(Gmean_temp,1);  %GMEAN��׼��
    outputmatrix1(3,:,m,n)=mean(Auc_temp,1);   %AUC
    outputmatrix1(4,:,m,n)=std(Auc_temp,1);    %AUC��׼��
    outputmatrix1(5,:,m,n)=mean(Balance_temp,1); %BALANCE
    outputmatrix1(6,:,m,n)=std(Balance_temp,1);  %BALANCE��׼��
    clear Gmean_temp;
    clear Auc_temp;
    clear Balance_temp;
 end
end


temp=0;
l1=1;
l2=1;
for i=1:6
  for j=1:7
    netmatrix(i,j)=outputmatrix1(1,1,i,j);
    if(outputmatrix1(1,1,i,j)>temp) %���ķ���Gmean
        temp=outputmatrix1(1,1,i,j);
        l1=i;     %�����õ����ؽڵ����ӳ��ֵ
        l2=j;     %�����õĳͷ�����ӳ��ֵ
    end
  end
end
outputmatrix=outputmatrix1(:,:,l1,l2);

for i=1:6
   xx(1,i)=i;
end

for i=1:7
   yy(1,i)=i;
end

surf(xx,yy,netmatrix');
     