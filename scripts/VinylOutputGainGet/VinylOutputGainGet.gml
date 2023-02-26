/// Returns the current output gain for a Vinyl playback instance, or a Vinyl label
/// 
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID/labelName

function VinylOutputGainGet(_id)
{
    static _globalData = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _outputGain = 0;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance))
    {
        _outputGain = _instance.__GainOutputGet();
    }
    else if (_id == undefined)
    {
        //Do nothing
    }
    else
    {
        var _label = _globalData.__labelDict[$ _id];
        if (is_struct(_label)) _outputGain = _label.__GainOutputGet();
    }
    
    return _outputGain;
}