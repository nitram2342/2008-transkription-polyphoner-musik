clear;

filename = 'pianoA1.wav';
%filename = '23541loofaTHAIGONG3.wav';
samples_dir = '../samples';

% read a .wav file
[wav_data, sample_freq, bits_per_sample] = wavread(sprintf('%s/%s', samples_dir, filename));
nyquist_freq = sample_freq / 2;

if size(wav_data,2) == 2 % stereo -> mix down
    wav_data = wav_data(:,1) + wav_data(:,2);
end

%normalize
m = max(abs(min(wav_data)), max(wav_data));

wav_data = wav_data / m;


% plot wave form
subplot(2,1,1);
t = (0:1:length(wav_data)-1)' / sample_freq;
plot(t, wav_data, '-k', 'LineWidth', 1);
title(sprintf('Waveform of sample %s', filename));
xlabel('Time (s)');
ylabel('Amplitude');
axis('auto');

% plot spectrogram
fft_size=1024*4;
max_display_freq = 4200; % sample_freq/2;
max_display_idx = round(max_display_freq * fft_size / sample_freq);
f = (0:max_display_idx-1) * (sample_freq/fft_size);

% fft
subplot(2,1,2);
fft_data_complex = fft(wav_data, fft_size);
fft_data_to_plot = abs(fft_data_complex);
fft_data_to_plot = fft_data_to_plot(1:max_display_idx);

fft_data_to_plot = 20 * log10(fft_data_to_plot);

fft_data_to_plot = fft_data_to_plot - max(fft_data_to_plot);

%stem(f, fft_data_to_plot, 'k', 'filled');
plot(f, fft_data_to_plot, 'k');
ylim([-70 0]);

title(sprintf('Spectrum of sample %s (FFT-Size %d)', filename, fft_size));
xlabel('Frequenzy (Hz)');
ylabel('Magnitude (dB)');

% save data from current figure handle
filetype = 'eps';
saveas(gcf, sprintf('%s/%s.%s', samples_dir, filename, filetype),  filetype);

% play audio
player = audioplayer(wav_data, sample_freq);
play(player);

