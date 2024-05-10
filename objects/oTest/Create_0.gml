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
            shuffle: "HLT",
            sounds: [sndSync0, sndSync1, sndSync2,],
        },
        {
            shuffle: "Blend",
            sounds: [sndSync0, sndSync1, sndSync2, sndSync3,],
        },
    ]
});

show_debug_message(VinylMacrosExport());