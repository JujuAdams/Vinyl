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
        
        _soundDef.__Update(_mixGroupIndex, _gain, _otherData);
    }
    else
    {
        __VinylError($"Datatype \"{typeof(_soundAssetOrArray)}\" not supported, must be a sound asset");
    }
}