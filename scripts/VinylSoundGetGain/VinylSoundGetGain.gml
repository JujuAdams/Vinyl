/// @param sound

function VinylSoundGetGain(_sound)
{
    static _soundDefMap = __VinylSystem().__soundDefMap;
    
    var _soundDef = _soundDefMap[? _sound];
    return (_soundDef == undefined)? 1 : _soundDef.__gain;
}