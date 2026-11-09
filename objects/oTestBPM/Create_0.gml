// Feather disable all

voice = undefined;

originalBPM = 4 * (60 / audio_sound_length(sndSync0));
bpm = originalBPM;

bpmBrain = undefined;

shuffleBrain = new VinylBrainShuffle([sndSync0, sndSync1, sndSync2, sndSync3]);
hltBrain = new VinylBrainHLT(sndSync0, sndSync1, sndSync2);
soundArray = [sndSync0, sndSync1, sndSync2, sndSync3];