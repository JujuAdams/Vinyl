#macro MIX_SFX    0
#macro MIX_MUSIC  1

if (VinylRequestInitialize())
{
    VinylDefineMixGroup(MIX_SFX, "sfx", false);
    VinylDefineMixGroup(MIX_MUSIC, "music", true);
    
    VinylDefineSound(sndChickenNuggets, MIX_MUSIC);
    VinylDefineSound([sndCat, sndBonk], MIX_SFX);
}

//VinylSetupImportJSON([
//    {
//        ducker: "ducker test",
//    },
//    {
//        mix: "Test",
//        members: [
//            {
//                sound: VinylFallbackSoundIDE,
//                emitter: "echo",
//            },
//            {
//                sound: sndBleep0,
//            },
//            {
//                sound: sndBleep1,
//            },
//            {
//                shuffle: "Shuffle",
//                gain: [0.9, 1.1],
//                pitch: [0.8, 1.2],
//                sounds: "sndBleep*",
//                //sounds: [sndBleep0, sndBleep1, sndBleep2, sndBleep3, sndBleep4, sndBleep5,
//                //         sndBleep6, sndBleep7, sndBleep8, sndBleep9, sndBleep10, sndBleep11,],
//            },
//            {
//                hlt: "HLT",
//                head: sndSync0,
//                loop: sndSync1,
//                tail: sndSync2,
//            },
//            {
//                blend: "Blend",
//                loop: true,
//                animCurve: acTest,
//                sounds: [sndSync0, sndSync1, sndSync2, sndSync3,],
//            },
//        ],
//    },
//    {
//        mix: "Ducking Mix",
//        membersDuckOn: "ducker test",
//        members: [
//            {
//                sound: sndSync0,
//                duckPrio: 0,
//            },
//            {
//                sound: sndSync1,
//                duckPrio: 1,
//            },
//            {
//                sound: sndSync2,
//                duckPrio: 2,
//            },
//            {
//                sound: sndSync3,
//                duckPrio: 3,
//            },
//            {
//                sound: sndDuckerBleep,
//                duckPrio: 0,
//            },
//            {
//                sound: sndDucker1KHz,
//                duckPrio: 0,
//            },
//        ],
//    },
//]);

//emitter = audio_emitter_create();
//audioBus = audio_bus_create();
//audio_emitter_bus(emitter, audioBus);
//audioBus.effects[0] = audio_effect_create(AudioEffectType.Delay);
//audioBus.effects[1] = audio_effect_create(AudioEffectType.Reverb1, {size: 0.6, damp: 0.5, mix: 1.0});
//VinylRegisterEmitter(emitter, "echo");