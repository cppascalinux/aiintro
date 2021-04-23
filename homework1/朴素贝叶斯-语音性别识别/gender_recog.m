% 主要思想: kmeans聚类，KNN识别
clear; close;
load('voive_data.mat');
% load('voive_data_init.mat');

% 随机划分训练集、验证集
train_num = 1100;
test_num = 1584-train_num;
a=randperm(1584);
a=a(:);
b=randperm(1584)+1584;
b=b(:);
train_list_m = a(1:train_num);          % 训练集序号
train_list_f = b(1:train_num);
Train_m=v_d(train_list_m,1:20);         % 训练集数据
Train_f=v_d(train_list_f,1:20);
Test_m=v_d(1:1584,1:20);                % 测试集数据
Test_f=v_d(1585:3168,1:20);
Test_m(train_list_m,:)=[];
Test_f(train_list_f-1584,:)=[];

% k-means 聚类
k=1000;
DIM = 1;
errdlt = 0.5;
% 给男女声聚类
[Idx_m,C_m,~,~,Errlist_m] = mykmeans(Train_m,k,DIM,errdlt);
[Idx_f,C_f,~,~,Errlist_f] = mykmeans(Train_f,k,DIM,errdlt);
% figure;plot(Errlist_m,'-*');
% figure;plot(Errlist_f,'-*');
C_m = [C_m,zeros(k,1)];
C_f = [C_f,ones(k,1)];
C=[C_m;C_f];

% 分别对男女测试集做KNN识别
K = 9;
dists = zeros(k*2,2);
% 判断测试集中的男声
P_M = 0;
N_M2M = 0;
N_M2F = 0;
for i=1:test_num
    temp = repmat(Test_m(i,:),2*k,1);
    dists(:,1) = sum((temp-C(:,1:20)).^2,2);
    dists(:,2) = [zeros(k,1);ones(k,1)];
    [B,ind] = sort(dists(:,1));
    ind = ind(1:K,1);
    for j=1:K
        if ind(j,1)<=k
            P_M = P_M+1;
        end
    end
    if P_M>=(K+1)/2         % K需要是奇数
        N_M2M = N_M2M+1;
    else
        N_M2F = N_M2F+1;
    end
    P_M = 0;
end
correct_m2m = N_M2M/test_num;

% 判断测试集中的女声
P_F = 0;
N_F2M = 0;
N_F2F = 0;
for i=1:test_num
    temp = repmat(Test_f(i,:),2*k,1);
    dists(:,1) = sum((temp-C(:,1:20)).^2,2);
    dists(:,2) = [zeros(k,1);ones(k,1)];
    [B,ind] = sort(dists(:,1));
    ind = ind(1:K,1);
    for j=1:K
        if ind(j,1)>k && ind(j,1)<=2*k
            P_F = P_F+1;
        end
    end
    if P_F>=(K+1)/2
        N_F2F = N_F2F+1;
    else
        N_F2M = N_F2M+1;
    end
    P_F = 0;
end
correct_f2f = N_F2F/test_num;
correct_total = (N_M2M+N_F2F)/(test_num*2);
ans = [correct_m2m;correct_f2f;correct_total]
