function note_number = freq_to_midi_note(f0)
    note_number = 69 + round(12 * log2(f0 / 440));
    