/// @param soundOrArray
/// @param mixGroupIndex
/// @param [gain=1]
/// @param [otherData]

function VinylDefineSound(_soundOrArray, _mixGroupIndex, _gain = 1, _otherData = undefined)
{
    static _soundDefMap = __VinylSystem().__soundDefMap;
    
    if (is_array(_soundOrArray))
    {
        var _i = 0;
        repeat(array_length(_soundOrArray))
        {
            VinylDefineSound(_soundOrArray[_i], _mixGroupIndex, _gain, _otherData);
            ++_i;
        }
        
        return;
    }
    
    var _soundDef = _soundDefMap[? _soundOrArray];
    if (_soundDef == undefined)
    {
        _soundDef = new __VinylClassSoundDef(_soundOrArray);
        _soundDefMap[? _soundOrArray] = _soundDef;
    }
    
    _soundDef.__Update(_mixGroupIndex, _gain, _otherData);
}