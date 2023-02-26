/// Returns the current transposition for a Vinyl playback instance, or a Vinyl label
/// 
/// This function does NOT take into account global transposition
/// 
/// @param vinylID/labelName

function VinylTransposeGet(_id)
{
    static _globalData       = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__transposeSemitones;
    
    var _label = _globalData.__labelDict[$ _id];
    if (is_struct(_label)) return _label.__transposeSemitones;
    
    return 0;
}