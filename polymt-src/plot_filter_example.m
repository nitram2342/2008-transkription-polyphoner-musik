% plot a filter example

path(path,'../auditory_toolbox');
clf;

num_channels = 5;
min_freq = 60;
samples_rate = 8000;

fcoefs = MakeERBFilters(sample_rate, num_channels, min_freq);
print_gammatone_filters(fcoefs, sample_rate);

% save data from current figure handle
saveas(gcf, 'auditory_filter_example.eps',  'eps');