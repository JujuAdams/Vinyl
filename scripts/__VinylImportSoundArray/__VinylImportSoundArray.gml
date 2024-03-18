// Feather disable all

function __VinylImportSoundArray(_array)
{
    var _newArray = [];
    
    var _i = 0;
    repeat(array_length(_array))
    {
        var _asset = _array[_i];
        if (is_string(_asset)) _asset = asset_get_index(_asset);
        
        if (not audio_exists(_asset))
        {
            __VinylWarning("Sound \"", _array[_i], "\" not recognised");
        }
        else
        {
            array_push(_newArray, _asset);
        }
            
        ++_i;
    }
    
    return _newArray;
}