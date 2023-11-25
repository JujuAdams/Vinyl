// Feather disable all

/// @param array
/// @param [maxCharacters=40]

function __VinylAssetTagsGetAbbreviatedName(_array, _maxCharacters = 40)
{
    if (not is_array(_array)) return "???";
    
    var _length = array_length(_array);
    if (_length <= 0) return "<No asset tags>";
    
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
    
    return __VinylTrimString(_string, _maxCharacters);
}