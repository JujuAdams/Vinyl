// Feather disable all

function __VinylSoundGetGain(_sound)
{
    static _soundDict = __VinylSystem().__soundDict;
    return __VinylEnsurePatternSound(_sound).__gain;
}