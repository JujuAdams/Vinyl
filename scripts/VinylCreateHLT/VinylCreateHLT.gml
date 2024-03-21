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
    
    //Fix GameMaker's stupid fucking JSON decoding
    //This is fixed in newer GameMaker versions but jeez was this a dumb decision that lasted far too long
    if (_soundHead == pointer_null) _soundHead = undefined;
    if (_soundLoop == pointer_null) _soundLoop = undefined;
    if (_soundTail == pointer_null) _soundTail = undefined;
    
    if (_name != undefined)
    {
        var _index = _genNameData[$ _name];
        if (_index != undefined)
        {
            _index = int64(_index);
            
            __VinylTrace("Overwriting HLT pattern (name=", _name, ", index=", string(ptr(_index)), ")");
            
            var _pattern = struct_get_from_hash(_genPatternData, _index);
            _pattern.__Update(_soundHead, _soundLoop, _soundTail, _gainForce, _gain);
            
            return _index;
        }
    }
    
    //Generate a new index for this pattern
    var _index = int64(_system.__runtimePatternIndex);
    _system.__runtimePatternIndex++;
    
    __VinylTrace("Creating new runtime HLT pattern (name=", _name, ", index=", string(ptr(_index)), ")");
    
    var _pattern = new __VinylClassPatternHLT(_index, _soundHead, _soundLoop, _soundTail, _gainForce, _gain);
    
    _genNameData[$ _name] = _index;
    struct_set_from_hash(_genPatternData, _index, _pattern);
    struct_set_from_hash(_genPlayData, _index, _pattern.__Play);
    
    return _index;
}