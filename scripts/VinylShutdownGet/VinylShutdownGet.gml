/// Returns whether the a Vinyl playback instance is fading out (in "shutdown" mode)
/// Shutdown mode is started by calling VinylFadeOut()
/// 
/// This function cannot be used to target Vinyl labels as shutdown state is set
/// per instance
/// 
/// @param vinylID

function VinylShutdownGet(_id)
{
    static __idToInstanceDict = __VinylGlobalData().__idToInstanceDict;
    var _instance = __idToInstanceDict[? _id];
    return is_struct(_instance)? _instance.__shutdown : undefined;
}