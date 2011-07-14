function print_waveform(waveform, max_display_sample, num_cols, num_rows, col, row, descr)
    
    wf_len = length(waveform);    
    if wf_len > max_display_sample
        wf_len = max_display_sample;
    end
    subplot(num_rows, num_cols, (row-1)*num_cols + col);
    plot(waveform(1:wf_len));
    %axis([0 wf_len -1 1]);
    %xlabel('Sample');
    %ylabel('Amplitude');
    title(descr);