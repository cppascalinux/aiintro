

%% 
% get data
close all;clear;
load('ValidationSets.mat');
load('TrainingSets.mat');
numm=0;
numf=0;
finalnumm=0;
finalnumf=0;
%对验证集中的每一个元素,男性准确率
unsorted=zeros(1,2200);
for i=1:484
    for j=1:1100
        
        for z=1:20
            unsorted(j)=unsorted(j)+(ValidationSets(1).feature(i,z)-TrainingSets(1).feature(j,z))^2;
        end
    end
    for j=1:1100
        for z=1:20
            unsorted(j+1100)=unsorted(j+1100)+(ValidationSets(1).feature(i,z)-TrainingSets(2).feature(j,z))^2;
        end
    end
    %排序
       [q1,i1]=sort(unsorted,2,'ascend') ; 
    for ii=1:15
      if i1[ii]<=1100
        numm=numm+1;
      end
    end
    if numm>=8
      finalnumm=finalnumm+1;
    
    end
    numm=0;
    unsorted=zeros(1,2200);
end   

unsorted=zeros(1,2200);
for i=1:484
    for j=1:1100
       
        for z=1:20
            unsorted(j)=unsorted(j)+(ValidationSets(2).feature(i,z)-TrainingSets(1).feature(j,z))^2;
        end
    end
    for j=1:1100
      
        for z=1:20
            unsorted(j+1100)=unsorted(j+1100)+(ValidationSets(2).feature(i,z)-TrainingSets(2).feature(j,z))^2;
        end
    end
    %排序
       [q1,i1]=sort(unsorted,2,'ascend')  ;
    for ii=1:15
      if i1[ii]>1100
        numf=numf+1;
      end
    end
    if numf>=8
      finalnumf=finalnumf+1;
    end
    numf=0;
    unsorted=zeros(1,2200);
end   
ratio_m=finalnumm/484;
ratio_f=finalnumf/484;
ratio=(ratio_m+ratio_f)/2;
