/// Returns the total number of beats played for a Vinyl playback instance
/// 
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID/labelName

function VinylBeatCountGet(_id)
{
    static _idToInstanceDict = __VinylGlobalData().__idToInstanceDict;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__BPMBeatCountGet();
    
    return 0;
}