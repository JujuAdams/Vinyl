//audio_debug(true);
//music = VinylPlay(sndChickenNuggets);

emitter = VinylEmitterCreate(room_width/2, room_height/2, 10, 200);
//audio_play_sound_on(emitter, sndTestTone, true, 1, 0.2);

panEmitter = audio_emitter_create();
audio_emitter_position(panEmitter, 0, 0, 0);
audio_emitter_falloff(panEmitter, __VINYL_PAN_WIDTH, __VINYL_PAN_WIDTH+1, 1);
audio_play_sound_on(panEmitter, sndTestTone, true, 1, 0.2);