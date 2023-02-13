/// Sets the input pitch target for a Vinyl playback instance, or a Vinyl label
/// The input pitch will approach the target smoothly over a few frames, determined by the rate
/// 
/// If this function is given a label name then all currently playing audio assigned with that label will
/// be affected by the change in the label's pitch state
/// 
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID/labelName
/// @param targetPitch
/// @param [rate=VINYL_DEFAULT_PITCH_RATE]

function VinylPitchTargetSet(_id, _targetPitch, _rate = VINYL_DEFAULT_PITCH_RATE)
{
    static _globalData = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__PitchTargetSet(_targetPitch, _rate);
    
    var _label = _globalData.__labelDict[$ _id];
    if (is_struct(_label)) return _label.__PitchTargetSet(_targetPitch, _rate);
}