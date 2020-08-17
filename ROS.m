function AAA=ROS(BBB)
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
  ra=ceil(rand*nnn1);
  oww(j,:)=ww(ra,:);
end

oww(:,v2)=1;
for j=1:v1
  AAA(j,:)=BBB(j,:);
end
for j=1:ooo
  AAA(v1+j,:)=oww(j,:);
end
       

