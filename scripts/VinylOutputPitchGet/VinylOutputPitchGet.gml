/// Returns the current output pitch for a Vinyl playback instance, or a Vinyl label
/// 
/// @param vinylID/labelName

function VinylOutputPitchGet(_id)
{
    static _globalData       = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _outputPitch = 1;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance))
    {
        _outputPitch = _instance.__PitchOutputGet();
    }
    else if (_id == undefined)
    {
        //Do nothing
    }
    else
    {
        var _label = _globalData.__labelDict[$ _id];
        if (is_struct(_label)) _outputPitch = _label.__PitchOutputGet();
    }
    
    return _outputPitch;
}