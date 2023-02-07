/// Sets the panning for a Vinyl playback instance
/// 
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID
/// @param pan

function VinylPanSet(_id, _pan)
{
    var _instance = global.__vinylIdToInstanceDict[? _id];
    if (is_struct(_instance))
    {
        var _panEmitter = _instance.__panEmitter;
        if (is_struct(_panEmitter))
        {
            _panEmitter.__Pan(_pan);
        }
        else
        {
            __VinylError("Cannot set panning for a Vinyl instance that was not created with a panning value");
        }
    }
    
    if (_id == undefined) return;
    
    var _label = global.__vinylLabelDict[$ _id];
    if (is_struct(_label)) __VinylError("Cannot get or set panning for labels");
}