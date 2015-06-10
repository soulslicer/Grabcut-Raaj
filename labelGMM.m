function data = labelGMM(GMModel, data, K, assign_index)

    get_mu_matrix = @(GMModel, K) GMModel.mu(K,:);
    get_sigma_matrix = @(GMModel, K) GMModel.Sigma(:,:,K);
    get_weight = @(GMModel, K) GMModel.PComponents(K);
    data_term = @(GMModel,K,Z) -log(get_weight(GMModel,K)) + 0.5*log(det(get_sigma_matrix(GMModel,K))) ...
        + 0.5*(Z - get_mu_matrix(GMModel,K))*(inv(get_sigma_matrix(GMModel,K)))*(Z-get_mu_matrix(GMModel,K))';

    color = data(2:4);
    color = [color(1) color(2) color(3)];
    validK = 0; data_term_value = 1000000;
    for k=1:K,
        value = data_term(GMModel, k, color);
        if value < data_term_value,
            data_term_value = value;
            validK = k;
        end
    end
    data(assign_index) = validK;
    data(assign_index + 1) = data_term_value;


end

% function Array = labelGMM(GMModel, Array, K, assign_index)
% 
%     get_mu_matrix = @(GMModel, K) GMModel.mu(K,:);
%     get_sigma_matrix = @(GMModel, K) GMModel.Sigma(:,:,K);
%     get_weight = @(GMModel, K) GMModel.PComponents(K);
%     data_term = @(GMModel,K,Z) -log(get_weight(GMModel,K)) + 0.5*log(det(get_sigma_matrix(GMModel,K))) ...
%         + 0.5*(Z - get_mu_matrix(GMModel,K))*(inv(get_sigma_matrix(GMModel,K)))*(Z-get_mu_matrix(GMModel,K))';
% 
%     for i=1:size(Array,1),
%         disp((i/size(Array,1))*100);
%         color = Array(i,2:4); 
%         validK = 0; data_term_value = 1000000;
%         for k=1:K,
%             value = data_term(GMModel, k, color);
%             if value < data_term_value,
%                 data_term_value = value;
%                 validK = k;
%             end
%         end
%         Array(i,assign_index) = validK;
%         Array(i,assign_index+1) = data_term_value;
%     end
% end