// Feather disable all

/// @param array
/// @param [maxCharacters=40]

function __VinylLabelsGetAbbreviatedName(_array, _maxCharacters = 40)
{
    if (not is_array(_array)) return "???";
    
    var _length = array_length(_array);
    if (_length <= 0) return __VINYL_ASSET_NULL;
    
    var _string = "";
    var _i = 0;
    repeat(_length)
    {
        var _child = _array[_i];
        if (_i < _length-1)
        {
            _string += _child + ", ";
        }
        else
        {
            _string += _child;
        }
        
        ++_i;
    }
    
    if (string_length(_string) > _maxCharacters)
    {
        _string = string_copy(_string, 1, _maxCharacters-3) + "...";
    }
    
    return _string;
}