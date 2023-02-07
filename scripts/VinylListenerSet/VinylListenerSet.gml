/// @param x
/// @param y

function VinylListenerSet(_x, _y)
{
    static _globalData       = __VinylGlobalData();
    static _panEmitterActive = _globalData.__panEmitterActive;
    
    if ((_x != _globalData.__listenerX) || (_y != _globalData.__listenerY))
    {
        _globalData.__listenerX = _x;
        _globalData.__listenerY = _y;
        
        audio_listener_set_position(VINYL_LISTENER_INDEX, _x, _y, 0);
        
        var _i = 0;
        repeat(array_length(_panEmitterActive))
        {
            _panEmitterActive[_i].__UpdatePosition();
            ++_i;
        }
    }
}