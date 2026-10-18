/// Returns if the array has any remaining playing members.
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