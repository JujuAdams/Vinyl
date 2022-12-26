/// Fades out a Vinyl playback instance, stopping it once it reaches silence
/// Once a playback instance is fading out, the process cannot be halted or paused
/// 
/// If passed a label name, every audio instance currently assigned to the label will
/// individually fade out. This is the same as calling VinylFadeOut() for each individual
/// audio instance. The gain target for the label itself is NOT affected
/// 
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID/labelName
/// @param [rate=VINYL_DEFAULT_GAIN_RATE]

function VinylFadeOut(_id, _rate = VINYL_DEFAULT_GAIN_RATE)
{
    var _instance = global.__vinylIdToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__FadeOut(_rate);
    
    if (_id == undefined) return;
    
    var _label = global.__vinylLabelDict[$ _id];
    if (is_struct(_label)) return _label.__FadeOut(_rate);
}