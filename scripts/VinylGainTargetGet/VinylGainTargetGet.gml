/// Returns the current input gain target for a Vinyl playback instance, or a Vinyl label
/// 
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID/labelName

function VinylGainTargetGet(_id)
{
    static _globalData = __VinylGlobalData();
    static _idToVoiceDict = _globalData.__idToVoiceDict;
    
    var _gainTarget = 0;
    
    var _instance = _idToVoiceDict[? _id];
    if (is_struct(_instance))
    {
        _gainTarget = _instance.__GainTargetGet();
    }
    else if (_id == undefined)
    {
        //Do nothing
    }
    else
    {
        var _label = _globalData.__labelDict[$ _id];
        if (is_struct(_label)) _gainTarget = _label.__GainTargetGet();
    }
    
    return _gainTarget;
}