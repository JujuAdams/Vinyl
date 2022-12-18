/// Returns whether the a Vinyl playback instance is fading out (in "shutdown" mode)
/// 
/// @param vinylID

function VinylShutdownGet(_id)
{
    var _instance = global.__vinylIdToInstanceDict[? _id];
    return is_struct(_instance)? _instance.__shutdown : undefined;
}