function U_k = calc_summary_magnitude_spectrum(sample_rate, waveform_frame, ...
    min_freq, num_channels, fcoefs, ...
    lp_f_min, ...    
    fft_size)

    nyquist_freq = sample_rate / 2;

    % filter the waveform and store multiple waveform outputs within a matrix
    coch = ERBFilterBank(waveform_frame, fcoefs);
    erb_center_freqs = ERBSpace(min_freq, nyquist_freq, num_channels);

    U_k = zeros(1, fft_size/2);
    
    cochlea_sum = zeros(1, fft_size/2);

    for j=1:size(coch,1)
      
      col = 1;
      c = coch(size(coch,1)-j+1,:);
      coch_spec = abs(fft(c, fft_size));
      cochlea_sum = cochlea_sum + coch_spec(1:fft_size/2);
      fc = erb_center_freqs(length(erb_center_freqs)-j+1);
      
      %disp(sprintf('calculating waveform for auditory channel %d with f_c = %.2f Hz', j, fc));
      %wavwrite(c, sample_rate, sprintf('cochlea_filtered_at_%5.2f.wav', fc));
            
      % compress waveform
      c = fwc(c);
      
      % half-wave-rectification
      c = max(c, 0);
      
      % lowpass filter data from c
      c = filter(fir1(32, lp_f_min/nyquist_freq), 1, c);
        
      % sum up magnitude spectra
      c2 = [c zeros(1, length(c))];
      U_c_k = abs(fft(c2, fft_size));
      U_k = U_k + U_c_k(1:length(U_k));
  end

