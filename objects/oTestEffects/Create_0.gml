reverbEmitter = audio_emitter_create();

reverbBus = audio_bus_create();
reverbBus.effects[0] = audio_effect_create(AudioEffectType.Reverb1, {size: 0.6, damp: 0.5, mix: 1.0});

audio_emitter_bus(reverbEmitter, reverbBus);