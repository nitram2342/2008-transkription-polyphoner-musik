function print_gammatone_filters(fcoefs, sample_rate)

    dirack = [1 zeros(1,4096)];
    y = ERBFilterBank(dirack, fcoefs);
    fft_size = length(dirack);
    resp = 20*log10(abs(fft(y', fft_size)));
    freqScale = (0:fft_size -1 )/fft_size * sample_rate;
    %semilogx(freqScale(1:255),resp(1:255,:));
    plot(freqScale(1:floor(fft_size/2)-1),resp(1:floor(fft_size/2) -1, :));
    axis([0 sample_rate/2 -80 0])
    xlabel('Frequency (Hz)');
    ylabel('Filter Response (dB)');
