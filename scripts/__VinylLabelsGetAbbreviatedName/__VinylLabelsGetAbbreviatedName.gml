// Feather disable all

/// @param patternStruct
/// @param [maxCharacters=40]
/// @param [bracketWrap=false]

function __VinylPatternGetAbbreviatedName(_patternStruct, _maxCharacters = 40, _bracketWrap = false)
{
    if (not is_struct(_patternStruct)) return "???";
    
    with(_patternStruct)
    {
        var _length = array_length(assets);
        if (_length <= 0) return __VINYL_ASSET_NULL;
        
        if ((type == "Asset") || (type == "Basic"))
        {
            _bracketWrap = false;
        }
        
        var _string = "";
        var _i = 0;
        repeat(_length)
        {
            var _child = assets[_i];
            
            if (is_struct(_child))
            {
                _child = __VinylPatternGetAbbreviatedName(_child, infinity, true);
            }
            
            if (_child != "")
            {
                if (_i < _length-1)
                {
                    _string += _child + ", ";
                }
                else
                {
                    _string += _child;
                }
            }
            
            ++_i;
        }
        
        var _testLength = _maxCharacters;
        if (_bracketWrap) _testLength -= 2;
        
        if (string_length(_string) > _testLength)
        {
            _string = string_copy(_string, 1, _testLength-3) + "...";
        }
        
        if (_bracketWrap)
        {
            return "[" + _string + "]";
        }
        else
        {
            return _string;
        }
    }
}