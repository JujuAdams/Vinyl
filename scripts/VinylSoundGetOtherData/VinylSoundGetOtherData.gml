/// @param sound

function VinylSoundGetOtherData(_sound)
{
    static _soundDefMap = __VinylSystem().__soundDefMap;
    
    var _soundDef = _soundDefMap[? _sound];
    return (_soundDef == undefined)? undefined : _soundDef.__otherData;
}