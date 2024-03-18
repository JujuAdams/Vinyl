// Feather disable all

/// @param soundArray
/// @param gainForce
/// @param gainMin
/// @param gainMax
/// @param pitchForce
/// @param pitchMin
/// @param pitchMax
/// @param [name]

if (VINYL_LIVE_EDIT) __VinylNetRPCRegister("VinylCreateShuffle", VinylCreateShuffle);
function VinylCreateShuffle(_soundArray, _gainForce, _gainMin, _gainMax, _pitchForce, _pitchMin, _pitchMax, _name = undefined)
{
    static _system         = __VinylSystem();
    static _genPlayData    = __VinylGenPlay();
    static _genPatternData = __VinylGenPattern();
    static _genNameData    = __VinylGenPatternNames();
    
    if (_name != undefined)
    {
        var _index = int64(_genNameData[$ _name]);
        if (_index & __VINYL_RUNTIME_PATTERN_MASK)
        {
            //This is already a runtime pattern, use it!
            var _pattern = struct_get_from_hash(_genPatternData, _index);
            _pattern.__Update(_soundArray, _gainForce, _gainMin, _gainMax, _pitchForce, _pitchMin, _pitchMax);
            
            return _index;
        }
    }
    
    //Generate a new index for this pattern
    var _index = int64(_system.__runtimePatternIndex);
    _system.__runtimePatternIndex++;
    
    var _pattern = new __VinylClassPatternShuffle(_index, _soundArray, _gainForce, _gainMin, _gainMax, _pitchForce, _pitchMin, _pitchMax);
    struct_set_from_hash(_genPatternData, _index, _pattern);
    struct_set_from_hash(_genPlayData, _index, _pattern.__Play);
    
    return _index;
}