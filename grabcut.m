image = imread('image.jpg');
shapeInserter = vision.ShapeInserter;

% Get BG and FG
BGMask = zeros(size(image,1),size(image,2));
FGMask = ones(size(image,1),size(image,2));
[I2 bigRect] = imcrop(image);
space = 30;
smallRect = [bigRect(1)+(space/2) bigRect(2)+(space/2) bigRect(3)-space bigRect(4)-space];
FGImage = imcrop(image,smallRect);
BGImage = imcrop(image,bigRect);

% Split into image and point arrays
xstart = int32(smallRect(1)) - int32(bigRect(1)); 
ystart = int32(smallRect(2)) - int32(bigRect(2)); 
xend = int32(smallRect(3)) + xstart; 
yend = int32(smallRect(4)) + ystart;
s=size(BGImage);

Full_mat = zeros(s(1),s(2),10);

% Setup Fullmat
for i = 1 : 1 : s(1)
    for j = 1 : 1 : s(2)
        idx = (s(2)* (i-1) ) + (j);
        if j >= (xstart) & j < (xend) & i >= (ystart) & i < (yend),
            %disp('FG');
            data = [idx double(BGImage(i,j,1)) double(BGImage(i,j,2)) double(BGImage(i,j,3)) ...
                0 0 0 0 0 1];
            Full_mat(i,j,:) = data;
            
        else
            %disp('BG');
            data = [idx double(BGImage(i,j,1)) double(BGImage(i,j,2)) double(BGImage(i,j,3)) ...
                0 0 0 0 0 2];
            Full_mat(i,j,:) = data;
        end
    end 
end

FG_array = [];
BG_array = [];

for i = 1 : 1 : s(1)
    for j = 1 : 1 : s(2)
        idx = (s(2)* (i-1) ) + (j);
        data = Full_mat(i,j,:);
        if data(10) == 1,
            FG_array = [FG_array; data];
        elseif data(10) == 2,
            BG_array = [BG_array; data];
        end
    end
end

% Fit Gaussian
K=3;
GMModel_FG = fitgmdist(FG_array(:,2:4),K);
GMModel_BG = fitgmdist(BG_array(:,2:4),K);

% Relabel gaussians with datacost and smooth cost
get_mu_matrix = @(GMModel, K) GMModel.mu(K,:);
get_sigma_matrix = @(GMModel, K) GMModel.Sigma(:,:,K);
get_weight = @(GMModel, K) GMModel.PComponents(K);
data_term = @(GMModel,K,Z) -log(get_weight(GMModel,K)) + 0.5*log(det(get_sigma_matrix(GMModel,K))) ...
    + 0.5*(Z - get_mu_matrix(GMModel,K))*(inv(get_sigma_matrix(GMModel,K)))*(Z-get_mu_matrix(GMModel,K))';
cost_term = @(data1,data2) (data1(:,10)-data2(:,10))*exp(-(norm(data1(:,2:4)-data2(:,2:4))));

graph = BK_Create(s(1)*s(2),s(1)*s(2));

DCost = [];
SCost = [];
for i = 1 : 1 : s(1)
    for j = 1 : 1 : s(2)
        idx = (s(2)* (i-1) ) + (j);
        data = Full_mat(i,j,:);
        disp((idx/(s(1)*s(2)))*100);
        
        % Setup datacost
        [validK_FG, dataCost_FG] = dataCost(GMModel_FG,data,K);
        [validK_BG, dataCost_BG] = dataCost(GMModel_BG,data,K);
        DCost = [DCost; dataCost_FG dataCost_BG];
        
        % Setup smooth cost
        if (i+1) <= s(1),
            data_1 = Full_mat(i,j,:); idx1 = (s(2)*i) + j;
            data_2 = Full_mat(i+1,j,:); idx2 = (s(2)*(i+1)) + j;
            SCost = [SCost; idx1 idx2 0 cost_term(data_1,data_2) cost_term(data_2,data_1) 0 ];
        end
        if (j+1) <= s(2),
            data_1 = Full_mat(i,j,:); idx1 = (s(2)*i) + j;
            data_2 = Full_mat(i,j+1,:); idx2 = (s(2)*i) + (j+1);
            SCost = [SCost; idx1 idx2 0 cost_term(data_1,data_2) cost_term(data_2,data_1) 0 ];
        end
        
    end 
end

% Graphcut
BK_SetUnary(graph,DCost');
BK_SetPairwise(graph,SCost);
BK_Minimize(graph);
labels = BK_GetLabeling(graph);

% Relabel
for i = 1 : 1 : s(1)
    for j = 1 : 1 : s(2)
        idx = (s(2)* (i-1) ) + (j);
        label = labels(idx);
        
        Full_mat(i,j,10) = label;
        
        if label == 2,
            BGImage(i,j,1) = 0;
            BGImage(i,j,2) = 0;
            BGImage(i,j,3) = 0;
        end
  
    end
    
end

imshow(BGImage)