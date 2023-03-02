/// Instantly stops a playback instance, or all instances assigned to the given label
/// 
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID/labelName

function VinylStop(_id)
{
    static _globalData = __VinylGlobalData();
    static _idToVoiceDict = _globalData.__idToVoiceDict;
    
    var _voice = _idToVoiceDict[? _id];
    if (is_struct(_voice)) return _instance.__Stop();
    
    var _label = _globalData.__labelDict[$ _id];
    if (is_struct(_label)) return _label.__Stop();
    
    __VinylTrace("Warning! Failed to execute VinylStop() for ", _id);
}