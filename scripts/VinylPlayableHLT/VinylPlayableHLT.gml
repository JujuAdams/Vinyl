/// Constructor. Manages playables organised as a "Head loop tail". This is also known as "intro
/// loop outro". The head will be played first, if specified, then the loop sound will be played.
/// When you'd like the loop to stop, call `VinylSetLoop(logic, false)` targeting the logic. Once
/// the loop sound has stopped, the tail will play.
/// 
/// This logic is considered a playable and can be nested inside of other logic structs. Similarly,
/// each of the playables for this logic (head, loop, tail) can be any other form of playable. This
/// means you could use a queue logic for the loop playable.
/// 
/// @param [head]
/// @param loop
/// @param [tail]

function VinylPlayableHLT(_head, _loop, _tail) : __VinylLogicParentConstructor(false) constructor
{
    if (_head != undefined) VinylAssertPlayable(_head);
    VinylAssertPlayable(_loop);
    if (_tail != undefined) VinylAssertPlayable(_tail);
    
    head = _head;
    loop = _loop;
    tail = _tail;
    
    static ImplPlay = function(_loop_UNUSED, _gain, _pitch)
    {
        var _voice = new __VinylVoiceHLT(head, loop, tail);
        _voice.__Play(undefined, _gain, _pitch);
        return _voice;
    }
    
    static ImplPlayAt = function(_x, _y, _z, _loop_UNUSED, _gain, _pitch)
    {
        var _voice = new __VinylVoiceHLT(head, loop, tail);
        _voice.__PlayAt(_x, _y, _z, undefined, _gain, _pitch);
        return _voice;
    }
    
    static ImplPlayOn = function(_emitter, _loop_UNUSED, _gain, _pitch)
    {
        var _voice = new __VinylVoiceHLT(head, loop, tail);
        _voice.__PlayOn(_emitter, undefined, _gain, _pitch);
        return _voice;
    }
}