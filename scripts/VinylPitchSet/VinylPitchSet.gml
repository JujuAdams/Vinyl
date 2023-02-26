/// Sets the pitch of a Vinyl playback instance, or Vinyl label
/// Setting pitch with this function immediately resets the pitch target (as set by VinylPitchTargetSet())
/// 
/// If this function is given a label name then all currently playing audio assigned with that label will
/// be immediately affected by the change in the label's pitch state
/// 
/// This function will not affect currently playing audio played using VinylPlaySimple()
/// 
/// @param vinylID/labelName
/// @param pitch

function VinylPitchSet(_id, _pitch)
{
    static _globalData = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__PitchSet(_pitch);
    
    var _label = _globalData.__labelDict[$ _id];
    if (is_struct(_label)) return _label.__PitchSet(_pitch);
    
    __VinylTrace("Warning! Failed to execute VinylPitchSet() for ", _id);
}