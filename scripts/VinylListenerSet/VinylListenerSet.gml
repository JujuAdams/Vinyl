/// @param x
/// @param y

function VinylListenerSet(_x, _y)
{
    static _globalData = __VinylGlobalData();
    static _panArray   = _globalData.__panArray;
    
    if ((_x != global.__vinylListener.x) || (_y != global.__vinylListener.y))
    {
        global.__vinylListener.x = _x;
        global.__vinylListener.y = _y;
        
        audio_listener_set_position(0,   _x, _y, 0);
        
        var _i = 0;
        repeat(array_length(_panArray))
        {
            _panArray[_i].__UpdatePosition();
            ++_i;
        }
    }
}