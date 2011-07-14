function print_spectrum_from_spectrum(fft_data_to_plot, sample_rate, fft_size, ...        
        num_cols, num_rows, col, row, descr)
    
    pos = (row-1)*num_cols + col;
    subplot(num_rows, num_cols, pos);
        
    %f = sample_rate*(0:fft_size/2-1)/fft_size;
    f = (0:fft_size/2-1);
    fft_data_to_plot = fft_data_to_plot(1:floor(length(fft_data_to_plot)/2));
    
    plot(f(1:length(fft_data_to_plot)), fft_data_to_plot);
    xlabel('Frequency (Hz)');
    ylabel('Mag');
    title(descr);