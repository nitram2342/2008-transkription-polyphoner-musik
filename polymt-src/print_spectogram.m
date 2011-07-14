function print_spectogram(waveform, num_cols, num_rows, col, row)
    
    subplot(num_rows, num_cols, (row-1)*num_cols + col);
    plot(abs(fft(waveform)));
    

