/// Returns the current input gain target for a Vinyl playback instance, or a Vinyl label
/// 
/// @param vinylID/labelName

function VinylGainTargetGet(_id)
{
    var _gainTarget = 0;
    
    var _instance = global.__vinylIdToInstanceDict[? _id];
    if (is_struct(_instance))
    {
        _gainTarget = _instance.__gainTarget;
    }
    else if (_id == undefined)
    {
        //Do nothing
    }
    else
    {
        var _label = global.__vinylLabelDict[$ _id];
        if (is_struct(_label)) _gainTarget = _label.__gainTarget;
    }
    
    return _gainTarget;
}