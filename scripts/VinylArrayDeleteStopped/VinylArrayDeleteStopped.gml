/// Iterates over an array of voices and deletes any voices that are not currently playing. This
/// function additionally returns if the array contains any remaining playing voices.
/// 
/// @param array

function VinylArrayDeleteStopped(_array)
{
    if (not is_array(_array))
    {
        return VinylGetAnyPlaying(_array);
    }
    
    var _i = array_length(_array)-1;
    repeat(_i + 1)
    {
        if (not VinylArrayDeleteStopped(_array[_i]))
        {
            array_delete(_array, _i, 1);
        }
        
        --_i;
    }
    
    return (array_length(_array) > 0);
}