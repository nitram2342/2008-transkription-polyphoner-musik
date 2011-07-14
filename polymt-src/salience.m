function lambda = salience(tau, sample_rate, U_k, delta_tau)
    
    U_k_new = U_k; %[U_k zeros(1, length(U_k))];
    K = length(U_k_new);
    K_half = K / 2;
        
    my_sum = 0;
        
    p = 1;
    while p <= 20 && p*(K/tau + delta_tau/2) < K_half
    
        k0 = floor(p*K / (tau + delta_tau/2)) + 1;
        k1 = max(round(p*K/(tau - delta_tau/2)), k0);
         
        % debug
        %if tau == 16
        %    [k0 k1]  % k * sample_rate / K
        %end
        
        k = k0:k1; % list of values for k
        
        H_LP = 1 ./ (0.108 * sample_rate * k / K + 24.7);
        
        my_sum = my_sum + max(H_LP .* U_k_new(k));
        
        p = p + 1;
    end
    
    lambda = my_sum * sample_rate / tau;