function AAA=RUS(BBB)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[v1,v2]=size(BBB);
nnn1=0;
nnn2=0;
for j=1:v1
 if(BBB(j,v2)==2)
     nnn2=nnn2+1;
     ww(nnn2,:)=BBB(j,:);
 else
     nnn1=nnn1+1;
     qq(nnn1,:)=BBB(j,:);
 end
end

ooo=abs(nnn1-nnn2);

ee=rand(1,nnn2);
[ee1,ee2]=sort(ee);
for j=1:nnn1
  oww(j,:)=ww(ee2(j),:);
end

for j=1:nnn1
  AAA(j,:)=qq(j,:);
end
for j=1:nnn1
  AAA(nnn1+j,:)=oww(j,:);
end
       

