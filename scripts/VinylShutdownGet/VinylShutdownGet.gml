/// Returns whether the a Vinyl playback instance is fading out (in "shutdown" mode)
/// Shutdown mode is started by calling VinylFadeOut()
/// 
/// This function cannot be used to target Vinyl labels as shutdown state is set
/// per instance
/// 
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID

function VinylShutdownGet(_id)
{
    static __idToVoiceDict = __VinylGlobalData().__idToVoiceDict;
    var _instance = __idToVoiceDict[? _id];
    return is_struct(_instance)? (_instance.__shutdown || _instance.__stopCallback) : undefined;
}