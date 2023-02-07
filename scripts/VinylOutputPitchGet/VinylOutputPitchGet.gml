/// Returns the current output pitch for a Vinyl playback instance, or a Vinyl label
/// 
/// @param vinylID/labelName

function VinylOutputPitchGet(_id)
{
    static _idToInstanceDict = __VinylGlobalData().__idToInstanceDict;
    
    var _outputPitch = 1;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance))
    {
        _outputPitch = _instance.__outputPitch;
    }
    else if (_id == undefined)
    {
        //Do nothing
    }
    else
    {
        var _label = global.__vinylLabelDict[$ _id];
        if (is_struct(_label)) _outputPitch = _label.__outputPitch;
    }
    
    return _outputPitch;
}