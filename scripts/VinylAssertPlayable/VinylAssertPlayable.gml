/// Throws an exception if the given value is not a "playable". A playable is an asset or other
/// resource that Vinyl can use to play audio e.g. using `VinylPlay()`. The following is a list of
/// valid playables:
/// 
/// - Sound asset added to the project via the GameMaker IDE
/// - Sound created with `audio_create_stream()`
/// - Sound created with `audio_create_buffer_sound()`
/// - Certain types of Vinyl logic; see documentation per logic for more details
/// - An array of any of the preceeding resources (arrays can be nested inside each other)
/// 
/// @param value

function VinylAssertPlayable(_value)
{
    if (is_array(_value))
    {
        var _i = 0;
        repeat(array_length(_value))
        {
            VinylAssertPlayable(_value[_i]);
            ++_i;
        }
    }
    else if (is_struct(_value))
    {
        try
        {
            var _ = _value.__logicInterface;
        }
        catch(_error)
        {
            throw $"Struct type \"{instanceof(_value)}\" does not inherit from `VinylLogicParentConstructor`";
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