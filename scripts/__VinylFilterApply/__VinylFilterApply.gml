// Feather disable all

function __VinylFilterApply(_filter, _data)
{
    if (_filter == undefined) return true;
    
    with(_filter)
    {
        if (__useNameMatch)
        {
            var _soundName = _data.__name;
            var _subArray = string_split(__nameMatch, "*", true);
            
            var _pos = 1;
            var _j = 0;
            repeat(array_length(_subArray))
            {
                var _substring = _subArray[_j];
            
                _pos = string_pos_ext(_substring, _soundName, _pos);
                if (_pos <= 0) return __invert;
            
                ++_j;
            }
        }
        
        if (__useLength)
        {
            var _length = audio_sound_length(_data.__soundID);
            if ((_length < __length[0]) || (_length > __length[1])) return __invert;
        }
        
        if (__useAudioGroup)
        {
            if (not variable_struct_exists(__audioGroupDict, _data.__audioGroup)) return __invert;
        }
        
        if (__useAttribute)
        {
            if (not __attributesArray[_data.__attributes]) return __invert;
        }
        
        return (not __invert);
    }
    
}