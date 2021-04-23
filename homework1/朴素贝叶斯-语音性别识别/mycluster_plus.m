function centers = mycluster_plus(X,k)
%MYCLUSTER_PLUS - K-means clustering initialization: kmeans++.
%   To initialize the cluster centers using kmeans++.
%   
%   centers = mycluster_plus(X,k)
% 
%   Input - 
%   X: the input N*P matrix X with N points of P-dimension;
%   k: the number of classes;
%   Output - 
%   centers: the initialized cluster centers.

%% 
if ~ismatrix(X) || ~isreal(k)
    error('Input parameter error! ');
end
[m,~] = size(X);
if k>m
    error('Error! Too many clustering classes.');
end

% specify the first center
B = [];
% choose the first point randomly
idx = mod(round(rand()*m),m)+1; 
B = cat(1,B,X(idx,:));          %����B��
X(idx,:) = [];                  %��X��ɾ��
%% 
while ~isempty(X)               %ѭ������ֱ��XΪ��
    % ����X��ʣ��㵽B�����е�ľ����
    m = size(X,1);
    bn = size(B,1);
    dists = zeros(m,1);
    for i=1:m
        Point = X(i,:); %ȡ����i����
        Mat = repmat(Point,bn,1); %��չΪbn�У�����������
        diff = Mat-B;
        dist = sqrt(sum(diff.^2,2)); %�ص�2ά��ƽ���ͣ��ٿ����ţ�dist����ΪPoint��B���еľ���
        dists(i) = sum(dist); %��Point��B�����е�ľ���֮��
    end
    [~,idx] = max(dists);       %�����ֵ
    B = cat(1,B,X(idx,:));      %����B��
    X(idx,:) = [];              %��X��ɾ��
end
centers = B(1:k,:);

end
%%