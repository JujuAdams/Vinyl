// Feather disable all

/// @param array
/// @param [strict=true]

function __VinylImportSoundArray(_array, _strict)
{
    var _newArray = [];
    
    var _i = 0;
    repeat(array_length(_array))
    {
        var _sound = _array[_i];
        
        if (is_string(_sound))
        {
            var _newSound = asset_get_index(_sound);
            if (_strict && (not audio_exists(_newSound))) __VinylError("Sound \"", _sound, "\" not found");
            array_push(_newArray, _newSound);
        }
        else if (is_handle(_sound))
        {
            array_push(_newArray, _sound);
        }
        else
        {
            if (_strict) __VinylError("Datatype not supported (", typeof(_sound), ")");
        }
        
        ++_i;
    }
    
    return _newArray;
}