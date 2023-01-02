/// @param x
/// @param y

function VinylListenerSet(_x, _y)
{
    global.__vinylListener.x = _x;
    global.__vinylListener.y = _y;
    
    audio_listener_set_position(0,   _x, _y, 0);
}