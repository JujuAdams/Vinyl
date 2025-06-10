// Feather disable all

/// @param [loop]
/// @param [gain=1]
/// @param [pitch=1]
/// @param [duckerName]
/// @param [duckPriority]
/// @param [mixName]

function VinylAbstract(_loopLocal, _gainLocal = 1, _pitchLocal = 1, _duckerNameLocal = undefined, _duckPrioLocal = undefined, _mixName = undefined)
{
    static _mixDict    = __VinylSystem().__mixDict;
    static _duckerDict = __VinylSystem().__duckerDict;
    
    static _count = 0;
    var _voice = 0xFF00_0000_0000 | _count;
    ++_count;
    
    if (_mixName == undefined)
    {
        var _mixStruct       = undefined;
        var _gainMix         = 1;
        var _pitchMix        = 1;
        var _loopFinal       = _loopLocal ?? false;
        var _duckerNameFinal = _duckerNameLocal;
    }
    else
    {
        var _mixStruct = _mixDict[$ _mixName];
        if (_mixStruct == undefined)
        {
            __VinylError("Mix \"", _mixName, "\" not recognised");
            return;
        }
        
        var _gainMix         = _mixStruct.__gainFinal;
        var _pitchMix        = _mixStruct.__pitchLocal;
        var _loopFinal       = _loopLocal ?? (_mixStruct.__membersLoop ?? false);
        var _duckerNameFinal = _duckerNameLocal ?? _mixStruct.__membersDuckOn;
    }
    
    if (_duckerNameFinal != undefined)
    {
        var _duckerStruct = _duckerDict[$ _duckerNameFinal];
        if (_duckerStruct == undefined)
        {
            __VinylError("Ducker \"", _duckerNameFinal, "\" not recognised");
            return;
        }
            
        var _duckPrioFinal = _duckPrioLocal ?? 0;
        var _gainDuck = (_duckerStruct.__maxPriority <= _duckPrioFinal)? 1 : _duckerStruct.__duckedGain;
    }
    else
    {
        var _duckerStruct = undefined;
        var _gainDuck     = 1;
    }
    
    var _voiceStruct = new __VinylClassVoiceAbstract(_voice, _loopFinal, _gainLocal, _gainMix, _gainDuck, _pitchLocal, _pitchMix);
    
    if (_duckerStruct != undefined) _duckerStruct.__Push(_voiceStruct, _duckPrioFinal, false);
    if (_mixStruct != undefined) _mixStruct.__Add(_voice);
    
    return _voice;
}