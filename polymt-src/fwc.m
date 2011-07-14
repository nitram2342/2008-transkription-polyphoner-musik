function compressed_signal = fwc(waveform)
    
    compressed_signal = [];
    v = 0.33;
    
    for i=1:length(waveform)
        if waveform(i) >= 0            
            compressed_signal(i) = waveform(i)^v;
        else
            compressed_signal(i) = -((-waveform(i))^v);
        end
     
    end
