/// Resets the transposition of a Vinyl playback instance, or Vinyl label
/// 
/// If this function is given a label name then all currently playing audio assigned with that
/// label will be immediately affected by the change in transposition
///
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID/labelName

function VinylTransposeReset(_id)
{
    static _globalData = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__TransposeReset();
    
    var _label = _globalData.__labelDict[$ _id];
    if (is_struct(_label)) return _label.__TransposeReset();
    
    __VinylTrace("Warning! Failed to execute VinylTransposeReset() for ", _id);
}