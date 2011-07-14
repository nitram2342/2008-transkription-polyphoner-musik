% plot input signal
% please eval the main script before you start this

clf;

print_spectrum(input_waveform, sample_rate, 8*1024, ...
        1, 1, 1, 1, 'Magnitude spectrum'); 

saveas(gcf, 'input_signals_magspec.eps',  'eps');
