function [validK, dataCost] = dataCost(GMModel, data, K)

    get_mu_matrix = @(GMModel, K) GMModel.mu(K,:);
    get_sigma_matrix = @(GMModel, K) GMModel.Sigma(:,:,K);
    get_weight = @(GMModel, K) GMModel.PComponents(K);
    data_term = @(GMModel,K,Z) -log(get_weight(GMModel,K)) + 0.5*log(det(get_sigma_matrix(GMModel,K))) ...
        + 0.5*(Z - get_mu_matrix(GMModel,K))*(inv(get_sigma_matrix(GMModel,K)))*(Z-get_mu_matrix(GMModel,K))';

    color = data(2:6);
    color = [color(1) color(2) color(3)];
    validK = 0; dataCost = 1000000;
    
    cost = [];
    
    for k=1:K,
        value = data_term(GMModel, k, color);
        cost = [cost; value];
        if value < dataCost,
            dataCost = value;
            validK = k;
        end
    end
    
    % IMPROVEMENT
    dataCost = dataCost*(std(cost));

end