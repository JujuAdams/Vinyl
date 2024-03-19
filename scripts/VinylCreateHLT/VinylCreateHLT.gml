// Feather disable all

/// @param soundHead
/// @param soundLoop
/// @param soundTail
/// @param [gainForce=false]
/// @param [gain=1]
/// @param [name]

if (VINYL_LIVE_EDIT) __VinylNetRPCRegister("VinylCreateHLT", VinylCreateHLT);
function VinylCreateHLT(_soundHead, _soundLoop, _soundTail, _gainForce = false, _gain = 1, _name = undefined)
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
            if (_index & __VINYL_RUNTIME_PATTERN_MASK)
            {
                //This is already a runtime pattern, use it!
                var _pattern = struct_get_from_hash(_genPatternData, _index);
                _pattern.__Update(_soundHead, _soundLoop, _soundTail, _gainForce, _gain);
                
                return _index;
            }
        }
    }
    
    __VinylTrace("Creating new head-loop-tail runtime pattern (name=", _name, ")");
    
    //Generate a new index for this pattern
    var _index = int64(_system.__runtimePatternIndex);
    _system.__runtimePatternIndex++;
    
    var _pattern = new __VinylClassPatternHLT(_index, _soundHead, _soundLoop, _soundTail, _gainForce, _gain);
    
    _genNameData[$ _name] = _index;
    struct_set_from_hash(_genPatternData, _index, _pattern);
    struct_set_from_hash(_genPlayData, _index, _pattern.__Play);
    
    return _index;
}