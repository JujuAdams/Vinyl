/// Returns a BPM pulse for a Vinyl playback instance
/// 
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID/labelName

function VinylBPMPulseGet(_id)
{
    static _idToVoiceDict = __VinylGlobalData().__idToVoiceDict;
    
    var _instance = _idToVoiceDict[? _id];
    if (is_struct(_instance)) return _instance.__BPMPulseGet();
    
    return false;
}