#macro   asset_get_type    __asset_get_type
#macro __asset_get_type__    asset_get_type

function __asset_get_type(_asset)
{
    static _audioDict = undefined;
    if (_audioDict == undefined)
    {
        _audioDict = {};
        
        var _i = 0;
        while(true)
        {
            if (audio_exists(_i))
            {
                var _name = audio_get_name(_i);
                _name = filename_change_ext(_name, "");
                
                __VinylTrace(_name, " = ", _i);
                
                _audioDict[$ _name] = asset_sound;
            }
            else
            {
                break;
            }
            
            ++_i;
        }
    }
    
    var _type = __asset_get_type__(_asset);
    if (_type < 0) _type = _audioDict[$ _asset] ?? -1;
    
    return _type;
}