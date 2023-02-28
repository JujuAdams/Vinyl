/// Returns a BPM pulse for a Vinyl playback instance
/// 
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID/labelName

function VinylBPMPulseGet(_id)
{
    static _idToInstanceDict = __VinylGlobalData().__idToInstanceDict;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__BPMPulseGet();
    
    return false;
}