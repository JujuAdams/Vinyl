// Feather disable all

function __VedClassProject() constructor
{
    __pathYY        = undefined;
    __pathVinyl     = undefined;
    __pathGenMacros = undefined;
    __pathGenPlay   = undefined;
    
    __ident = undefined;
    
    __libYYPAsset   = new __VedClassLibrary();
    __libVinylAsset = new __VedClassLibrary();
    __libPattern    = new __VedClassLibrary();
    __libAudioGroup = new __VedClassLibrary();
    __libAssetTag   = new __VedClassLibrary();
    
    __changesArray = [];
    
    
    
    
    
    static __Update = function()
    {
        
    }
    
    static __Serialize = function()
    {
        var _output = {
            ident: __ident,
            assets: [],
            triggers: [],
        };
        
        __libVinylAsset.__ForEach(function(_index, _name, _scope, _metadata)
        {
            _scope.__Serialize(_metadata.__array);
        },
        {
            __array: _output.assets,
        });
        
        __libPattern.__ForEach(function(_index, _name, _scope, _metadata)
        {
            _scope.__Serialize(_metadata.__array);
        },
        {
            __array: _output.triggers,
        });
        
        return _output;
    }
    
    static __Deserialize = function(_input)
    {
        __ident = _input.ident;
        __libVinylAsset.__ImportArray(__VedDeserializeArray(__VedClassVinylAsset, _input.assets));
        __libPattern.__ImportArray(__VedDeserializeArray(__VedClassPattern, _input.triggers));
    }
    
    
    
    
    
    static __SetPaths = function(_yyPath)
    {
        __pathYY         = _yyPath;
        __pathVinyl      = filename_dir(__pathYY) + "/" + __VED_PROJECT_FILENAME;
        __pathGenMacros  = filename_dir(__pathYY) + "/scripts/__VinylGenMacro/__VinylGenMacro.gml";
        __pathGenPlay    = filename_dir(__pathYY) + "/scripts/__VinylGenPlay/__VinylGenPlay.gml";
        __pathGenPattern = filename_dir(__pathYY) + "/scripts/__VinylGenPattern/__VinylGenPattern.gml";
    }
    
    static __CreateFromGameMakerProject = function(_yyPath)
    {
        __SetPaths(_yyPath);
        __VedLog("Creating \"", __pathVinyl, "\" next to \"", __pathYY, "\"");
        
        if (not file_exists(__pathYY))
        {
            __VedWarning("GameMaker project doesn't exist");
            __VedModalOpen(__VedClassModalOperationFailed).__path = __pathYY;
            return false;
        }
        
        __ident = __VedGenerateUUID();
        
        __LoadGameMakerProject();
        __Correlate();
        __Save();
        __VedLog("Create \"", __pathVinyl, "\" successful!");
        
        __VedModalOpen(__VedClassModalCreateSuccess).__path = __pathVinyl;
        
        return true;
    }
    
    static __LoadFromGameMakerProject = function(_yyPath, _showPopUp)
    {
        __SetPaths(_yyPath);
        __VedLog("Loading \"", __pathYY, "\" + \"", __pathVinyl, "\"");
        
        if (not __LoadGameMakerProject()) return false;
        if (not __LoadVinylProject()) return false;
        
        __Correlate();
        
        __VedLog("Load successful!");
        if (_showPopUp) __VedModalOpen(__VedClassModalLoadSuccess).__path = __pathYY;
        
        return true;
    }
    
    static __LoadGameMakerProject = function()
    {
        if (not file_exists(__pathYY))
        {
            __VedWarning("GameMaker project doesn't exist");
            __VedModalOpen(__VedClassModalOperationFailed).__path = __pathYY;
            return false;
        }
        
        var _buffer = buffer_load(__pathYY);
        var _string = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        var _json = undefined;
        try
        {
            _json = json_parse(_string);
        }
        catch(_error)
        {
            show_debug_message(_error);
        }
        
        if (_json == undefined)
        {
            __VedWarning("Failed to parse GameMaker project");
            __VedModalOpen(__VedClassModalOperationFailed).__path = __pathYY;
            return false;
        }
        
        //Find audio groups
        var _libYYPAudioGroup = __libAudioGroup;
        var _audioGroupsArray = _json.AudioGroups;
        var _i = 0;
        repeat(array_length(_audioGroupsArray))
        {
            var _name = _audioGroupsArray[_i].name;
            
            var _yypAudioGroup = new __VedClassAudioGroup();
            _yypAudioGroup.__name = _name;
            
            _libYYPAudioGroup.__Add(_name, _yypAudioGroup);
            
            ++_i;
        }
        
        //Unpack sounds assets we find the .yyp file
        var _libYYPAssets = __libYYPAsset;
        var _resourcesArray = _json.resources;
        var _i = 0;
        repeat(array_length(_resourcesArray))
        {
            var _resourceData = _resourcesArray[_i];
            var _id = _resourceData.id;
            var _path = _id.path;
            var _name = _id.name;
            
            if (string_copy(_path, 1, 6) == "sounds")
            {
                var _yypAsset = new __VedClassSound();
                _yypAsset.__partialPath = _path;
                _yypAsset.__name = _name;
                _yypAsset.__EnsureData();
                
                _libYYPAssets.__Add(_name, _yypAsset);
            }
            
            ++_i;
        }
        
        __libYYPAsset.__SortNames(true);
        
        try
        {
            return true;
        }
        catch(_error)
        {
            show_debug_message(_error);
            __VedWarning("Failed to deserialize GameMaker project");
            __VedModalOpen(__VedClassModalOperationFailed).__path = __pathYY;
            return false;
        }
    }
    
    static __EnsureAssetTag = function(_name)
    {
        if (__libAssetTag.__Exists(_name))
        {
            return __libAssetTag.__GetByName(_name);
        }
        else
        {
            var _assetTag = new __VedClassAssetTag();
            _assetTag.__name = _name;
            
            __libAssetTag.__Add(_name, _assetTag);
            return _assetTag
        }
    }
    
    //static __ImportData = function(_projectData, _firstUpdate)
    //{
    //    var _projectDirectory   = __directory;
    //    var _oldSoundDictionary = __soundDictionary;
    //    var _oldSoundArray      = __soundArray;
    //    var _oldSoundHashDict   = __soundHashDict;
    //    var _audioGroupArray    = __audioGroupArray;
    //    var _assetTagArray      = __assetTagArray;
    //    
    //    array_resize(__audioGroupArray, 0);
    //    array_resize(__assetTagArray, 0);
    //    
    //    var _assetTagDict = {};
    //    __assetTagDict = _assetTagDict;
    //    
    //    var _audioGroupDict = {};
    //    __audioGroupDict = _audioGroupDict;
    //    
    //    var _anyChanges = false;
    //    
    //    var _newSoundDict  = {};
    //    var _newSoundArray = [];
    //    
    //    //Find audio groups
    //    var _audioGroupsArray = _projectData.AudioGroups;
    //    var _i = 0;
    //    repeat(array_length(_audioGroupsArray))
    //    {
    //        array_push(_audioGroupArray, _audioGroupsArray[_i].name);
    //        ++_i;
    //    }
    //    
    //    //Iterate over the project and discover all sounds
    //    var _resourcesArray = _projectData.resources;
    //    var _i = 0;
    //    repeat(array_length(_resourcesArray))
    //    {
    //        var _resource = _resourcesArray[_i];
    //        var _path = _resource.id.path;
    //        
    //        if (string_copy(_path, 1, 6) == "sounds")
    //        {
    //            var _soundName = filename_change_ext(filename_name(_path), "");
    //            __VinylTrace("Project: Saw sound \"", _soundName, "\" in project file");
    //        
    //            array_push(_newSoundArray, _soundName);
    //            _newSoundDict[$ _soundName] = _path;
    //        }
    //        
    //        ++_i;
    //    }
    //    
    //    array_sort(_newSoundArray, true);
    //    
    //    //Add any new sounds from the project
    //    var _i = 0;
    //    repeat(array_length(_newSoundArray))
    //    {    
    //        var _soundName = _newSoundArray[_i];
    //        if (variable_struct_exists(_oldSoundDictionary, _soundName))
    //        {
    //            var _newSoundData = _oldSoundDictionary[$ _soundName];
    //            _newSoundData.__CheckYYFile(false);
    //        }
    //        else
    //        {
    //            _anyChanges = true;
    //            
    //            //Try to figure out what type of file the raw data on disk is
    //            var _absolutePath = _projectDirectory + _newSoundDict[$ _soundName];
    //            var _type = __VINYL_SOUND_TYPE.__EXTERNAL_WAV;
    //            
    //            _absolutePath = filename_change_ext(_absolutePath, ".wav");
    //            if (not file_exists(_absolutePath))
    //            {
    //                _absolutePath = filename_change_ext(_absolutePath, ".ogg");
    //                _type = __VINYL_SOUND_TYPE.__EXTERNAL_OGG;
    //                
    //                if (not file_exists(_absolutePath))
    //                {
    //                    __VinylTrace("Project: Warning! Could not find source audio file for \"", _soundName, "\"");
    //                    
    //                    ++_i;
    //                    continue;
    //                }
    //            }
    //            
    //            var _yyPath = filename_change_ext(_absolutePath, ".yy");
    //            
    //            //Get the hash of the file
    //            var _hash = md5_file(_absolutePath);
    //            if (_firstUpdate && (asset_get_type(_soundName) == asset_sound))
    //            {
    //                //Special case for first update
    //                __VinylTrace("Project: Sound \"", _soundName, "\" has been discovered on boot");
    //                var _newSoundData = new __VinylClassProjectSound(__VINYL_SOUND_TYPE.__WAD, _soundName, _yyPath, _absolutePath);
    //                
    //                //Track this new sound
    //                _oldSoundDictionary[$ _soundName] = _newSoundData;
    //                array_push(_oldSoundArray, _soundName);
    //                _oldSoundHashDict[$ _hash] = _newSoundData;
    //            }
    //            else
    //            {
    //                var _oldSoundData = _oldSoundHashDict[$ _hash];
    //                if (is_struct(_oldSoundData))
    //                {
    //                    //Remove the old sound reference but not the hash (since that hasn't changed)
    //                    variable_struct_remove(_oldSoundDictionary, _oldSoundData.__name);
    //                    
    //                    _oldSoundData.__Change(_type, _soundName, _absolutePath);
    //                    
    //                    //Re-add the sound under a new name
    //                    _oldSoundDictionary[$ _soundName] = _oldSoundData;
    //                    
    //                    _newSoundData = _oldSoundData;
    //                }
    //                else
    //                {
    //                    __VinylTrace("Project: Sound \"", _soundName, "\" has been added");
    //                    
    //                    var _newSoundData = new __VinylClassProjectSound(_type, _soundName, _yyPath, _absolutePath);
    //                    
    //                    //Track this new sound
    //                    _oldSoundDictionary[$ _soundName] = _newSoundData;
    //                    array_push(_oldSoundArray, _soundName);
    //                    _oldSoundHashDict[$ _hash] = _newSoundData;
    //                }
    //            }
    //            
    //            _newSoundData.__CheckYYFile(_firstUpdate);
    //        }
    //        
    //        //Build audio group lookup
    //        var _audioGroup = _newSoundData.__audioGroup
    //        if (_audioGroup != undefined)
    //        {
    //            var _soundArray = _audioGroupDict[$ _audioGroup];
    //            if (not is_array(_soundArray))
    //            {
    //                _soundArray = [_soundName];
    //                _audioGroupDict[$ _audioGroup] = _soundArray;
    //            }
    //            else
    //            {
    //                array_push(_soundArray, _soundName);
    //            }
    //        }
    //        
    //        //Build asset tag lookups
    //        var _soundAssetTagArray = _newSoundData.__assetTags;
    //        var _j = 0;
    //        repeat(array_length(_soundAssetTagArray))
    //        {
    //            var _assetTag = _soundAssetTagArray[_j];
    //            
    //            var _soundArray = _assetTagDict[$ _assetTag];
    //            if (not is_array(_soundArray))
    //            {
    //                _soundArray = [_soundName];
    //                _assetTagDict[$ _assetTag] = _soundArray;
    //                array_push(_assetTagArray, _assetTag);
    //            }
    //            else
    //            {
    //                array_push(_soundArray, _soundName);
    //            }
    //            
    //            ++_j;
    //        }
    //        
    //        ++_i;
    //    }
    //    
    //    //Remove any old sounds from the existing sound dictionary
    //    var _i = 0;
    //    repeat(array_length(_oldSoundArray))
    //    {
    //        var _oldSoundName = _oldSoundArray[_i];
    //        if (not variable_struct_exists(_newSoundDict, _oldSoundName))
    //        {
    //            _anyChanges = true;
    //            
    //            var _oldSound = _oldSoundDictionary[$ _oldSoundName];
    //            if (is_struct(_oldSound) && (_oldSound.__name == _oldSoundName))
    //            {
    //                __VinylTrace("Project: Sound \"", _oldSoundName, "\" has been removed");
    //                
    //                //Untrack the old sound
    //                variable_struct_remove(_oldSoundDictionary, _oldSoundName);
    //                array_delete(_oldSoundArray, _i, 1);
    //                variable_struct_remove(_oldSoundHashDict, _oldSound.__hash);
    //                
    //                _oldSound.__Unload();
    //            }
    //            else
    //            {
    //                //Sound was renamed so we don't need to report this, nor do we need to remove the hash
    //                variable_struct_remove(_oldSoundDictionary, _oldSoundName);
    //                array_delete(_oldSoundArray, _i, 1);
    //            }
    //        }
    //        else
    //        {
    //            ++_i;
    //        }
    //    }
    //    
    //    array_sort(__soundArray, true);
    //    array_sort(__assetTagArray, true);
    //    
    //    return _anyChanges;
    //}
    
    static __LoadVinylProject = function()
    {
        if (not file_exists(__pathVinyl))
        {
            __VedWarning("Vinyl project doesn't exist");
            __VedModalOpen(__VedClassModalOperationFailed).__path = __pathVinyl;
            return false;
        }
        
        var _buffer = buffer_load(__pathVinyl);
        var _string = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        var _json = undefined;
        try
        {
            _json = json_parse(_string);
        }
        catch(_error)
        {
            show_debug_message(_error);
        }
        
        if (_json == undefined)
        {
            __VedWarning("Failed to parse Vinyl project");
            __VedModalOpen(__VedClassModalOperationFailed).__path = __pathVinyl;
            return false;
        }
        
        try
        {
            __Deserialize(_json);
            return true;
        }
        catch(_error)
        {
            show_debug_message(_error);
            __VedWarning("Failed to deserialize Vinyl project");
            __VedModalOpen(__VedClassModalOperationFailed).__path = __pathVinyl;
            return false;
        }
    }
    
    static __Unload = function()
    {
        __VedLog("Unloading \"", __pathYY, "\" + \"", __pathVinyl, "\"");
    }
    
    static __Save = function()
    {
        var _output = __Serialize();
        var _string = json_stringify(_output, true);
        
        var _buffer = buffer_create(string_byte_length(_string), buffer_grow, 1);
        buffer_write(_buffer, buffer_text, _string);
        buffer_save(_buffer, __pathVinyl);
        buffer_delete(_buffer);
        
        __Compile();
        
        __VedLog("Save \"", __pathVinyl, "\" successful!");
    }
    
    static __Correlate = function()
    {
        var _yypNameArray = __libYYPAsset.__GetNameArray();
        var _yypDict      = __libYYPAsset.__GetDictionary();
        
        var _vinylNameArray = __libVinylAsset.__GetNameArray();
        var _vinylDict      = __libVinylAsset.__GetDictionary();
        
        var _missingInVinyl = [];
        var _missingInYYP   = [];
        
        var _i = 0;
        repeat(array_length(_yypNameArray))
        {
            var _yypName = _yypNameArray[_i];
            if (not variable_struct_exists(_vinylDict, _yypName))
            {
                __VedLog("\"", _yypName, "\" is missing in Vinyl project");
                array_push(_missingInVinyl, _yypDict[$ _yypName]);
            }
            
            ++_i;
        }
        
        var _i = 0;
        repeat(array_length(_vinylNameArray))
        {
            var _vinylName = _vinylNameArray[_i];
            if (not variable_struct_exists(_yypDict, _vinylName))
            {
                __VedLog("\"", _vinylName, "\" is missing in GameMaker project");
                array_push(_missingInYYP, _vinylDict[$ _vinylName]);
            }
            
            ++_i;
        }
        
        var _i = 0;
        repeat(array_length(_missingInVinyl))
        {
            var _yypAsset = _missingInVinyl[_i];
            __VedLog("Creating Vinyl asset for GameMaker sound \"", _yypAsset.__GetName(), "\"");
            __libVinylAsset.__Add(_yypAsset.__GetName(), _yypAsset.__GenerateVinylAsset());
            ++_i;
        }
    }
    
    static __Compile = function()
    {
        var _buffer = buffer_create(2048, buffer_grow, 1);
        buffer_write(_buffer, buffer_text, "/// Autogenerated on ");
        buffer_write(_buffer, buffer_text, date_datetime_string(date_current_datetime()));
        buffer_write(_buffer, buffer_text, " by Vinyl Editor ");
        buffer_write(_buffer, buffer_text, __VED_VERSION);
        buffer_write(_buffer, buffer_text, ", ");
        buffer_write(_buffer, buffer_text, __VED_DATE);
        buffer_write(_buffer, buffer_text, "\n\n");
        buffer_write(_buffer, buffer_text, "#macro VINYL_VERSIONED_IDENT  \"");
        buffer_write(_buffer, buffer_text, string(__ident));
        buffer_write(_buffer, buffer_text, "\"\n");
        
        //__libPattern.__ForEach(function(_index, _name, _scope, _metadata)
        //{
        //    _scope.__CompileMacro(_metadata.__buffer);
        //},
        //{
        //    __buffer: _buffer,
        //});
        
        buffer_save_ext(_buffer, __pathGenMacros, 0, buffer_tell(_buffer));
        buffer_delete(_buffer);
        
        
        
        var _buffer = buffer_create(2048, buffer_grow, 1);
        buffer_write(_buffer, buffer_text, "/// Autogenerated on ");
        buffer_write(_buffer, buffer_text, date_datetime_string(date_current_datetime()));
        buffer_write(_buffer, buffer_text, " by Vinyl Editor ");
        buffer_write(_buffer, buffer_text, __VED_VERSION);
        buffer_write(_buffer, buffer_text, ", ");
        buffer_write(_buffer, buffer_text, __VED_DATE);
        buffer_write(_buffer, buffer_text, "\n");
        buffer_write(_buffer, buffer_text, "\n");
        buffer_write(_buffer, buffer_text, "function __VinylGenPlay()\n");
        buffer_write(_buffer, buffer_text, "{\n");
        buffer_write(_buffer, buffer_text, "    static _data = undefined;\n");
        buffer_write(_buffer, buffer_text, "    \n");
        buffer_write(_buffer, buffer_text, "    if (_data == undefined)\n");
        buffer_write(_buffer, buffer_text, "    {\n");
        buffer_write(_buffer, buffer_text, "        _data = {};\n");
        buffer_write(_buffer, buffer_text, "        \n");
        
        __libVinylAsset.__ForEach(function(_index, _name, _scope, _metadata)
        {
            _scope.__CompilePlay(_metadata.__buffer);
        },
        {
            __buffer: _buffer,
        });
        
        //__libPattern.__ForEach(function(_index, _name, _scope, _metadata)
        //{
        //    _scope.__CompilePlay(_metadata.__buffer);
        //},
        //{
        //    __buffer: _buffer,
        //});
        
        buffer_write(_buffer, buffer_text, "    }\n");
        buffer_write(_buffer, buffer_text, "    \n");
        buffer_write(_buffer, buffer_text, "    return _data;\n");
        buffer_write(_buffer, buffer_text, "}\n");
        buffer_write(_buffer, buffer_text, "\n");
        
        buffer_save_ext(_buffer, __pathGenPlay, 0, buffer_tell(_buffer));
        buffer_delete(_buffer);
        
        
        
        var _buffer = buffer_create(2048, buffer_grow, 1);
        buffer_write(_buffer, buffer_text, "/// Autogenerated on ");
        buffer_write(_buffer, buffer_text, date_datetime_string(date_current_datetime()));
        buffer_write(_buffer, buffer_text, " by Vinyl Editor ");
        buffer_write(_buffer, buffer_text, __VED_VERSION);
        buffer_write(_buffer, buffer_text, ", ");
        buffer_write(_buffer, buffer_text, __VED_DATE);
        buffer_write(_buffer, buffer_text, "\n");
        buffer_write(_buffer, buffer_text, "\n");
        buffer_write(_buffer, buffer_text, "function __VinylGenPattern()\n");
        buffer_write(_buffer, buffer_text, "{\n");
        buffer_write(_buffer, buffer_text, "    static _data = undefined;\n");
        buffer_write(_buffer, buffer_text, "    \n");
        buffer_write(_buffer, buffer_text, "    if (_data == undefined)\n");
        buffer_write(_buffer, buffer_text, "    {\n");
        buffer_write(_buffer, buffer_text, "        _data = {};\n");
        buffer_write(_buffer, buffer_text, "        \n");
        
        __libVinylAsset.__ForEach(function(_index, _name, _scope, _metadata)
        {
            _scope.__CompilePattern(_metadata.__buffer);
        },
        {
            __buffer: _buffer,
        });
        
        //__libPattern.__ForEach(function(_index, _name, _scope, _metadata)
        //{
        //    _scope.__CompilePattern(_metadata.__buffer);
        //},
        //{
        //    __buffer: _buffer,
        //});
        
        buffer_write(_buffer, buffer_text, "    }\n");
        buffer_write(_buffer, buffer_text, "    \n");
        buffer_write(_buffer, buffer_text, "    return _data;\n");
        buffer_write(_buffer, buffer_text, "}\n");
        buffer_write(_buffer, buffer_text, "\n");
        
        buffer_save_ext(_buffer, __pathGenPattern, 0, buffer_tell(_buffer));
        buffer_delete(_buffer);
    }
}