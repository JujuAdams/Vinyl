// Feather disable all

function __VinylFilterApply(_filter, _data)
{
    if (_filter == undefined) return true;
    
    with(_filter)
    {
        if (__useNameMatch)
        {
            var _soundName = _data.__name;
            var _subArray = string_split(__stringMatch, "*", true);
            
            var _pos = 1;
            var _j = 0;
            repeat(array_length(_subArray))
            {
                var _substring = _subArray[_j];
            
                _pos = string_pos_ext(_substring, _soundName, _pos);
                if (_pos <= 0) return false;
            
                ++_j;
            }
        }
        
        if (__useLength)
        {
            var _length = audio_sound_length(_data.__soundID);
            if ((_length < __lengthMin) || (_length > __lengthMax)) return false;
        }
        
        if (__useAudioGroup)
        {
            if (not variable_struct_exists(__audioGroupDict, _data.__audioGroup)) return false;
        }
        
        if (__useAttribute)
        {
            if (not __attributes[_data.__attribute]) return false;
        }
        
        return true;
    }
    
}