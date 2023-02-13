/// Returns the current input pitch for a Vinyl playback instance, or a Vinyl label
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID/labelName

function VinylPitchGet(_id)
{
    static _globalData = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _pitch = 1;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance))
    {
        _pitch = _instance.__pitchInput;
    }
    else if (_id == undefined)
    {
        //Do nothing
    }
    else
    {
        var _label = _globalData.__labelDict[$ _id];
        if (is_struct(_label)) _pitch = _label.__pitchInput;
    }
    
    return _pitch;
}