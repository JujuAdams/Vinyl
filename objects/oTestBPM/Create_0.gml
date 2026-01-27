// Feather disable all

voice = undefined;

var _bpm = 4 * (60 / audio_sound_length(sndSync0));
VinylSetupBPM(sndSync0, _bpm);
VinylSetupBPM(sndSync1, _bpm);
VinylSetupBPM(sndSync2, _bpm);
VinylSetupBPM(sndSync3, _bpm);

VinylSetupShuffle("bpmShuffle", [sndSync0, sndSync1, sndSync2, sndSync3], true);
VinylSetupHLT("bpmHLT", sndSync0, sndSync1, sndSync2);
VinylSetupBlend("bpmBlend", [sndSync0, sndSync1, sndSync2, sndSync3], true);