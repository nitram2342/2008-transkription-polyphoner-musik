path(path,'../auditory_toolbox');
figure(gcf);
clf(gcf);
clc;

max_f0 = 10;

run_transcription('../samples/christian_morgenstern_outro_eins.wav', max_f0);
run_transcription('../samples/santana_samba_pa_ti.wav', max_f0);
run_transcription('../samples/metrovavan_astronomical_twilight.wav', max_f0);
run_transcription('../samples/bach_air.wav', max_f0);
run_transcription('../samples/tiersen_track4.wav', max_f0);
run_transcription('../samples/apocalyptica_nothing_else_matters.wav', max_f0);
run_transcription('../samples/balanescu_quartett_autobahn.wav', max_f0);
run_transcription('../samples/balanescu_quartett_model.wav', max_f0);
run_transcription('../samples/boc_kaini_industries.wav', max_f0);
