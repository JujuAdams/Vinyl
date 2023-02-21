/// Sets the panning for a Vinyl playback instance
/// 
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID
/// @param pan

function VinylPanSet(_id, _pan)
{
    static _globalData       = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _instance = _idToInstanceDict[? _id];
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
    
    var _label = _globalData.__labelDict[$ _id];
    if (is_struct(_label)) __VinylError("Cannot get or set panning for labels");
    
    __VinylTrace("Warning! Failed to execute VinylPanSet() for ", _id);
}