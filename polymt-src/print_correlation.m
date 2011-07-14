function print_correlation(values, num_cols, num_rows, col, row, descr)
    
    subplot(num_rows, num_cols, (row-1)*num_cols + col);
    half = round(length(values)/2);
    plot(values(1:300));
    %plot(values);
    axis('auto');
    %xlabel('Frequency (Hz)');
    %ylabel('Mag');
    title(descr);