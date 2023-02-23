/// Returns the current input pitch target for a Vinyl playback instance, or a Vinyl label
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID/labelName

function VinylPitchTargetGet(_id)
{
    static _globalData = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _pitchTarget = 1;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance))
    {
        _pitchTarget = _instance.__PitchTargetGet();
    }
    else if (_id == undefined)
    {
        //Do nothing
    }
    else
    {
        var _label = _globalData.__labelDict[$ _id];
        if (is_struct(_label)) _pitchTarget = _label.__PitchTargetGet();
    }
    
    return _pitchTarget;
}