// Feather disable all

/// @param mixName
/// @param baseGain
/// @param membersLoop
/// @param membersDuckOn
/// @param membersEmitterAlias
/// @param metadata

function __VinylClassMix(_mixName, _gainPattern, _membersLoop, _membersDuckOn, _membersEmitterAlias, _metadata) constructor
{
    static _toUpdateArray = __VinylSystem().__toUpdateArray;
    static _soundMap      = __VinylSystem().__soundMap;
    static _patternMap    = __VinylSystem().__patternMap;
    
    __mixName             = _mixName;
    __gainPattern         = _gainPattern;
    __membersLoop         = _membersLoop;
    __membersDuckOn       = _membersDuckOn;
    __membersEmitterAlias = _membersEmitterAlias;
    __metadata            = _metadata;
    
    __gainLocal = 1;
    __gainFinal = _gainPattern;
    
    __gainLocalTarget = 1;
    __gainLocalSpeed  = infinity;
    
    __pitchLocal       = 1;
    __pitchLocalTarget = __pitchLocal;
    __pitchLocalSpeed  = infinity;
    
    __cleanUpIndex = 0;
    __voiceArray   = [];
    
    
    
    
    
    static __Update = function(_delta)
    {
        if (__gainLocal != __gainLocalTarget)
        {
            __gainLocal += clamp(__gainLocalTarget - __gainLocal, -_delta*__gainLocalSpeed, _delta*__gainLocalSpeed);
            __UpdateMemberGain();
        }
        
        if (__pitchLocal != __pitchLocalTarget)
        {
            __pitchLocal += clamp(__pitchLocalTarget - __pitchLocal, -_delta*__pitchLocalSpeed, _delta*__pitchLocalSpeed);
            __UpdateMemberPitch();
        }
        
        var _array = __voiceArray;
        var _index = __cleanUpIndex;
        var _length = array_length(_array);
        repeat(lerp(min(1, _length), _length, min(1, VinylGetSystemPressure())))
        {
            var _index = (_index + 1) mod _length;
            if (not VinylIsPlaying(_array[_index]))
            {
                array_delete(_array, _index, 1);
                --_length;
            }
        }
        
        __cleanUpIndex = _index;
    }
    
    static __UpdateSetup = function(_gainPattern, _membersLoop, _membersDuckOn)
    {
        if (VINYL_LIVE_EDIT)
        {
            array_push(_toUpdateArray, self);
        }
        
        __gainPattern = _gainPattern;
        __membersLoop = _membersLoop;
        
        __UpdateMemberGain();
    }
    
    static __UpdateMemberGain = function()
    {
        var _gainFinal = __gainPattern*__gainLocal;
        __gainFinal = _gainFinal;
        
        var _array = __voiceArray;
        var _i = 0;
        repeat(array_length(_array))
        {
            __VinylEnsureSoundVoice(_array[_i]).__SetMixGain(_gainFinal);
            ++_i;
        }
    }
    
    static __UpdateMemberPitch = function()
    {
        var _pitchFinal = __pitchLocal;
        
        var _array = __voiceArray;
        var _i = 0;
        repeat(array_length(_array))
        {
            __VinylEnsureSoundVoice(_array[_i]).__SetMixPitch(_pitchFinal);
            ++_i;
        }
    }
    
    static __ClearSetup = function()
    {
        __UpdateSetup(1, false, undefined);
    }
    
    static __Add = function(_voice)
    {
        array_push(__voiceArray, _voice);
    }
    
    static __Remove = function(_voice)
    {
        var _index = array_get_index(__voiceArray, _voice);
        if (_index >= 0) array_delete(__voiceArray, _index, 1);
    }
    
    static __VoicesStop = function()
    {
        var _i = 0;
        repeat(array_length(__voiceArray))
        {
            VinylStop(__voiceArray[_i]);
            ++_i;
        }
    }
    
    static __VoicesFadeOut = function(_rateOfChange, _pause)
    {
        var _i = 0;
        repeat(array_length(__voiceArray))
        {
            VinylFadeOut(__voiceArray[_i], _rateOfChange, _pause);
            ++_i;
        }
    }
    
    static __VoicesSetPause = function(_state)
    {
        if (_state)
        {
            var _i = 0;
            repeat(array_length(__voiceArray))
            {
                VinylSetPause(__voiceArray[_i], _state);
                ++_i;
            }
        }
        else
        {
            var _i = 0;
            repeat(array_length(__voiceArray))
            {
                VinylResume(__voiceArray[_i]);
                ++_i;
            }
        }
    }
    
    static __SetLocalGain = function(_gain, _rateOfChange)
    {
        __gainLocalTarget = _gain;
        __gainLocalSpeed  = _rateOfChange;
        
        if (_rateOfChange > 100)
        {
            __gainLocal = _gain;
            __UpdateMemberGain();
        }
    }
    
    static __SetLocalPitch = function(_pitch, _rateOfChange)
    {
        __pitchLocalTarget = _pitch;
        __pitchLocalSpeed  = _rateOfChange;
        
        if (_rateOfChange > 100)
        {
            __pitchLocal = _pitch;
            __UpdateMemberPitch();
        }
    }
    
    static __ExportJSON = function(_soundExportedDict, _patternExportedDict, _ignoreEmpty)
    {
        var _membersArray = [];
        var _mixName = __mixName;
        
        //Add patterns to the mix members
        var _namesArray = ds_map_keys_to_array(_patternMap);
        array_sort(_namesArray, true);
        
        var _i = 0;
        repeat(array_length(_namesArray))
        {
            var _name = _namesArray[_i];
            
            var _pattern = _patternMap[? _name];
            if (_pattern.__mixName == _mixName)
            {
                _patternExportedDict[$ _name] = true;
                array_push(_membersArray, _pattern.__ExportJSON());
            }
            
            ++_i;
        }
        
        //Add sounds to the mix members
        var _namesArray = ds_map_keys_to_array(_soundMap);
        array_sort(_namesArray, true);
        
        var _i = 0;
        repeat(array_length(_namesArray))
        {
            var _name = _namesArray[_i];
            
            var _pattern = _soundMap[? _name];
            if (_pattern.__mixName == _mixName)
            {
                _soundExportedDict[$ _name] = true;
                
                var _struct = _pattern.__ExportJSON(_ignoreEmpty);
                if (_struct != undefined) array_push(_membersArray, _struct);
            }
            
            ++_i;
        }
        
        //Finalize the output struct
        var _struct = {
            mix:      __mixName,
            members:  _membersArray,
        };
        
        if (__gainPattern != 1)
        {
            _struct.baseGain = __gainPattern;
        }
        
        if (__membersLoop != undefined)
        {
            _struct.membersLoop = __membersLoop;
        }
        
        return _struct;
    }
    
    static __ExportGML = function(_buffer, _useMacros, _soundExportedDict, _patternExportedDict, _ignoreEmpty)
    {
        //Write basic mix info
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
        
        if (__gainPattern != 1)
        {
            buffer_write(_buffer, buffer_text, "        baseGain: ");
            buffer_write(_buffer, buffer_text, __gainPattern);
            buffer_write(_buffer, buffer_text, ",\n");
        }
        
        if (__membersLoop != undefined)
        {
            buffer_write(_buffer, buffer_text, "        membersLoop: ");
            buffer_write(_buffer, buffer_text, __membersLoop? "true" : "false");
            buffer_write(_buffer, buffer_text, ",\n");
        }
        
        buffer_write(_buffer, buffer_text, "        members: [\n");
        
        var _namesArray = [];
        var _mixName = __mixName;
        
        //Add patterns to the mix members
        var _namesArray = ds_map_keys_to_array(_patternMap);
        array_sort(_namesArray, true);
        
        var _i = 0;
        repeat(array_length(_namesArray))
        {
            var _name = _namesArray[_i];
            
            var _pattern = _patternMap[? _name];
            if (_pattern.__mixName == _mixName)
            {
                _patternExportedDict[$ _name] = true;
                _pattern.__ExportGML(_buffer, "            ", _useMacros);
            }
            
            ++_i;
        }
        
        //Add sounds to the mix members
        var _namesArray = ds_map_keys_to_array(_soundMap);
        array_sort(_namesArray, true);
        
        var _i = 0;
        repeat(array_length(_namesArray))
        {
            var _name = _namesArray[_i];
            
            var _pattern = _soundMap[? _name];
            if (_pattern.__mixName == _mixName)
            {
                _soundExportedDict[$ _name] = true;
                _pattern.__ExportGML(_buffer, "            ", _ignoreEmpty);
            }
            
            ++_i;
        }
        
        //And done!
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
                case "membersLoop":
                case "membersDuckOn":
                case "membersEmitter":
                case "members":
                case "metadata":
                break;
                
                default:
                    __VinylError("Mix property .", _variableNames[_i], " not supported");
                break;
            }
            
            ++_i;
        }
    }
    
    VinylSetupMix(_json.mix, _json[$ "baseGain"], _json[$ "membersLoop"], _json[$ "membersDuckOn"], _json[$ "membersEmitter"], _json[$ "metadata"]);
    
    var _membersArray = _json[$ "members"];
    if (is_array(_membersArray))
    {
        var _i = 0;
        repeat(array_length(_membersArray))
        {
            var _memberData = _membersArray[_i];
            
            var _return = __VinylSetupImportJSONInner(_memberData);
            if (_return != undefined) VinylSetMixForAssets(_json.mix, _return);
            
            ++_i;
        }
    }
    
    return _json.mix;
}