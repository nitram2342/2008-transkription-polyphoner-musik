function print_spectrum(waveform, sample_rate, fft_size, ...        
        num_cols, num_rows, col, row, descr)
    
    pos = (row-1)*num_cols + col;
    subplot(num_rows, num_cols, pos);
    
    fft_data_complex = fft(waveform, fft_size);     
    fft_data_to_plot = abs(fft_data_complex(1:fft_size/2+1));
    f = sample_rate*(0:fft_size/2)/fft_size;
         
    %stem(f, fft_data_to_plot, 'k', 'filled');
    plot(f, fft_data_to_plot);
    %semilogx(f, fft_data_to_plot);
    %xlim([10 max_display_freq]);
    %axis('auto');
    xlabel('Frequency (Hz)');
    %ylabel('Power (dB)');
    ylabel('Mag');
    title(descr);