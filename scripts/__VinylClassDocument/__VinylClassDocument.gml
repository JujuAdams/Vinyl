// Feather disable all

/// @param documentPath

function __VinylClassDocument(_path) constructor
{
    __documentPath = _path;
    
    __subscriberDict = {};
    
    
    
    __Reset();
    
    __project = new __VinylClassProject();
    __project.__SetPath(GM_project_filename);
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
        _outputJSON.labels       = __VinylSerializeArray(__VinylConvertDictToArray(__labelRootDict  ), undefined);
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
    
    static __ProjectLoad = function()
    {
        __project.__Load();
    }
    
    static __MacroScriptEnsure = function()
    {
        //TODO
    }
    
    
    
    #region Pub/Sub
    
    static __Subscribe = function(_message, _scope, _method)
    {
        var _array = __subscriberDict[$ _message];
        if (not is_array(_array))
        {
            _array = [];
            __subscriberDict[$ _message] = _array;
        }
        
        array_push(_array, weak_ref_create(_scope), weak_ref_create(_method));
    }
    
    static __Unsubscribe = function(_message, _scope)
    {
        var _array = __subscriberDict[$ _message];
        if (not is_array(_array)) return;
        
        var _i = 0;
        repeat(array_length(_array) div 2)
        {
            if (_array[_i].ref == _scope)
            {
                array_delete(_array, _i, 2);
            }
            else
            {
                _i += 2;
            }
        }
    }
    
    static __Publish = function(_message, _arg0, _arg1, _arg2, _arg3)
    {
        var _array = __subscriberDict[$ _message];
        if (not is_array(_array)) return;
        
        var _i = 0;
        repeat(array_length(_array) div 2)
        {
            var _scope  = _array[_i  ];
            var _method = _array[_i+1];
            
            if (weak_ref_alive(_scope) && weak_ref_alive(_method))
            {
                with(_scope.ref)
                {
                    _method.ref(_arg0, _arg1, _arg2, _arg3);
                }
                
                _i += 2;
            }
            else
            {
                array_delete(_array, _i, 2);
            }
        }
    }
    
    #endregion
    
    
    
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
    
    
    
    #region Getters
    
    static __GetProjectPath = function()
    {
        return __project.__GetPath();
    }
    
    static __GetProjectLoaded = function()
    {
        return __project.__GetLoaded();
    }
    
    static __GetProjectSoundDictionary = function()
    {
        return __project.__GetSoundDictionary();
    }
    
    static __GetProjectSoundArray = function()
    {
        return __project.__GetSoundArray();
    }
    
    static __GetProjectAudioGroupArray = function()
    {
        return __project.__GetAudioGroupArray();
    }
    
    static __GetProjectAudioGroupDict = function()
    {
        return __project.__GetAudioGroupDict();
    }
    
    static __GetProjectAssetTagDict = function()
    {
        return __project.__GetAssetTagDict();
    }
    
    static __GetProjectAssetTagArray = function()
    {
        return __project.__GetAssetTagArray();
    }
    
    #endregion
    
    
    
    static __GetPattern = function(_uuid)
    {
        return __patternDict[$ _uuid];
    }
    
    
    
    static __NewSound = function(_soundName)
    {
        var _new = new __VinylClassPatternSound();
        _new.__name  = _soundName;
        _new.__sound = asset_get_index(_soundName);
        _new.__Store(self, undefined);
        
        __Save();
        
        return _new;
    }
    
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
        
        __Save();
        
        return _new;
    }
    
    static __NewPattern = function(_parent = undefined)
    {
        var _new = new __VinylClassPatternBasic();
        
        if (not is_struct(_parent))
        {
            var _index = 1;
            var _newName = "Unnamed Pattern " + string(_index);
            while(variable_struct_exists(__patternDict, _newName))
            {
                ++_index;
                _newName = "Unnamed Pattern " + string(_index);
            }
            
            _new.__name = _newName;
        }
        
        _new.__Store(self, _parent);
        __Save();
        
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
        
        __Save();
        
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
        
        __Save();
        
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
        
        __Save();
        
        return _new;
    }
}