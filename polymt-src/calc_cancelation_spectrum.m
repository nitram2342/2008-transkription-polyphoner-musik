function subtraction_spec = calc_cancelation_spectrum(f0, residual_sms, sample_rate, min_freq, max_freq)
    
    K = length(residual_sms);
    K_half = K/2;
        
    subtraction_spec = zeros(1, length(residual_sms));
    
    tau = sample_rate / f0;
    delta_tau = 1;
    
    p = 1;
    while p <= 20 && p*(K/tau + delta_tau/2) < K_half    
        
        k0 = floor(p*K / (tau + delta_tau/2)) + 1;
        k1 = max(round(p*K/(tau - delta_tau/2)), k0);
        k = k0:k1; % list of values for k        
    
        weighting = (sample_rate/tau) ./ (0.108 * sample_rate * k / K + 24.7);        
        subtraction_spec(k) =  weighting * residual_sms(k1 - k0 + 1);
        
        p = p + 1;
    end    

    