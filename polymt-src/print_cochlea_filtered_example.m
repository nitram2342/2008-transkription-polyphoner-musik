% plot input signal
% please eval the main script before you start this

clf;


[wf,sample_rate] = wavread('cochlea_filtered_at_662.80.wav');

print_spectrum(wf, sample_rate, 2*4096, ...
        1, 1, 1, 1, 'Magnitude spectrum of cochlea filtered signal f_c = 662.80 Hz'); 

saveas(gcf, 'input_signals_magspec_cochlea_filtered.eps',  'eps');



wf = fwc(wf);

print_spectrum(wf, sample_rate, 2*4096, ...
        1, 1, 1, 1, 'Magnitude spectrum of the compressed signal'); 
    
saveas(gcf, 'magspec_fwc.eps',  'eps');


wf = max(wf, 0);

print_spectrum(wf, sample_rate, 2*4096, ...
        1, 1, 1, 1, 'Magnitude spectrum of the half wave rectified signal'); 
    
saveas(gcf, 'magspec_hwr.eps',  'eps');


wf = filter(fir1(32, lp_f_min/nyquist_freq), 1, wf);
print_spectrum(wf, sample_rate, 2*4096, ...
        1, 1, 1, 1, 'Magnitude spectrum of the lowpass filtered signal'); 
    
saveas(gcf, 'magspec_lp.eps',  'eps');
