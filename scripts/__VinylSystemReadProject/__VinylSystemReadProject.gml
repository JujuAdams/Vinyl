function __VinylSystemReadProject(_projectData, _firstUpdate)
{
    static _projectDirectory = filename_dir(GM_project_filename) + "/";
    static _globalData       = __VinylGlobalData();
    
    static _oldSoundDict     = _globalData.__projectSoundDict;
    static _oldSoundArray    = _globalData.__projectSoundArray;
    static _oldSoundHashDict = _globalData.__projectSoundHashDict;
    
    var _newSoundDict  = {};
    var _newSoundArray = [];
    
    //Iterate over the project and discover all sound assets
    var _resourcesArray = _projectData.resources;
    var _i = 0;
    repeat(array_length(_resourcesArray))
    {
        var _resource = _resourcesArray[_i];
        var _path = _resource.id.path;
        
        if (string_copy(_path, 1, 6) == "sounds")
        {
            var _assetName = filename_change_ext(filename_name(_path), "");
            __VinylTrace("Project: Saw asset \"", _assetName, "\" in project file");
            
            array_push(_newSoundArray, _assetName);
            _newSoundDict[$ _assetName] = _path;
        }
        
        ++_i;
    }
    
    //Add any new assets from the project
    var _i = 0;
    repeat(array_length(_newSoundArray))
    {    
        var _assetName = _newSoundArray[_i];
        if (not variable_struct_exists(_oldSoundDict, _assetName))
        {
            //Try to figure out what type of file the raw data on disk is
            var _absolutePath = _projectDirectory + _newSoundDict[$ _assetName];
            var _type = __VINYL_ASSET_TYPE.__EXTERNAL_WAV;
            
            _absolutePath = filename_change_ext(_absolutePath, ".wav");
            if (not file_exists(_absolutePath))
            {
                _absolutePath = filename_change_ext(_absolutePath, ".ogg");
                _type = __VINYL_ASSET_TYPE.__EXTERNAL_OGG;
                
                if (not file_exists(_absolutePath))
                {
                    __VinylTrace("Project: Warning! Could not find source audio file for \"", _assetName, "\"");
                    
                    ++_i;
                    continue;
                }
            }
            
            //Get the hash of the file
            var _hash = md5_file(_absolutePath);
            
            if (_firstUpdate && (asset_get_type(_assetName) == asset_sound))
            {
                //Special case for first update
                __VinylTrace("Project: Asset \"", _assetName, "\" has been discovered on boot");
                var _newAsset = new __VinylClassAsset(__VINYL_ASSET_TYPE.__WAD, _assetName);
                
                //Track this new asset
                _oldSoundDict[$ _assetName] = _newAsset;
                array_push(_oldSoundArray, _assetName);
                _oldSoundHashDict[$ _hash] = _newAsset;
            }
            else
            {
                var _oldAsset = _oldSoundHashDict[$ _hash];
                if (is_struct(_oldAsset))
                {
                    __VinylTrace("Project: Asset \"", _oldAsset.__name, "\" renamed to \"", _assetName, "\"");
                    
                    //Remove the old asset reference but not the hash (since that hasn't changed)
                    variable_struct_remove(_oldSoundDict, _oldAsset.__name);
                    
                    _oldAsset.__Change(_type, _assetName, _absolutePath);
                    
                    //Re-add the asset under a new name
                    _oldSoundDict[$ _assetName] = _oldAsset;
                }
                else
                {
                    __VinylTrace("Project: Asset \"", _assetName, "\" has been added");
                    
                    var _newAsset = new __VinylClassAsset(_type, _assetName, _absolutePath);
                    
                    //Track this new asset
                    _oldSoundDict[$ _assetName] = _newAsset;
                    array_push(_oldSoundArray, _assetName);
                    _oldSoundHashDict[$ _hash] = _newAsset;
                }
            }
        }
        
        ++_i;
    }
    
    //Remove any old assets from the existing sound dictionary
    var _i = 0;
    repeat(array_length(_oldSoundArray))
    {
        var _oldSoundName = _oldSoundArray[_i];
        if (not variable_struct_exists(_newSoundDict, _oldSoundName))
        {
            var _oldSound = _oldSoundDict[$ _oldSoundName];
            if (is_struct(_oldSound) && (_oldSound.__name == _oldSoundName))
            {
                __VinylTrace("Project: Asset \"", _oldSoundName, "\" has been removed");
                
                //Untrack the old asset
                variable_struct_remove(_oldSoundDict, _oldSoundName);
                array_delete(_oldSoundArray, _i, 1);
                variable_struct_remove(_oldSoundHashDict, _oldSound.__hash);
                
                _oldSound.__Unload();
            }
            else
            {
                //Asset was renamed so we don't need to report this, nor do we need to remove the hash
                variable_struct_remove(_oldSoundDict, _oldSoundName);
                array_delete(_oldSoundArray, _i, 1);
            }
        }
        else
        {
            ++_i;
        }
    }
}