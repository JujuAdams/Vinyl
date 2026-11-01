/// Sets up Vinyl-specific properties for a sound or an array of sounds. This function should be
/// called for all sounds to ensure that they are playing on a valid mix group. You may
/// additionally set a static gain per sound to help balance audio using the optional `gain`
/// parameter. You can also attach additional data to a sound for retrieval using
/// `VinylSoundGetOtherData()`. If an array is provided then this function will set the same values
/// for all sounds in the array.
/// 
/// @param soundAssetOrArray
/// @param mixGroupIndex
/// @param [gain=1]
/// @param [otherData]

function VinylDefineSound(_soundAssetOrArray, _mixGroupIndex, _gain = 1, _otherData = undefined)
{
    static _soundDefMap = __VinylSystem().__soundDefMap;
    
    if (is_array(_soundAssetOrArray))
    {
        var _i = 0;
        repeat(array_length(_soundAssetOrArray))
        {
            VinylDefineSound(_soundAssetOrArray[_i], _mixGroupIndex, _gain, _otherData);
            ++_i;
        }
    }
    else if (is_handle(_soundAssetOrArray) || is_numeric(_soundAssetOrArray))
    {
        if (not audio_exists(_soundAssetOrArray))
        {
            __VinylError($"Sound asset `{_soundAssetOrArray}` does not exist");
        }
        
        var _soundDef = _soundDefMap[? _soundAssetOrArray];
        if (_soundDef == undefined)
        {
            _soundDef = new __VinylClassSoundDef(_soundAssetOrArray);
            _soundDefMap[? _soundAssetOrArray] = _soundDef;
        }
        
        _soundDef.ImplUpdate(_mixGroupIndex, _gain, _otherData);
    }
    else
    {
        __VinylError($"Datatype \"{typeof(_soundAssetOrArray)}\" not supported, must be a sound asset");
    }
}