/// @param value

function VinylAssertPlayable(_value)
{
    if (is_array(_value))
    {
        var _i = 0;
        repeat(array_length(_value))
        {
            VinylAssertPlayable(_value);
            ++_i;
        }
    }
    else if (is_struct(_value))
    {
        try
        {
            var _ = _value.__brainInterface;
        }
        catch(_error)
        {
            throw $"Struct type \"{instanceof(_value)}\" does not inherit from `VinylBrainParentConstructor`";
        }
    }
    else if (is_handle(_value) || is_numeric(_value))
    {
        if (not audio_exists(_value))
        {
            throw $"Sound `{_value}` does not exist";
        }
    }
    else
    {
        throw $"Datatype unsupported \"{typeof(_value)}\"";
    }
}