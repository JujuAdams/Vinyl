/// Returns the current input pitch for a Vinyl playback instance, or a Vinyl label
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID/labelName

function VinylPitchGet(_id)
{
    var _pitch = 1;
    
    var _instance = global.__vinylIdToInstanceDict[? _id];
    if (is_struct(_instance))
    {
        _pitch = _instance.__inputPitch;
    }
    else if (_id == undefined)
    {
        //Do nothing
    }
    else
    {
        var _label = global.__vinylLabelDict[$ _id];
        if (is_struct(_label)) _pitch = _label.__inputPitch;
    }
    
    return _pitch;
}