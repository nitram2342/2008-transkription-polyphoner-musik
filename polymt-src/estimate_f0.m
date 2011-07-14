function [f0, s] = estimate_f0(spectrum, sample_rate, min_freq, max_freq)

    min_tau = 1;
    max_tau = sample_rate/min_freq;
    delta_tau = 1;
    lambda1 = [];
                                                                                                                                                                                       
    for tau = min_tau:delta_tau:max_tau
        s = salience(tau, sample_rate, spectrum, delta_tau);
        s = (1 - 0.04 * log(sample_rate/tau)) * s;
        lambda1 = [lambda1 s];
    end

    %lambda1;
    %clf;
    %plot(lambda1);
    
    f0 = sample_rate / (argmax(lambda1));
    s = max(lambda1);