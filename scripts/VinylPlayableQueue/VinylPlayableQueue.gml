/// Constructor. Creates a struct that manages a queue of playables stored in an array.
/// 
/// This logic struct is considered a playable and can be nested inside other logic structs. Similarly, each
/// of the playables stored in the logic can be any other form of playable. You could nest a queue
/// within a queue if you wanted.
/// 
/// @param playableArray
/// @param [behavior=DONT_LOOP]
/// @param [loopQueue=false]
/// @param [fadeInTime=0]
/// @param [playCallback]

function VinylPlayableQueue(_playableArray, _behavior = VINYL_QUEUE_DONT_LOOP, _loopQueue = false, _fadeInTime = 0, _playCallback = undefined) : __VinylLogicParentConstructor() constructor
{
    VinylAssertPlayable(_playableArray);
    
    playableArray = variable_clone(_playableArray);
    behavior      = _behavior;
    loopQueue     = _loopQueue;
    fadeInTime    = _fadeInTime;
    playCallback  = _playCallback;
    
    static ImplPlay = function(_loop, _gain_UNUSED, _pitch_UNUSED)
    {
        var _voice = new __VinylVoiceQueue(playableArray, behavior, loopQueue, fadeInTime, playCallback);
        _voice.__Play(_loop ?? loopQueue);
        return _voice;
    }
    
    static ImplPlayAt = function(_x, _y, _z, _loop, _gain_UNUSED, _pitch_UNUSED)
    {
        var _voice = new __VinylVoiceQueue(playableArray, behavior, loopQueue, fadeInTime, playCallback);
        _voice.__PlayAt(_x, _y, _z, _loop ?? loopQueue);
        return _voice;
    }
    
    static ImplPlayOn = function(_emitter, _loop, _gain_UNUSED, _pitch_UNUSED)
    {
        var _voice = new __VinylVoiceQueue(playableArray, behavior, loopQueue, fadeInTime, playCallback);
        _voice.__PlayOn(_emitter, _loop ?? loopQueue);
        return _voice;
    }
}