/// Returns the total number of beats played for a Vinyl playback instance
/// 
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID/labelName

function VinylBeatCountGet(_id)
{
    static _idToVoiceDict = __VinylGlobalData().__idToVoiceDict;
    
    var _voice = _idToVoiceDict[? _id];
    if (is_struct(_voice)) return _instance.__BPMBeatCountGet();
    
    return 0;
}