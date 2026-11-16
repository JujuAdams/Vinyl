// Feather disable all

randomLogic = new VinylPlayableRandom([sndBleep0, sndBleep1, sndBleep2, sndBleep3]);
shuffleLogic = new VinylPlayableShuffle([sndBleep0, sndBleep1, sndBleep2, sndBleep3]);
pitchVariationLogic = new VinylPlayableShuffle(sndBleep0, undefined, undefined, 1, 0.2);
historyArray = [];