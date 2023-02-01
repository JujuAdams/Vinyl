/// Returns the current input gain for a Vinyl playback instance, or a Vinyl label
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID/labelName

function VinylGainGet(_id)
{
    var _gain = 0;
    
    var _instance = global.__vinylIdToInstanceDict[? _id];
    if (is_struct(_instance))
    {
        _gain = _instance.__inputGain;
    }
    else if (_id == undefined)
    {
        //Do nothing
    }
    else
    {    
        var _label = global.__vinylLabelDict[$ _id];
        if (is_struct(_label)) _gain = _label.__inputGain;
    }
    
    return _gain;
}