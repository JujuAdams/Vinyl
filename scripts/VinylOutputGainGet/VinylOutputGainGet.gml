/// Returns the current output gain for a Vinyl playback instance, or a Vinyl label
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID/labelName

function VinylOutputGainGet(_id)
{
    var _outputGain = 0;
    
    var _instance = global.__vinylIdToInstanceDict[? _id];
    if (is_struct(_instance))
    {
        _outputGain = _instance.__outputGain;
    }
    else if (_id == undefined)
    {
        //Do nothing
    }
    else
    {
        var _label = global.__vinylLabelDict[$ _id];
        if (is_struct(_label)) _outputGain = _label.__outputGain;
    }
    
    return _outputGain;
}