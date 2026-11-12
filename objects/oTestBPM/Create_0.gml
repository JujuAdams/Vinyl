// Feather disable all

voice = undefined;

originalBPM = 4 * (60 / audio_sound_length(sndSync0));
bpm = originalBPM;

bpmLogic = undefined;

shuffleLogic = new VinylLogicShuffle([sndSync0, sndSync1, sndSync2, sndSync3]);
hltLogic = new VinylLogicHLT(sndSync0, sndSync1, sndSync2);
soundArray = [sndSync0, sndSync1, sndSync2, sndSync3];