function run_transcription(infile, max_f0)

%
% define parameters
%
min_freq = 60;
max_freq = 2200;
num_channels = 100;
lp_f_min = 1000; % lowpass filter freq
fft_size = 8*1024;

outfile = sprintf('%s.transcription.%d', infile, max_f0);

% read audio data from file
[input_waveform_complete, sample_rate] = wavread(infile);


%
% mix down to mono
%
if size(input_waveform_complete,2) == 2 % stereo -> mix down
    input_waveform_complete = input_waveform_complete(:,1) + input_waveform_complete(:,2);
end

frame_duration = 0.092;
frame_length = round(frame_duration * sample_rate);

% normalize and zero padding
input_waveform_complete = input_waveform_complete / max(abs(input_waveform_complete));
input_waveform_complete = [input_waveform_complete' zeros(1, frame_length)];



%
% compute filter coefficients for a bank of Gammatone filters
%
fcoefs = MakeERBFilters(sample_rate, num_channels, min_freq);

%
% main loop
%

offset = 1;
frame_counter = 0;
f_tab = [];
s_tab = [];

while offset + frame_length < length(input_waveform_complete)
       
    disp(sprintf('frame %d of %d', frame_counter, 2*round(length(input_waveform_complete)/frame_length) ));

    input_waveform = input_waveform_complete(offset:round(offset+frame_length));
    frame_counter = frame_counter + 1;
    offset = offset + round(frame_length/2);
    
    U_k = calc_summary_magnitude_spectrum(sample_rate, input_waveform, ...
        min_freq, num_channels, fcoefs, ...
        lp_f_min, ...
        fft_size);

    U_k = [U_k zeros(1, length(U_k))];

    % step 1
    residual_sms = U_k;
    spectrum_detected = zeros(1,length(U_k));

    f0_list = [];
    s_list = [];
    I = max_f0;
        
    while( I > 0)
        % step 2
        [f0,s] = estimate_f0(residual_sms, sample_rate, min_freq, max_freq);
        f0_list = [f0_list f0];
        s_list = [s_list s];
        
        % step 3/4
        subtraction_spec = calc_cancelation_spectrum(f0, residual_sms, sample_rate, min_freq, max_freq);
        spectrum_detected = spectrum_detected + subtraction_spec;

        % step 5
        d = 0.5;
        residual_sms = max(0, U_k - d * spectrum_detected);

        I = I - 1;
    end
    
    f_tab = [f_tab; f0_list];
    s_tab = [s_tab; s_list];        
end

%
% store results
%

disp(sprintf('writing results to %s', outfile));
fd = fopen(outfile,'w');
max_s = max(max(s_tab));
for i=1:size(f_tab,1)
    for j=1:size(f_tab,2)
        n = freq_to_midi_note(f_tab(i,j));
        v = round(100 * s_tab(i,j) /max_s);
        fprintf(fd, 'n%d v%d, ', n, v);
    end
    fprintf(fd, '\n');
end
fclose(fd);

