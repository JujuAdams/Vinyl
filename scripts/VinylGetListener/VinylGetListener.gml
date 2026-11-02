/// Returns a struct that contains parameters for the audio listener. These values are set by
/// `VinylSetListener()`.
/// 
/// `.x`  `.y`  `.z`
///     Position of the listener
/// 
/// `.xForward`  `.yForward`  `.zForward`
///     Vector that defines the forward axis for the listener
/// 
/// `.xUp`  `.yUp`  `.zUp`
///     Vector that defines the up axis for the listener

function VinylGetListener()
{
    static _system = __VinylSystem();
    
    return _system.__listener;
}