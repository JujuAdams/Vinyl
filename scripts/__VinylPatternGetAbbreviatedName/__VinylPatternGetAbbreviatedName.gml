// Feather disable all

/// @param dictionary
/// @param patternUUID
/// @param [maxCharacters=40]

function __VinylPatternGetAbbreviatedName(_document, _patternUUID, _maxCharacters = 40)
{
    var _patternStruct = _document.__GetPattern(_patternUUID);
    if (not is_struct(_patternStruct)) return "???";
    
    with(_patternStruct)
    {
        var _length = array_length(__childArray);
        if (_length <= 0) return __VINYL_ASSET_NULL;
        
        var _string = __patternType + " (";
        var _i = 0;
        repeat(_length)
        {
            var _childUUID = __childArray[_i];
            var _child = _document.__GetPattern(_childUUID);
            
            var _substring = (_child == undefined)? "" : _child.__GetName(infinity);
            if (_substring != "")
            {
                if (_i < _length-1)
                {
                    _string += _substring + ", ";
                }
                else
                {
                    _string += _substring;
                }
            }
            
            ++_i;
        }
        
        _string += ")";
        
        return __VinylTrimString(_string, _maxCharacters);
    }
}