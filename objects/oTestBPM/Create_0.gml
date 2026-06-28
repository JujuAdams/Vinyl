// Feather disable all

voice = undefined;

originalBPM = 4 * (60 / audio_sound_length(sndSync0));
VinylSetupBPM(sndSync0, originalBPM);
VinylSetupBPM(sndSync1, originalBPM);
VinylSetupBPM(sndSync2, originalBPM);
VinylSetupBPM(sndSync3, originalBPM);

bpm = originalBPM;

VinylSetupShuffle("bpmShuffle", [sndSync0, sndSync1, sndSync2, sndSync3], 1, 1, undefined, VINYL_DEFAULT_MIX, undefined, undefined, undefined, originalBPM);
VinylSetupHLT("bpmHLT", sndSync0, sndSync1, sndSync2, 1, VINYL_DEFAULT_MIX, undefined, undefined, undefined, originalBPM);
VinylSetupBlend("bpmBlend", [sndSync0, sndSync1, sndSync2, sndSync3], true, 1, undefined, VINYL_DEFAULT_MIX, undefined, undefined, undefined, originalBPM);