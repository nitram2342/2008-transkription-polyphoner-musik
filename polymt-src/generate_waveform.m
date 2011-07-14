function snd = generate_waveform(sample_rate, duration, partials, amplitudes)

    % create empty sound vector
    num_samples = round(sample_rate * duration);
    snd = zeros(1, num_samples);
    
    for i = 1 : length(partials)
       freq = partials(i);
       
       if freq > 0
           ampl = amplitudes(i);
           snd_new = ampl * cos(2 * pi * freq/sample_rate  * (0 : num_samples - 1));       
           snd = snd + snd_new;
       end
    end
    
    % In case we want sth. like fade in/out
    %snd = snd .* hamming(length(snd))';

    % normalize
    m = max(abs(min(snd)), max(snd));
    m = m * 1.001; % to prevent clipping
    snd = snd / m;