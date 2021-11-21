/// @param path
/// @param [alias]
/// @param [extension]

global.__vinylAssetMap = ds_map_create();

function VinylLoad(_path, _alias = filename_change_ext(_path, ""), _extension = filename_ext(_path))
{
    if (ds_map_exists(global.__vinylAssetMap, _alias))
    {
        __VinylError("Alias \"", _alias, "\" already exists");
    }
    
    if (_extension == ".wav")
    {
        var _asset = new __VinylClassAsset(_alias, _path, FAudioGMS_StaticSound_LoadWAV(_path));
    }
    else if (_extension == ".ogg")
    {
        var _asset = new __VinylClassAsset(_alias, _path, undefined);
    }
    else
    {
        __VinylError("Extension \"", _extension, "\" not recognised");
    }
    
    global.__vinylAssetMap[? _alias] = _asset;
    
    if (VINYL_DEBUG) __VinylTrace("Loaded \"", _path, "\" as \"", _alias, "\", extension = \"", _extension, "\"");
}

function __VinylClassAsset(_alias, _path, _staticID) constructor
{
    __alias    = _alias;
    __staticID = _staticID;
    __path     = _path;
    __gain     = 1.0;
    
    static Instantiate = function()
    {
        if (__staticID == undefined)
        {
            return FAudioGMS_StreamingSound_LoadOGG(__path, VINYL_OGG_BUFFER_SIZE);
        }
        else
        {
            return FAudioGMS_StaticSound_CreateSoundInstance(__staticID);
        }
    }
}