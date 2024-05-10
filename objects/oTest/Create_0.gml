hltVoice   = undefined;
blendVoice = undefined;

VinylSetupImportJSON({
    mix: "Test",
    members: [
        {
            shuffle: "Shuffle",
            sounds: [sndBleep0, sndBleep1, sndBleep2, sndBleep3, sndBleep4, sndBleep5,
                     sndBleep6, sndBleep7, sndBleep8, sndBleep9, sndBleep10, sndBleep11,],
        },
        {
            hlt: "HLT",
            head: sndSync0,
            loop: sndSync1,
            tail: sndSync2,
        },
        {
            blend: "Blend",
            sounds: [sndSync0, sndSync1, sndSync2, sndSync3,],
        },
    ]
});

show_debug_message(VinylMacrosExport());