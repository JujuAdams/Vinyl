/// Starts audio on a timer. The time between audio is randomly chosen between the minimum and
/// maximum delays. The audio that is played does not have to be a sound asset and could be another
/// playable such as `VinylLogicShuffle()`.
/// 
/// Example:
///     /// Create Event
///     shuffleLogic = new VinylLogicShuffle([sndBird1, sndBird2, sndBird3, sndFrog]);
///     retriggerLogic = new VinylLogicRetrigger(shuffleLogic, 1, 2);
///     VinylPlay(retriggerLogic);
/// 
/// @param playable
/// @param minDelay
/// @param maxDelay
/// @param [playImmediate=false]

function VinylPlayableRetrigger(_playable, _minDelay, _maxDelay, _playImmediate = false) : __VinylLogicParentConstructor(false) constructor
{
    VinylAssertPlayable(_playable);
    
    playable      = _playable;
    minDelay      = _minDelay;
    maxDelay      = _maxDelay;
    playImmediate = _playImmediate;
    
    static ImplPlay = function(_loop, _gain, _pitch)
    {
        var _voice = new __VinylVoiceRetrigger(playable, minDelay, maxDelay, playImmediate);
        _voice.__Play(_loop, _gain, _pitch);
        return _voice;
    }
    
    static ImplPlayAt = function(_x, _y, _z, _loop_UNUSED, _gain, _pitch)
    {
        var _voice = new __VinylVoiceRetrigger(playable, minDelay, maxDelay, playImmediate);
        _voice.__PlayAt(_x, _y, _z, _loop, _gain, _pitch);
        return _voice;
    }
    
    static ImplPlayOn = function(_emitter, _loop_UNUSED, _gain, _pitch)
    {
        var _voice = new __VinylVoiceRetrigger(playable, minDelay, maxDelay, playImmediate);
        _voice.__PlayOn(_emitter, _loop, _gain, _pitch);
        return _voice;
    }
}