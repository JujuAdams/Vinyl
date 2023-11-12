// Feather disable all

/// @param documentPath

function __VinylClassDocument(_path) constructor
{
    __documentPath = _path;
    
    __projectDirectory = filename_dir(__documentPath) + "/";
    
    __projectLoaded          = false;
    __projectPath            = GM_project_filename;
    __projectSoundDictionary = {};
    __projectSoundArray      = [];
    __projectSoundHashDict   = {};
    __projectAudioGroupArray = [];
    
    __ProjectLoad();
    __Load(__documentPath);
    
    
    
    static __GetPath = function()
    {
        return __documentPath;
    }
    
    static __GetMacroScriptPath = function()
    {
        var _macroScriptName = __SettingGet("macroScriptName");
        return filename_dir(__documentPath) + "/scripts/" + _macroScriptName + "/" + _macroScriptName + ".gml"
    }
    
    static __Reset = function()
    {
        __dirty = false;
        
        __data = {
            settings: {},
            sounds: {
                "Default": new __VinylClassSoundNew(),
            },
            patterns: {},
            labels: {},
            stacks: {},
            knobs: {},
            effectChains: {},
        };
        
        __assetsCompiled = {};
    }
    
    static __Write = function(_struct, _name, _newValue)
    {
        if (not __VinylGetEditorEnabled()) return;
        if (not variable_struct_exists(_struct, _name))
        {
            __VinylError("Struct variable \"", _name, "\" doesn't exist");
            return;
        }
        
        var _oldValue = _struct[$ _name];
        if (is_array(_oldValue))
        {
            if (not array_equals(_oldValue, _newValue))
            {
                _struct[$ _name] = _newValue;
                __Save();
            }
        }
        else
        {
            if (_oldValue != _newValue)
            {
                _struct[$ _name] = _newValue;
                __Save();
            }
        }
    }
    
    static __Save = function(_immediate = false)
    {
        __dirty = true;
        if (_immediate) __SaveNow();
    }
    
    static __SaveNow = function()
    {
        if (not __VinylGetEditorEnabled()) return;
        if (not __dirty) return;
        
        __dirty = false;
        
        var _string = json_stringify(__data, VINYL_EDITOR_DOCUMENT_SAVE_PRETTY);
        var _buffer = buffer_create(string_byte_length(_string), buffer_fixed, 1);
        buffer_write(_buffer, buffer_text, _string);
        buffer_save(_buffer, __documentPath);
        buffer_delete(_buffer);
    }
    
    static __Load = function()
    {
        if (file_exists(__documentPath))
        {
            try
            {
                var _buffer = buffer_load(__documentPath);
                var _string = buffer_read(_buffer, buffer_text);
                buffer_delete(_buffer);
                
                if (string_length(_string) <= 0) throw "File is empty";
                
                var _firstHundred = string_copy(_string, 1, 200);
                if ((string_pos("{", _firstHundred) > 0) || (string_pos("[", _firstHundred) > 0))
                {
                    __VinylTrace("Reading document \"", __documentPath, "\" in plaintext");
                    __data = json_parse(_string);
                }
                else
                {
                    __VinylTrace("Reading document \"", __documentPath, "\" in base64");
                    
                    _buffer = buffer_base64_decode(_string);
                    _string = buffer_read(_buffer, buffer_text);
                    buffer_delete(_buffer);
                    
                    __data = json_parse(_string);
                }
                
                __dirty = false;
            }
            catch(_error)
            {
                __VinylTrace("Warning! Failed to parse \"", __documentPath, "\", document will be restored to defaults");
                __Reset();
            }
        }
        else
        {
            __VinylTrace("Warning! Couldn't find \"", __documentPath, "\", document will be restored to defaults");
            __Reset();
        }
        
        __SettingsEnsureDefaults();
        __MacroScriptEnsure();
    }
    
    static __MacroScriptEnsure = function()
    {
        //TODO
    }
    
    
    
    
    
    #region Settings
    
    static __SettingsEnsureDefaults = function()
    {
        var _funcEnsure = function(_settings, _settingName, _value)
        {
            if (not variable_struct_exists(_settings, _settingName))
            {
                _settings[$ _settingName] = _value;
            }
        }
        
        _funcEnsure(__data.settings, "autogenerateMacros", __VinylGlobalSettingGet("defaultAutogenerateMacros"));
        _funcEnsure(__data.settings, "macroScriptName", __VinylGlobalSettingGet("defaultMacroScriptName"));
    }
    
    static __SettingSet = function(_settingName, _value)
    {
        var _settings = __data.settings;
        if (not variable_struct_exists(_settings, _settingName))
        {
            __VinylError("Document setting \"", _settingName, "\" not recognised");
        }
        
        if (_settings[$ _settingName] != _value)
        {
            _settings[$ _settingName] = _value;
            __Save();
        }
    }
    
    static __SettingGet = function(_settingName)
    {
        var _settings = __data.settings;
        if (not variable_struct_exists(_settings, _settingName))
        {
            __VinylError("Document setting \"", _settingName, "\" not recognised");
        }
        
        return _settings[$ _settingName];
    }
    
    #endregion
    
    
    
    static __ProjectLoad = function()
    {
        if ((not __VinylGetLiveUpdateEnabled()) || (not __VinylGetRunningFromIDE())) return;
        
        if (!file_exists(__projectPath))
        {
            __VinylError("Could not find \"", __projectPath, "\"\n- Turn on the \"Disable file system sandbox\" game option for this platform");
            return;
        }
        
        var _anyChanges = undefined;
        var _t = get_timer();
        
        try
        {
            var _buffer = buffer_load(__projectPath);
            if (buffer_get_size(_buffer) <= 0) throw "File is empty";
            
            var _string = buffer_read(_buffer, buffer_string);
            var _data = json_parse(_string);
            _anyChanges = __VinylSystemReadProject(self, _data, not __projectLoaded);
            
            __VinylTrace("Loaded project file in ", (get_timer() - _t)/1000, "ms");
            __projectLoaded = true;
        }
        catch(_error)
        {
            show_debug_message("");
            __VinylTrace("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
            __VinylTrace("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
            __VinylTrace(_error.longMessage);
            __VinylTrace(_error.stacktrace);
            __VinylTrace("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
            __VinylTrace("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
            show_debug_message("");
            
            var _trimmedMessage = string_replace(_error.message, "Vinyl:\n", "");
            _trimmedMessage = string_copy(_trimmedMessage, 1, string_length(_trimmedMessage)-2);
            
            if (__projectLoaded)
            {
                _trimmedMessage = string_replace_all(_trimmedMessage, "\n", "\n       ");
                __VinylTrace("There was an error whilst reading \"", __projectPath, "\"");
                __VinylTrace(_trimmedMessage);
            }
            else
            {
                __VinylError("There was an error whilst reading \"", __projectPath, "\"\n \n", _trimmedMessage);
            }
        }
        finally
        {
            buffer_delete(_buffer);
        }
        
        return _anyChanges;
    }
    
    static __ProjectGetLoaded = function()
    {
        return __projectLoaded;
    }
    
    static __ProjectGetSoundDictionary = function()
    {
        return __projectSoundDictionary;
    }
    
    static __ProjectGetSoundArray = function()
    {
        return __projectSoundArray;
    }
    
    static __ProjectGetAudioGroupArray = function()
    {
        return __projectAudioGroupArray;
    }
}