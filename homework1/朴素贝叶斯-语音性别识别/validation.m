% Validation: validate model achieved by testing sets with validation sets.
% 
%   Copyright (c) 2018 CHEN Tianyang

%% 
% get data
close all;clear;
load('ValidationSets.mat');
load('TrainingSets.mat');
stepnum = 20;

%% 
% validate
prob_m = 1;
prob_f = 1;
for i=1:2
    for j=1:ValidationSets(i).number              % for each voice
        data = ValidationSets(i).feature(j,:);
        for k=1:20
            % probability of being male voice
            ValidationSets(i).results(j,1)=...
                TrainingSets(1).feature_prob(data(k),k)*ValidationSets(i).results(j,1);
            % probability of being female voice
            ValidationSets(i).results(j,2)=...
                TrainingSets(2).feature_prob(data(k),k)*ValidationSets(i).results(j,2);
        end
        if ValidationSets(i).results(j,1) > ValidationSets(i).results(j,2)
            % this is male voice
            ValidationSets(i).results(j,3) = 0;
        else
            % this is female voice
            ValidationSets(i).results(j,3) = 1;
        end
    end
end

% calculate the accuracy for male and female separately
accurate_num_m = sum(ValidationSets(1).number)-sum(ValidationSets(1).results(:,3));
accurate_rate_m = accurate_num_m/sum(ValidationSets(1).number);

accurate_num_f = sum(ValidationSets(2).results(:,3));
accurate_rate_f = accurate_num_f/sum(ValidationSets(2).number);

% calculate the accuracy in total
accurate_total = (accurate_num_m+accurate_num_f)/...
    (sum(ValidationSets(1).number)+sum(ValidationSets(2).number));

%% 