// Feather disable all

randomLogic = new VinylLogicRandom([sndBleep0, sndBleep1, sndBleep2, sndBleep3]);
shuffleLogic = new VinylLogicShuffle([sndBleep0, sndBleep1, sndBleep2, sndBleep3]);
pitchVariationLogic = new VinylLogicShuffle(sndBleep0, undefined, undefined, 1, 0.2);
historyArray = [];