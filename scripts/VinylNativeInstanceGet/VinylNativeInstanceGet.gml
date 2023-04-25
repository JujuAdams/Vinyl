/// Returns the native instance ID for a Vinyl voice
/// 
/// If the voice targeted is a Multi voice then the instance ID for the shortest voice will be returned
/// 
/// This function will return -1 if passed a label name. This function will further return -1 for audio
/// played using VinylPlaySimple()
/// 
/// @param vinylID

function VinylNativeInstanceGet(_id)
{
    static _idToVoiceDict = __VinylGlobalData().__idToVoiceDict;
    
    var _voice = _idToVoiceDict[? _id];
    if (is_struct(_voice)) return (_voice.__NativeInstanceGet() ?? -1);
    
    return -1;
}