/// Returns the current input pitch target for a Vinyl playback instance, or a Vinyl label
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID/labelName

function VinylPitchTargetGet(_id)
{
    var _pitchTarget = 1;
    
    var _instance = global.__vinylIdToInstanceDict[? _id];
    if (is_struct(_instance))
    {
        _pitchTarget = _instance.__pitchTarget;
    }
    else if (_id == undefined)
    {
        //Do nothing
    }
    else
    {
        var _label = global.__vinylLabelDict[$ _id];
        if (is_struct(_label)) _pitchTarget = _label.__pitchTarget;
    }
    
    return _pitchTarget;
}