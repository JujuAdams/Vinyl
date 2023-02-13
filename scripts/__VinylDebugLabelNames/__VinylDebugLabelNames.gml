/// @param patternName

function __VinylDebugLabelNames(_patternName)
{
    var _pattern = __VinylPatternGet(_patternName);
    if (!is_struct(_pattern)) return "";
    
    var _labelArray = _pattern.__labelArray;
    var _string = "";
    
    var _size = array_length(_labelArray);
    if (_size > 1) _string += "[";
    
    var _i = 0;
    repeat(_size)
    {
        _string += _labelArray[_i].__name;
        if (_i < _size-1) _string += ", ";
        ++_i;
    }
    
    if (_size > 1) _string += "]";
    
    return _string;
}