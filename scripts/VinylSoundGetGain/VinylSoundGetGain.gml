/// @param soundAsset

function VinylSoundGetGain(_soundAsset)
{
    static _soundDefMap = __VinylSystem().__soundDefMap;
    
    var _soundDef = _soundDefMap[? _soundAsset];
    return (_soundDef == undefined)? 1 : _soundDef.__gain;
}