#!/usr/bin/perl

use MIDI;
use strict;
use POSIX;
use Audio::Wav;
use Data::Dumper;


my $filename = shift || 'transcription.dat';
my $outfile = shift || 'out.wav';

my $vol_threshold = 60; # limit volume for partials
my $delay = 0.093/2;
my $num_notes = 128;
use constant PI => 3.1415926;

my $tab = read_tab($filename, $vol_threshold);
my $sin_osc = create_osc($num_notes);

my @current_ampl;
my @ampl_change_per_step;
my $steps = 50;
my $sample_rate = 8000;
my $max_gain = 100;
my $min_note = 10;
my $wav = new Audio::Wav;
my $write = $wav -> write( $outfile, { 'bits_sample'   => 16,
				       'sample_rate'   => $sample_rate,
				       'channels'      => 1});


foreach my $line (@{$tab}) {
    
    my @array;
    my $vol_sum = 0;

    for(my $i = 0; $i < 128; $i++) {
	$line->{$i} = 0 if(not exists $line->{$i});
	$ampl_change_per_step[$i] = ($line->{$i} - $current_ampl[$i]) / $steps;
    }
    
    for(my $s = 0; $s < $steps; $s++) {
	for(my $i = 0; $i < 128; $i++) {
	    $current_ampl[$i] += $ampl_change_per_step[$i];
	    $sin_osc->[$i]->{ampl} = $current_ampl[$i];
	}

	my $buf = gen_waveform($sin_osc, $num_notes, $delay/$steps, $sample_rate, $min_note);
	foreach my $b (@$buf) {
	    $write->write( $max_gain * $b );
	}

    }
}

$write -> finish();

sub gen_waveform {
    my $osc_list = shift;
    my $num_notes = shift;
    my $duration = shift;
    my $sample_rate = shift;
    my $min_note = shift;

    my @buf;

    for(my $i = $min_note; $i < $num_notes; $i++) {

	for(my $o = 0; $o < ceil($duration * $sample_rate); $o++) {
	    $buf[$o] += $osc_list->[$i]->{ampl} * 
		sin(2.0 * PI * $osc_list->[$i]->{freq} * ($osc_list->[$i]->{x} + $o)/$sample_rate);
	}
	$osc_list->[$i]->{x} += ceil($duration * $sample_rate);

    }

    return \@buf;
}


sub create_osc {
    my $nr = shift;

    my @osc;
    for(my $i=0; $i<$nr; $i++) {
	push @osc, { freq => midi_note_to_freq($i),
		     x => 0,
		     ampl => 0};
    }

    return \@osc;
}

sub midi_note_to_freq {
    my $midi_note = shift;
    return pow(2, ($midi_note - 69) / 12.0) * 440;
}

sub read_tab {
    my $filename = shift;
    my $vol_threshold = shift;

    open(FILE, "< $filename") or die "can't open $filename: $!\n";

    my @tab;
    my $max_vol = 0;

    while(defined(my $line = <FILE>)) {
	chomp $line;
	
	my %time_slot;
	
	foreach my $note (split(/,\s/, $line)) {
	    $note =~ s![nv]!!g;
	    
	    my @params = split(/\s/, $note);
	    my $note = $params[0];
	    my $vol  = $params[1];
	    
	    if(not exists $time_slot{$note}) {
		$time_slot{$note} = $vol > 1 ? $vol : 0;
	    }
	    else {
		$time_slot{$note} += $vol > $time_slot{$note} ? $vol :
		    $time_slot{$note};
		
		if($time_slot{$note} > $vol_threshold) {
		    $time_slot{$note} = $vol_threshold;
		}
	    }
	    
	}
	
	push @tab, \%time_slot;
    }



    return \@tab;
}
