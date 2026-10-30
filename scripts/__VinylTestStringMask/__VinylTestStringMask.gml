// Feather disable all

/// @param string
/// @param mask

function __VinylTestStringMask(_string, _mask)
{
    var _substringArray = string_split(_mask, "*", true);
    var _substringCount = array_length(_substringArray);
    
    if (_substringCount == 0)
    {
        return (_mask == "")? true : (_string == _mask);
    }
    else
    {
        var _pos = 1;
        var _j = 0;
        repeat(array_length(_substringArray))
        {
            _pos = string_pos_ext(_substringArray[_j], _string, _pos);
            if (_pos <= 0) return false;
            
            ++_j;
        }
    }
    
    return true;
}