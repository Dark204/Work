function AAA=Smote(BBB)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[v1,v2]=size(BBB);
nnn1=0;
nnn2=0;
for j=1:v1
 if(BBB(j,v2)==1)
     nnn1=nnn1+1;
     ww(nnn1,1:(v2-1))=BBB(j,1:(v2-1));
 else
     nnn2=nnn2+1;
 end
end

ooo=abs(nnn1-nnn2);

for j=1:ooo
   wp1=ceil(rand*nnn1);
   temp1(1,:)=ww(wp1,:);
   www=2;
   for x1=1:nnn1
      if(x1~=wp1)
        temp1(www,:)=ww(x1,:);
        www=www+1;
      end   
   end
   for x1=2:nnn1
      temp3=0;
      for x2=1:(v2-1)
         temp2=(temp1(1,x2)-temp1(x1,x2))*(temp1(1,x2)-temp1(x1,x2));
         temp3=temp3+temp2;
      end
      temp4(1,x1-1)=temp3;
   end
   [temp5,temp6]=sort(temp4);
   if(nnn1<=2)
     wp2=ceil(1*rand);
   elseif(nnn1<6)
     wp2=ceil(3*rand);
   elseif(nnn1>=6)
     wp2=ceil(5*rand);
   end
   wp3=rand;
   for x1=1:(v2-1)
      if(temp1(1,x1)<=temp1(temp6(1,wp2)+1,x1))
           oww(j,x1)=temp1(1,x1)+wp3*(temp1(temp6(1,wp2)+1,x1)-temp1(1,x1));
      else
           oww(j,x1)=temp1(1,x1)-wp3*(temp1(1,x1)-temp1(temp6(1,wp2)+1,x1));
      end
   end
end

oww(:,v2)=1;
for j=1:v1
  AAA(j,:)=BBB(j,:);
end
for j=1:ooo
  AAA(v1+j,:)=oww(j,:);
end
       

