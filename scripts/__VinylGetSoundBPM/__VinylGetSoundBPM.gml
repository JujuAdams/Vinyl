// Feather disable all

/// @param sound

function __VinylGetSoundBPM(_sound)
{
    static _soundMap = __VinylSystem().__soundMap;
    
    var _pattern = _soundMap[? int64(_sound)];
    return (_pattern == undefined)? undefined : _pattern.__bpm;
}