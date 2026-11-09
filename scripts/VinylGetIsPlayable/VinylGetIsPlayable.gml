/// Returns `true` if the given value is not a "playable". A playable is an asset or other resource
/// that Vinyl can use to play audio e.g. using `VinylPlay()`. The following is a list of valid
/// playables:
/// 
/// - Sound asset added to the project via the GameMaker IDE
/// - Sound created with `audio_create_stream()`
/// - Sound created with `audio_create_buffer_sound()`
/// - Certain types of Vinyl brain; see documentation per brain for more details
/// - An array of any of the preceeding resources (arrays can be nested inside each other)
/// 
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