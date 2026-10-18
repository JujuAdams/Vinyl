/// @param soundAsset

function VinylSoundGetOtherData(_soundAsset)
{
    static _soundDefMap = __VinylSystem().__soundDefMap;
    
    var _soundDef = _soundDefMap[? _soundAsset];
    return (_soundDef == undefined)? undefined : _soundDef.__otherData;
}