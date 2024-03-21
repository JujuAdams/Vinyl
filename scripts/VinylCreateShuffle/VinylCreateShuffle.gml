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
    
    var _existingIndex = undefined;
    if (_name != undefined)
    {
        _existingIndex = _genNameData[$ _name];
        if (_existingIndex != undefined)
        {
            _existingIndex = int64(_existingIndex);
            if ((_existingIndex & 0xFFFFFFFF_00000000) == __VINYL_RUNTIME_PATTERN_MASK)
            {
                __VinylTrace("Overwriting runtime shuffle pattern (name=", _name, ", index=", string(ptr(_existingIndex)), ")");
                
                var _pattern = struct_get_from_hash(_genPatternData, _existingIndex);
                _pattern.__Update(_soundArray, _gainForce, _gainMin, _gainMax, _pitchForce, _pitchMin, _pitchMax);
                
                return _existingIndex;
            }
        }
    }
    
    //Generate a new index for this pattern
    var _index = int64(_system.__runtimePatternIndex);
    _system.__runtimePatternIndex++;
    
    __VinylTrace("Creating new runtime shuffle pattern (name=", _name, ", index=", string(ptr(_index)), ")");
    
    //Create a new pattern
    var _pattern = new __VinylClassPatternShuffle(_index, _soundArray, _gainForce, _gainMin, _gainMax, _pitchForce, _pitchMin, _pitchMax);
    
    //Store it in all the right places
    _genNameData[$ _name] = _index;
    struct_set_from_hash(_genPatternData, _index, _pattern);
    struct_set_from_hash(_genPlayData, _index, _pattern.__Play);
    
    //If there was an existing compiled pattern then overwrite references
    if (_existingIndex != undefined)
    {
        __VinylTrace("Runtime shuffle pattern (index=", string(ptr(_index)), " overwrites existing compiled pattern (existing index=", string(ptr(_existingIndex)), ")");
        
        struct_set_from_hash(_genPatternData, _existingIndex, _pattern);
        struct_set_from_hash(_genPlayData, _existingIndex, _pattern.__Play);
    }
    
    return _index;
}