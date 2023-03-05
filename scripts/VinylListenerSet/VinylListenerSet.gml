/// Sets the listener position for Vinyl's emitters
/// 
/// @param x
/// @param y

function VinylListenerSet(_x, _y)
{
    static _globalData = __VinylGlobalData();
    
    if ((_x != _globalData.__listenerX) || (_y != _globalData.__listenerY))
    {
        _globalData.__listenerX = _x;
        _globalData.__listenerY = _y;
        
        audio_listener_set_position(VINYL_LISTENER_INDEX, _x, _y, 0);
    }
}