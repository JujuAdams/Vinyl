/// Returns the current pan for a Vinyl playback instance
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID

function VinylPanGet(_id)
{
    static _globalData = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _pan = 0;
    
    var _instance = _idToInstanceDict[? _id];
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
        var _label = _globalData.__labelDict[$ _id];
        if (is_struct(_label)) __VinylError("Cannot get or set panning for labels");
    }
    
    return _pan;
}