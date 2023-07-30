#macro   asset_get_index  __asset_get_index

function __asset_get_index(_asset)
{
    static _assetDict = undefined;
    if (_assetDict == undefined)
    {
        _assetDict = {};
        
        var _i = 0;
        while(true)
        {
            if (audio_exists(_i))
            {
                var _name = audio_get_name(_i);
                _name = filename_change_ext(_name, "");
                _assetDict[$ _name] = _i;
            }
            else
            {
                break;
            }
            
            ++_i;
        }
    }
    
    return _assetDict[$ _asset] ?? -1;
}