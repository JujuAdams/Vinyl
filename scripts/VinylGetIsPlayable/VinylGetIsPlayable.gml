/// @param value

function VinylGetIsPlayable(_value)
{
    if (is_array(_value))
    {
        var _i = 0;
        repeat(array_length(_value))
        {
            if (not VinylGetIsPlayable(_value))
            {
                return false;
            }
            
            ++_i;
        }
        
        return true;
    }
    else if (is_struct(_value))
    {
        try
        {
            var _ = _value.__brainInterface;
            return true;
        }
        catch(_error)
        {
            return false;
        }
    }
    else if (is_handle(_value) || is_numeric(_value))
    {
        return audio_exists(_value);
    }
    else
    {
        return false;
    }
}