// Feather disable all

/// @param mixName
/// @param baseGain

function __VinylClassMix(_mixName, _gainBase) constructor
{
    static _voiceStructDict = __VinylSystem().__voiceStructDict;
    static _soundDict       = __VinylSystem().__soundDict;
    static _patternDict     = __VinylSystem().__patternDict;
    
    __mixName  = _mixName;
    __gainBase = _gainBase;
    
    __gainLocal = 1;
    __gainFinal = _gainBase;
    
    __cleanUpIndex = 0;
    __voiceArray   = [];
    
    static __Update = function()
    {
        var _array = __voiceArray;
        var _length = array_length(_array);
        if (_length > 0)
        {
            var _index = (__cleanUpIndex + 1) mod _length;
            if (not audio_is_playing(_array[_index])) array_delete(_array, _index, 1);
            __cleanUpIndex = _index;
        }
    }
    
    static __UpdateSetup = function(_gainBase)
    {
        __gainBase = _gainBase;
        __UpdateMemberGain();
    }
    
    static __UpdateMemberGain = function()
    {
        var _gainFinal = __gainBase*__gainLocal;
        __gainFinal = _gainFinal;
        
        var _array = __voiceArray;
        var _i = 0;
        repeat(array_length(_array))
        {
            //TODO - Set mix and mix gain here
            __VinylEnsureSoundVoice(_array[_i]).__SetMixGain(_gainFinal);
            ++_i;
        }
    }
    
    static __ClearSetup = function()
    {
        __UpdateSetup(1);
    }
    
    static __Add = function(_voice)
    {
        array_push(__voiceArray, _voice);
    }
    
    static __StopVoices = function()
    {
        var _i = 0;
        repeat(array_length(__voiceArray))
        {
            VinylStop(__voiceArray[_i]);
            ++_i;
        }
    }
    
    static __FadeOutVoices = function(_rateOfChange)
    {
        var _i = 0;
        repeat(array_length(__voiceArray))
        {
            VinylFadeOut(__voiceArray[_i], _rateOfChange);
            ++_i;
        }
    }
    
    static __PauseVoices = function()
    {
        var _i = 0;
        repeat(array_length(__voiceArray))
        {
            VinylPause(__voiceArray[_i]);
            ++_i;
        }
    }
    
    static __ResumeVoices = function()
    {
        var _i = 0;
        repeat(array_length(__voiceArray))
        {
            VinylResume(__voiceArray[_i]);
            ++_i;
        }
    }
    
    static __SetLocalGain = function(_gain)
    {
        __gainLocal = max(0.0, _gain);
        __UpdateMemberGain();
    }
    
    static __ExportJSON = function(_soundExportedDict, _patternExportedDict)
    {
        var _membersArray = [];
        
        
        
        //TODO - Sort
        var _soundMethod = method({
            __mixName:           __mixName,
            __array:             _membersArray,
            __soundExportedDict: _soundExportedDict,
        },
        function(_name, _value)
        {
            if (_value.__mixName == __mixName)
            {
                __soundExportedDict[$ _name] = true;
                
                var _export = _value.__ExportJSON();
                array_push(__array, _export);
            }
        });
        
        struct_foreach(_soundDict, _soundMethod);
        
        
        
        //TODO - Sort
        var _patternMethod = method({
            __mixName:             __mixName,
            __array:               _membersArray,
            __patternExportedDict: _patternExportedDict,
        },
        function(_name, _value)
        {
            if (_value.__mixName == __mixName)
            {
                __patternExportedDict[$ _name] = true;
                
                var _export = _value.__ExportJSON();
                array_push(__array, _export);
            }
        });
        
        struct_foreach(_patternDict, _patternMethod);
        
        
        
        var _struct = {
            mix:      __mixName,
            members:  _membersArray,
        };
        
        if (__gainBase != 1)
        {
            _struct.baseGain = __gainBase;
        }
        
        return _struct;
    }
    
    static __ExportGML = function(_buffer, _useMacros, _soundExportedDict, _patternExportedDict)
    {
        buffer_write(_buffer, buffer_text, "    {\n");
        buffer_write(_buffer, buffer_text, "        mix: ");
        
        if (_useMacros)
        {
            buffer_write(_buffer, buffer_text, __VinylGetMixMacro(__mixName));
            buffer_write(_buffer, buffer_text, ",\n");
        }
        else
        {
            buffer_write(_buffer, buffer_text, "\"");
            buffer_write(_buffer, buffer_text, __mixName);
            buffer_write(_buffer, buffer_text, "\",\n");
        }
        
        if (__gainBase != 1)
        {
            buffer_write(_buffer, buffer_text, "        baseGain: ");
            buffer_write(_buffer, buffer_text, __gainBase);
            buffer_write(_buffer, buffer_text, ",\n");
        }
        
        buffer_write(_buffer, buffer_text, "        members: [\n");
        
        
        
        //TODO - Sort
        var _patternMethod = method({
            __buffer:              _buffer,
            __mixName:             __mixName,
            __useMacros:    _useMacros,
            __patternExportedDict: _patternExportedDict,
        },
        function(_name, _value)
        {
            if (_value.__mixName == __mixName)
            {
                __patternExportedDict[$ _name] = true;
                _value.__ExportGML(__buffer, "            ", __useMacros);
            }
        });
        
        struct_foreach(_patternDict, _patternMethod);
        
        
        
        //TODO - Sort
        var _soundMethod = method({
            __buffer:            _buffer,
            __mixName:           __mixName,
            __soundExportedDict: _soundExportedDict,
        },
        function(_name, _value)
        {
            if (_value.__mixName == __mixName)
            {
                __soundExportedDict[$ _name] = true;
                _value.__ExportGML(__buffer, "            ");
            }
        });
        
        struct_foreach(_soundDict, _soundMethod);
        
        
        
        buffer_write(_buffer, buffer_text, "        ],\n    },\n");
    }
}

function __VinylImportMixGroupJSON(_json)
{
    if (VINYL_SAFE_JSON_IMPORT)
    {
        var _variableNames = struct_get_names(_json);
        var _i = 0;
        repeat(array_length(_variableNames))
        {
            switch(_variableNames[_i])
            {
                case "mix":
                case "baseGain":
                case "members":
                break;
                
                default:
                    __VinylError("Mix property .", _variableNames[_i], " not supported");
                break;
            }
            
            ++_i;
        }
    }
    
    VinylSetupMix(_json.mix, _json[$ "baseGain"]);
    
    var _membersArray = _json[$ "members"];
    if (is_array(_membersArray))
    {
        var _i = 0;
        repeat(array_length(_membersArray))
        {
            var _memberData = _membersArray[_i];
            
            var _return = VinylSetupImportJSON(_memberData);
            if (_return != undefined) VinylSetMixForAssets(_json.mix, _return);
            
            ++_i;
        }
    }
    
    return _json.mix;
}