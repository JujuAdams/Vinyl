/// @param labelArray

function __VinylDebugLabelNames(_labelArray)
{
    var _labelReadable = "";
    
    var _size = array_length(_labelArray);
    if (_size > 1) _labelReadable += "[";
    
    var _i = 0;
    repeat(_size)
    {
        _labelReadable += _labelArray[_i].__name;
        if (_i < _size-1) _labelReadable += ", ";
        ++_i;
    }
    
    if (_size > 1) _labelReadable += "]";
    
    return _labelReadable;
}