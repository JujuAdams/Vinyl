/// Basic XORShift32, nothing fancy
/// 
/// @param value

function __VinylRandom(_value)
{
    static _state = floor(1000000*date_current_datetime() + display_mouse_get_x() + display_get_width()*display_mouse_get_y());
    
    if (VINYL_USE_INTERNAL_PRNG)
    {
        _state  = (_state ^ (_state << 13)) & 0xFFFFFFFF; //Limit to 32 bits
        _state ^=            _state >> 17;
        _state  = (_state ^ (_state <<  5)) & 0xFFFFFFFF; //Limit to 32 bits
        
        return _value * (real(_state) / 4294967296);
    }
    else
    {
        return random(_value);
    }
}