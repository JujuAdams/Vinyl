// Feather disable all

/// @param soundArray
/// @param [gainForce=false]
/// @param [gain=1]
/// @param [name]

if (VINYL_LIVE_EDIT) __VinylNetRPCRegister("VinylCreateBlend", VinylCreateBlend);
function VinylCreateBlend(_soundArray, _gainForce = false, _gain = 1, _name = undefined)
{
    static _system         = __VinylSystem();
    static _genPlayData    = __VinylGenPlay();
    static _genPatternData = __VinylGenPattern();
    static _genNameData    = __VinylGenPatternNames();
    
    if (_name != undefined)
    {
        var _index = _genNameData[$ _name];
        if (_index != undefined)
        {
            _index = int64(_index);
            
            __VinylTrace("Overwriting Blend pattern (name=", _name, ", index=", string(ptr(_index)), ")");
            
            var _pattern = struct_get_from_hash(_genPatternData, _index);
            _pattern.__Update(_soundArray, _gainForce, _gain);
            
            return _index;
        }
    }
    
    //Generate a new index for this pattern
    var _index = int64(_system.__runtimePatternIndex);
    _system.__runtimePatternIndex++;
    
    __VinylTrace("Creating new runtime Blend pattern (name=", _name, ", index=", string(ptr(_index)), ")");
    
    var _pattern = new __VinylClassPatternBlend(_index, _soundArray, _gainForce, _gain);
    
    _genNameData[$ _name] = _index;
    struct_set_from_hash(_genPatternData, _index, _pattern);
    struct_set_from_hash(_genPlayData, _index, _pattern.__Play);
    
    return _index;
}