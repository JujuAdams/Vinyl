function __VinylClassProjectAsset(_name, _path, _firstTime) constructor
{
    static __projectAssetDict = __VinylGlobalData().__projectAssetDict;
    
    
    
    
    
    __name    = _name;
    __path    = _path;
    __inBuild = _firstTime;
    
    __projectAssetDict[$ __name] = self;
    
    __hash    = md5_file(__path);
    __ogg     = (filename_ext(__path) == ".ogg");
    __cleanUp = false;
    
    if (__inBuild)
    {
        __asset = asset_get_index(__name);
        __projectAssetDict[$ __asset] = self;
    }
    else
    {
        __Load();
    }
    
    
    
    
    
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
        
        variable_struct_remove(__projectAssetDict, __name);
        if (__inBuild) variable_struct_remove(__projectAssetDict, __asset);
    }
    
    static __CheckForChange = function()
    {
        var _foundHash = md5_file(__path);
        if (_foundHash == __hash) return;
        
        __hash = _foundHash;
        __Load();
    }
}