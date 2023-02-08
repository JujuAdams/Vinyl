//audio_debug(true);
//music = VinylPlay(sndChickenNuggets);
//instance = VinylPlay(snd1KHz, true, 1, 1, 0);

emitter = audio_emitter_create();
emitter_bus = audio_bus_create();
audio_emitter_bus(emitter, emitter_bus);

var _ef_reverb = audio_effect_create(AudioEffectType.Reverb1);
_ef_reverb.size = 0.6;
_ef_reverb.mix = 0.5;

emitter_bus.effects[0] = _ef_reverb;