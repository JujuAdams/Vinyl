// Feather disable all

function __VinylSoundGetPitch(_sound)
{
    static _soundDict = __VinylSystem().__soundDict;
    return __VinylEnsurePatternSound(_sound).__pitch;
}