// Feather disable all
function __VinylClassProjectAsset(_name, _path, _firstTime) constructor
{
    static __projectAssetNameDict = __VinylGlobalData().__projectAssetNameDict;
    
    
    
    
    
    __name = _name;
    __path = _path;
    
    __hash    = md5_file(__path);
    __ogg     = (filename_ext(__path) == ".ogg");
    __cleanUp = false;
    
    if (_firstTime)
    {
        __asset = asset_get_index(__name);
    }
    else
    {
        __Load();
    }
    
    __projectAssetNameDict[$ __name] = self;
    //if ((__asset != undefined) && (__asset >= 0)) __projectAssetDict[$ __asset] = self;
    
    
    
    
    
    static __Load = function()
    {
        __Unload();
        
        if (__ogg)
        {
            __asset = audio_create_stream(__path);
        }
        else
        {
            __asset = __VinylWavToAsset(__path);
        }
        
        __cleanUp = true;
    }
    
    static __Unload = function()
    {
        if (!__cleanUp) return;
        __cleanUp = false;
        
        if (__asset != undefined)
        {
            if (__ogg)
            {
                audio_destroy_stream(__asset);
            }
            else
            {
                audio_free_buffer_sound(__asset);
            }
        }
        
        __asset = undefined;
    }
    
    static __Destroy = function()
    {
        __Unload();
        
        variable_struct_remove(__projectAssetNameDict, __name);
        //if ((__asset != undefined) && (__asset >= 0)) variable_struct_remove(__projectAssetDict, __asset);
    }
    
    static __CheckForChange = function()
    {
        var _foundHash = md5_file(__path);
        if (_foundHash == __hash) return;
        
        __hash = _foundHash;
        __Load();
    }
}