/// Returns the current pan for a Vinyl playback instance
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID

function VinylPanGet(_id)
{
    var _pan = 0;
    
    var _instance = global.__vinylIdToInstanceDict[? _id];
    if (is_struct(_instance))
    {
        var _panEmitter = _instance.__panEmitter;
        if (is_struct(_panEmitter)) _pan = _panEmitter.__pan;
    }
    else if (_id == undefined)
    {
        //Do nothing
    }
    else
    {    
        var _label = global.__vinylLabelDict[$ _id];
        if (is_struct(_label)) __VinylError("Cannot get or set panning for labels");
    }
    
    return _pan;
}