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
    
    __Reset();
    __ProjectLoad();
    __Load(__documentPath);
    
    //Ensure the fallback pattern exists
    if (not variable_struct_exists(__patternDict, __VINYL_FALLBACK_NAME))
    {
        var _fallback = new __VinylClassPatternFallback();
        _fallback.__Store(self);
    }
    
    
    
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
        __dirty     = false;
        __dirtyTime = -infinity;
        
        __soundDict        = {};
        __patternDict      = {};
        __labelAllDict     = {};
        __labelRootDict    = {};
        __effectChainDict  = {};
        __effectChainArray = [];
        __knobDict         = {};
        __stackDict        = {};
        __animCurveDict    = {};
        __animCurveArray   = [];
        
        __settings = {};
        
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
        if (not __dirty)
        {
            __dirty     = true;
            __dirtyTime = current_time;
        }
        
        if (_immediate) __SaveNow();
    }
    
    static __SaveIfNecessary = function()
    {
        if (not __dirty) return;
        if (current_time - __dirtyTime < 5000) return;
        
        __SaveNow();
    }
    
    static __SaveNow = function()
    {
        if (not __VinylGetEditorEnabled()) return;
        if (not __dirty) return;
        
        __dirty     = false;
        __dirtyTime = -infinity;
        
        var _outputJSON = {};
        
        _outputJSON.sounds       = __VinylSerializeArray(__VinylConvertDictToArray(__soundDict      ), undefined);
        _outputJSON.patterns     = __VinylSerializeArray(__VinylConvertDictToArray(__patternDict    ), undefined);
        _outputJSON.labels       = __VinylSerializeArray(__VinylConvertDictToArray(__labelDict      ), undefined);
        _outputJSON.effectChains = __VinylSerializeArray(__VinylConvertDictToArray(__effectChainDict), undefined);
        _outputJSON.knobs        = __VinylSerializeArray(__VinylConvertDictToArray(__knobDict       ), undefined);
        _outputJSON.stacks       = __VinylSerializeArray(__VinylConvertDictToArray(__stackDict      ), undefined);
        _outputJSON.settings     = variable_clone(__settings);
        
        var _string = json_stringify(_outputJSON, VINYL_EDITOR_DOCUMENT_SAVE_PRETTY);
        var _buffer = buffer_create(string_byte_length(_string), buffer_fixed, 1);
        buffer_write(_buffer, buffer_text, _string);
        buffer_save(_buffer, __documentPath);
        buffer_delete(_buffer);
        
        __VinylEditorSetStatusText("Saved \"", __documentPath, "\"");
    }
    
    static __Load = function()
    {
        if (not file_exists(__documentPath))
        {
            __VinylTrace("Warning! Couldn't find \"", __documentPath, "\"");
        }
        else
        {
            try
            {
                var _buffer = buffer_load(__documentPath);
                var _string = buffer_read(_buffer, buffer_text);
                buffer_delete(_buffer);
                
                if (string_length(_string) <= 0) throw "File is empty";
                
                //Figure out whether this is encoded as base64 or in plaintext JSON
                var _firstHundred = string_copy(_string, 1, 200);
                if ((string_pos("{", _firstHundred) > 0) || (string_pos("[", _firstHundred) > 0))
                {
                    __VinylTrace("Reading document \"", __documentPath, "\" in plaintext");
                    var _inputJSON = json_parse(_string);
                }
                else
                {
                    __VinylTrace("Reading document \"", __documentPath, "\" in base64");
                    
                    _buffer = buffer_base64_decode(_string);
                    _string = buffer_read(_buffer, buffer_text);
                    buffer_delete(_buffer);
                    
                    var _inputJSON = json_parse(_string);
                }
                
                //Wipe everything before we get stuck in
                __Reset();
                
                __VinylDeserializeArray(_inputJSON.knobs,        __VinylClassKnob,         self, undefined);
                __VinylDeserializeArray(_inputJSON.effectChains, __VinylClassEffectChain,  self, undefined);
                __VinylDeserializeArray(_inputJSON.stacks,       __VinylClassStack,        self, undefined);
                __VinylDeserializeArray(_inputJSON.labels,       __VinylClassLabel,        self, undefined);
                __VinylDeserializeArray(_inputJSON.sounds,       __VinylClassPatternSound, self, undefined);
                __VinylDeserializePatternArray(_inputJSON.patterns, self, undefined);
                
                //Don't forget the settings
                __settings = variable_clone(_inputJSON.settings);
            }
            catch(_error)
            {
                show_debug_message(_error);
                __VinylTrace("Warning! Failed to parse \"", __documentPath, "\"");
                return;
            }
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
        
        _funcEnsure(__settings, "autogenerateMacros", __VinylGlobalSettingGet("defaultAutogenerateMacros"));
        _funcEnsure(__settings, "macroScriptName", __VinylGlobalSettingGet("defaultMacroScriptName"));
    }
    
    static __SettingSet = function(_settingName, _value)
    {
        var _settings = __settings;
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
        var _settings = __settings;
        if (not variable_struct_exists(_settings, _settingName))
        {
            __VinylError("Document setting \"", _settingName, "\" not recognised");
        }
        
        return _settings[$ _settingName];
    }
    
    #endregion
    
    
    
    static __NewLabel = function(_parent = undefined)
    {
        var _index = 1;
        var _newName = "Unnamed Label " + string(_index);
        while(variable_struct_exists(__labelAllDict, _newName))
        {
            ++_index;
            _newName = "Unnamed Label " + string(_index);
        }
        
        var _new = new __VinylClassLabel();
        _new.__name = _newName;
        _new.__Store(self);
        _new.__ChangeParent(_parent);
        
        return _new;
    }
    
    static __NewPattern = function(_parent = undefined)
    {
        if (is_struct(_parent))
        {
            var _new = new __VinylClassPatternSoundRef();
            array_push(_parent.__childArray, _new);
        }
        else
        {
            var _index = 1;
            var _newName = "Unnamed Label " + string(_index);
            while(variable_struct_exists(__patternDict, _newName))
            {
                ++_index;
                _newName = "Unnamed Label " + string(_index);
            }
            
            var _new = new __VinylClassPatternSoundRef();
            _new.__name = _newName;
            _new.__Store(self);
        }
        
        return _new;
    }
    
    static __NewStack = function()
    {
        var _index = 1;
        var _newName = "Unnamed Stack " + string(_index);
        while(variable_struct_exists(__stackDict, _newName))
        {
            ++_index;
            _newName = "Unnamed Stack " + string(_index);
        }
        
        var _new = new __VinylClassStack();
        _new.__name = _newName;
        _new.__Store(self);
        
        return _new;
    }
    
    static __NewEffectChain = function()
    {
        var _index = 1;
        var _newName = "Unnamed Effect Chain " + string(_index);
        while(variable_struct_exists(__effectChainDict, _newName))
        {
            ++_index;
            _newName = "Unnamed Effect Chain " + string(_index);
        }
        
        var _new = new __VinylClassEffectChain();
        _new.__name = _newName;
        _new.__Store(self);
        
        return _new;
    }
    
    static __NewKnob = function()
    {
        var _index = 1;
        var _newName = "Unnamed Knob " + string(_index);
        while(variable_struct_exists(__knobDict, _newName))
        {
            ++_index;
            _newName = "Unnamed Knob " + string(_index);
        }
        
        var _new = new __VinylClassKnob();
        _new.__name = _newName;
        _new.__Store(self);
        
        return _new;
    }
    
    
    
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