//audio_debug(true);
//music = VinylPlay(sndChickenNuggets);

//instance = VinylPlay(snd1KHz, true, 1, 1, 0);

//emitter = VinylEmitterCircle(room_width/2, room_height/2, 100);
emitter = VinylEmitterRectangle(room_width/2-100, room_height/2-100, room_width/2+100, room_height/2+100);

VinylPlayOnEmitter(emitter, snd1KHz, true);