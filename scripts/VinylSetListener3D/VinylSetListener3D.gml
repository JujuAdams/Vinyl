/// Set the position and orientation for Vinyl's listener. This function offers full compatibility
/// for use in 3D games. If you are making a 2D game and don't need to adjust the orientation of
/// the listener then consider using `VinylSetListener2D()`.
/// 
/// @param x
/// @param y
/// @param z
/// @param xForward
/// @param yForward
/// @param zForward
/// @param xUp
/// @param yUp
/// @param zUp

function VinylSetListener3D(_x, _y, _z,   _xForward, _yForward, _zForward,   _xUp, _yUp, _zUp)
{
    static _mixGroupArray = __VinylSystem().__mixGroupArray;
    static _listenerStruct = __VinylSystem().__listener;
    
    //Move the listener
    audio_listener_set_position(0, _x, _y, _z);
    
    //Keep global emitters next to the listener
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
    
    with(_listenerStruct)
    {
        x = _x;
        y = _y;
        z = _z;
        
        xForward = _xForward;
        yForward = _yForward;
        zForward = _zForward;
        
        xUp = _xUp;
        yUp = _yUp;
        zUp = _zUp;
    }
}