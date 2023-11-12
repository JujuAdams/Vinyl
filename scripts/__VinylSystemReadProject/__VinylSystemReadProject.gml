// Feather disable all

function __VinylSystemReadProject(_document, _projectData, _firstUpdate)
{
    var _projectDirectory   = _document.__projectDirectory;
    var _oldSoundDictionary = _document.__projectSoundDictionary;
    var _oldSoundArray      = _document.__projectSoundArray;
    var _oldSoundHashDict   = _document.__projectSoundHashDict;
    var _audioGroupArray    = _document.__projectAudioGroupArray;
    
    var _anyChanges = false;
    
    var _newSoundDict  = {};
    var _newSoundArray = [];
    
    //Find audio groups
    var _audioGroupsArray = _projectData.AudioGroups;
    var _i = 0;
    repeat(array_length(_audioGroupsArray))
    {
        array_push(_audioGroupArray, _audioGroupsArray[_i].name);
        ++_i;
    }
    
    //Iterate over the project and discover all sounds
    var _resourcesArray = _projectData.resources;
    var _i = 0;
    repeat(array_length(_resourcesArray))
    {
        var _resource = _resourcesArray[_i];
        var _path = _resource.id.path;
        
        if (string_copy(_path, 1, 6) == "sounds")
        {
            var _soundName = filename_change_ext(filename_name(_path), "");
            __VinylTrace("Project: Saw sound \"", _soundName, "\" in project file");
            
            array_push(_newSoundArray, _soundName);
            _newSoundDict[$ _soundName] = _path;
        }
        
        ++_i;
    }
    
    //Add any new sounds from the project
    var _i = 0;
    repeat(array_length(_newSoundArray))
    {    
        var _soundName = _newSoundArray[_i];
        if (variable_struct_exists(_oldSoundDictionary, _soundName))
        {
            _oldSoundDictionary[$ _soundName].__CheckYYFile(false);
        }
        else
        {
            _anyChanges = true;
            
            //Try to figure out what type of file the raw data on disk is
            var _absolutePath = _projectDirectory + _newSoundDict[$ _soundName];
            var _type = __VINYL_SOUND_TYPE.__EXTERNAL_WAV;
            
            _absolutePath = filename_change_ext(_absolutePath, ".wav");
            if (not file_exists(_absolutePath))
            {
                _absolutePath = filename_change_ext(_absolutePath, ".ogg");
                _type = __VINYL_SOUND_TYPE.__EXTERNAL_OGG;
                
                if (not file_exists(_absolutePath))
                {
                    __VinylTrace("Project: Warning! Could not find source audio file for \"", _soundName, "\"");
                    
                    ++_i;
                    continue;
                }
            }
            
            var _yyPath = filename_change_ext(_absolutePath, ".yy");
            
            //Get the hash of the file
            var _hash = md5_file(_absolutePath);
            if (_firstUpdate && (asset_get_type(_soundName) == asset_sound))
            {
                //Special case for first update
                __VinylTrace("Project: Sound \"", _soundName, "\" has been discovered on boot");
                var _newSoundData = new __VinylClassProjectSound(__VINYL_SOUND_TYPE.__WAD, _soundName, _yyPath, _absolutePath);
                
                //Track this new sound
                _oldSoundDictionary[$ _soundName] = _newSoundData;
                array_push(_oldSoundArray, _soundName);
                _oldSoundHashDict[$ _hash] = _newSoundData;
            }
            else
            {
                var _oldSoundData = _oldSoundHashDict[$ _hash];
                if (is_struct(_oldSoundData))
                {
                    //Remove the old sound reference but not the hash (since that hasn't changed)
                    variable_struct_remove(_oldSoundDictionary, _oldSoundData.__name);
                    
                    _oldSoundData.__Change(_type, _soundName, _absolutePath);
                    
                    //Re-add the sound under a new name
                    _oldSoundDictionary[$ _soundName] = _oldSoundData;
                    
                    _newSoundData = _oldSoundData;
                }
                else
                {
                    __VinylTrace("Project: Sound \"", _soundName, "\" has been added");
                    
                    var _newSoundData = new __VinylClassProjectSound(_type, _soundName, _yyPath, _absolutePath);
                    
                    //Track this new sound
                    _oldSoundDictionary[$ _soundName] = _newSoundData;
                    array_push(_oldSoundArray, _soundName);
                    _oldSoundHashDict[$ _hash] = _newSoundData;
                }
            }
            
            _newSoundData.__CheckYYFile(_firstUpdate);
        }
        
        ++_i;
    }
    
    //Remove any old sounds from the existing sound dictionary
    var _i = 0;
    repeat(array_length(_oldSoundArray))
    {
        var _oldSoundName = _oldSoundArray[_i];
        if (not variable_struct_exists(_newSoundDict, _oldSoundName))
        {
            _anyChanges = true;
            
            var _oldSound = _oldSoundDictionary[$ _oldSoundName];
            if (is_struct(_oldSound) && (_oldSound.__name == _oldSoundName))
            {
                __VinylTrace("Project: Sound \"", _oldSoundName, "\" has been removed");
                
                //Untrack the old sound
                variable_struct_remove(_oldSoundDictionary, _oldSoundName);
                array_delete(_oldSoundArray, _i, 1);
                variable_struct_remove(_oldSoundHashDict, _oldSound.__hash);
                
                _oldSound.__Unload();
            }
            else
            {
                //Sound was renamed so we don't need to report this, nor do we need to remove the hash
                variable_struct_remove(_oldSoundDictionary, _oldSoundName);
                array_delete(_oldSoundArray, _i, 1);
            }
        }
        else
        {
            ++_i;
        }
    }
    
    array_sort(__projectSoundArray, true);
    
    return _anyChanges;
}