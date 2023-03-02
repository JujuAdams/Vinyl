/// Sets behaviour for a Vinyl queue instance, or queue instances assigned to a Vinyl label
/// 
/// If this function is given a label name then all currently playing queue instances assigned
/// with that label will have their behaviour set
/// 
/// The behaviour value must be one of the following:
/// 
///   0 = Play the queue once. Assets will be removed from the queue once they finish playing
///   1 = Repeat the queue once it’s finished. No assets are removed from the queue, and the queue
///       will replay from the start
///   2 = Repeat the last asset in the queue. Assets will be removed from the queue once they
///       finish playing (apart from the last asset)
/// 
/// @param vinylID
/// @param behavior

function VinylQueueBehaviorSet(_id, _behavior)
{
    static _globalData = __VinylGlobalData();
    static _idToVoiceDict = _globalData.__idToVoiceDict;
    
    var _instance = _idToVoiceDict[? _id];
    if (is_struct(_instance)) return _instance.__QueueBehaviorSet(_behavior);
    
    var _label = _globalData.__labelDict[$ _id];
    if (is_struct(_label)) return _label.__QueueBehaviorSet(_behavior);
    
    __VinylTrace("Warning! Failed to execute VinylQueueBehaviorSet() for ", _id);
}