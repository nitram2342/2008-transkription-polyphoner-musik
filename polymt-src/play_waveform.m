function play_tone(sample_rate, waveform)
    
        if max(waveform) > 1 || min(waveform) < -1
            warning('There are sound samples that are out of range. Normalizing samples ...');
            waveform = waveform * (1/max(waveform));
        end
        sound(waveform, sample_rate);

    