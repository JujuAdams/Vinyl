/// @param x
/// @param y
/// @param z
/// @param xForward
/// @param yForward
/// @param zForward
/// @param xUp
/// @param yUp
/// @param zUp

function VinylSetListener(_x, _y, _z,   _xForward, _yForward, _zForward,   _xUp, _yUp, _zUp)
{
    static _mixGroupArray = __VinylSystem().__mixGroupArray;
    
    //Move the listener
    audio_listener_set_position(0, _x, _y, _z);
    
    //Keep global (omnidirectional) emitters next to the listener
    var _i = 0;
    repeat(array_length(_mixGroupArray))
    {
        audio_emitter_position(_mixGroupArray[_i].__globalGMEmitterAndBus.__gmEmitter, _x, _y, _z);
        ++_i;
    }
    
    //GameMaker's listener orientation seems to be upside down?
    audio_listener_set_orientation(0,
                                   _xForward, _yForward, _zForward,
                                   -_xUp, -_yUp, -_zUp);
}