// Feather disable all

/// @param patternName
/// @param soundArray
/// @param gainMin
/// @param gainMax
/// @param pitchMin
/// @param pitchMax
/// @param mix

function __VinylClassPatternShuffle(_patternName, _soundArray, _gainMin, _gainMax, _pitchMin, _pitchMax, _mix) constructor
{
    static _voiceCleanUpArray = __VinylSystem().__voiceCleanUpArray;
    static _mixDict           = __VinylSystem().__mixDict;
    
    __patternName = _patternName;
    
    __soundArray = __VinylImportSoundArray(_soundArray);
    __gainMin    = _gainMin;
    __gainMax    = _gainMax;
    __pitchMin   = _pitchMin;
    __pitchMax   = _pitchMax;
    
    __gainRandomize  = (_gainMin != _gainMax);
    __pitchRandomize = (_pitchMin != _pitchMax);
    
    __SetMix(_mix);
    
    __soundCount = array_length(__soundArray);
    __playIndex  = infinity;
    
    static __Play = function(_loopLocal, _gainLocal, _pitchLocal)
    {
        if (__playIndex >= __soundCount) //If we've played through our bank of sounds, reshuffle
        {
            __playIndex = 0;
            var _last = __soundArray[__soundCount-1];
            array_delete(__soundArray, __soundCount-1, 1); //Make sure we don't reshuffle in the last played sound...
            __VinylArrayShuffle(__soundArray);
            array_insert(__soundArray, __soundCount div 2, _last); //...and stick it somewhere in the middle instead
        }
        
        var _sound = __soundArray[__playIndex];
        ++__playIndex;
        
        var _loopFinal = _loopLocal ?? false;
        
        if (__gainRandomize)
        {
            var _gainFactor = __VinylRandom(1);
            var _gainBase   = lerp(__gainMin,  __gainMax,  _gainFactor);
        }
        else
        {
            var _gainFactor = 0.5;
            var _gainBase   = __gainMin;
        }
        
        if (__pitchRandomize)
        {
            var _pitchFactor = __VinylRandom(1);
            var _pitchBase   = lerp(__pitchMin, __pitchMax, _pitchFactor);
        }
        else
        {
            var _pitchFactor = 0.5;
            var _pitchBase   = __pitchMin;
        }
        
        if (__noMix)
        {
            var _voice = audio_play_sound(_sound, 0, _loopFinal, _gainBase*_gainLocal/VINYL_MAX_VOICE_GAIN, 0, _pitchBase*_pitchLocal);
            var _gainMix = 1;
        }
        else
        {
            var _mixStruct = _mixDict[$ __mixName];
            if (_mixStruct == undefined)
            {
                __VinylError("Mix \"", __mixName, "\" not recognised");
                return;
            }
            
            var _gainMix = _mixStruct.__gainFinal;
            var _voice = audio_play_sound(_sound, 0, _loopFinal, _gainBase*_gainLocal*_gainMix/VINYL_MAX_VOICE_GAIN, 0, _pitchBase*_pitchLocal);
            _mixStruct.__Add(_voice);
        }
        
        //If we're in live edit mode then always create a struct representation
        if (VINYL_LIVE_EDIT)
        {
            new __VinylClassVoiceSound(_voice, _loopLocal, _gainBase, _gainLocal, _gainMix, _pitchBase, _pitchLocal, self, _gainFactor, _pitchFactor);
        }
        
        return _voice;
    }
    
    static __UpdateSetup = function(_soundArray, _gainMin, _gainMax, _pitchMin, _pitchMax, _mix)
    {
        __soundArray = __VinylImportSoundArray(_soundArray);
        __gainMin    = _gainMin;
        __gainMax    = _gainMax;
        __pitchMin   = _pitchMin;
        __pitchMax   = _pitchMax;
        
        __gainRandomize  = (_gainMin != _gainMax);
        __pitchRandomize = (_pitchMin != _pitchMax);
        
        __soundCount = array_length(__soundArray);
        __playIndex  = infinity;
        
        __SetMix(_mix);
        
        if (VINYL_LIVE_EDIT)
        {
            var _i = 0;
            repeat(array_length(_voiceCleanUpArray))
            {
                var _voiceStruct = _voiceCleanUpArray[_i];
                if (_voiceStruct.__pattern == self)
                {
                    _voiceStruct.__SetFromPattern(_gainMin, _gainMax, _pitchMin, _pitchMax, false, _mix);
                }
                
                ++_i;
            }
        }
    }
    
    static __SetMix = function(_mix)
    {
        __mixName = _mix;
        __noMix   = (_mix == undefined) || (_mix == VINYL_NO_MIX);
    }
    
    static __ClearSetup = function()
    {
        __UpdateSetup(__soundArray, 1, 1, 1, 1, VINYL_DEFAULT_MIX);
    }
    
    static __ExportJSON = function()
    {
        var _soundArray = [];
        var _i = 0;
        repeat(array_length(__soundArray))
        {
            array_push(_soundArray, audio_get_name(__soundArray[_i]));
            ++_i;
        }
        
        var _struct = {
            shuffle: __patternName,
            sounds: _soundArray,
        };
        
        if ((__gainMin != 1) || (__gainMax != 1))
        {
            if (__gainMin == __gainMax)
            {
                _struct.gain = __gainMin;
            }
            else
            {
                _struct.gain = [__gainMin, __gainMax];
            }
        }
        
        if ((__pitchMin != 1) || (__pitchMax != 1))
        {
            if (__pitchMin == __pitchMax)
            {
                _struct.pitch = __pitchMin;
            }
            else
            {
                _struct.pitch = [__pitchMin, __pitchMax];
            }
        }
        
        return _struct;
    }
    
    static __ExportGML = function(_buffer, _indent, _useMacros)
    {
        buffer_write(_buffer, buffer_text, _indent);
        buffer_write(_buffer, buffer_text, "{\n");
        
        buffer_write(_buffer, buffer_text, _indent);
        buffer_write(_buffer, buffer_text, "    shuffle: ");
        
        if (_useMacros)
        {
            buffer_write(_buffer, buffer_text, __VinylGetPatternMacro(__patternName));
            buffer_write(_buffer, buffer_text, ",\n");
        }
        else
        {
            buffer_write(_buffer, buffer_text, "\"");
            buffer_write(_buffer, buffer_text, __patternName);
            buffer_write(_buffer, buffer_text, "\",\n");
        }
        
        buffer_write(_buffer, buffer_text, _indent);
        buffer_write(_buffer, buffer_text, "    sounds: [");
        
        if (array_length(__soundArray) > 0)
        {
            var _i = 0;
            repeat(array_length(__soundArray))
            {
                buffer_write(_buffer, buffer_text, audio_get_name(__soundArray[_i]));
                buffer_write(_buffer, buffer_text, ", ");
                ++_i;
            }
            
            buffer_seek(_buffer, buffer_seek_relative, -2);
        }
        
        buffer_write(_buffer, buffer_text, "],\n");
        
        if ((__gainMin != 1) || (__gainMax != 1))
        {
            if (__gainMin == __gainMax)
            {
                buffer_write(_buffer, buffer_text, _indent);
                buffer_write(_buffer, buffer_text, "    gain: ");
                buffer_write(_buffer, buffer_text, __gainMin);
                buffer_write(_buffer, buffer_text, ",\n");
            }
            else
            {
                buffer_write(_buffer, buffer_text, _indent);
                buffer_write(_buffer, buffer_text, "    gain: [");
                buffer_write(_buffer, buffer_text, __gainMin);
                buffer_write(_buffer, buffer_text, ", ");
                buffer_write(_buffer, buffer_text, __gainMax);
                buffer_write(_buffer, buffer_text, "],\n");
            }
        }
        
        if ((__pitchMin != 1) || (__pitchMax != 1))
        {
            if (__pitchMin == __pitchMax)
            {
                buffer_write(_buffer, buffer_text, _indent);
                buffer_write(_buffer, buffer_text, "    pitch: ");
                buffer_write(_buffer, buffer_text, __pitchMin);
                buffer_write(_buffer, buffer_text, ",\n");
            }
            else
            {
                buffer_write(_buffer, buffer_text, _indent);
                buffer_write(_buffer, buffer_text, "    pitch: [");
                buffer_write(_buffer, buffer_text, __pitchMin);
                buffer_write(_buffer, buffer_text, ", ");
                buffer_write(_buffer, buffer_text, __pitchMax);
                buffer_write(_buffer, buffer_text, "],\n");
            }
        }
        
        buffer_write(_buffer, buffer_text, _indent);
        buffer_write(_buffer, buffer_text, "},\n");
    }
}

function __VinylImportShuffleJSON(_json)
{
    if (VINYL_SAFE_JSON_IMPORT)
    {
        var _variableNames = struct_get_names(_json);
        var _i = 0;
        repeat(array_length(_variableNames))
        {
            switch(_variableNames[_i])
            {
                case "shuffle":
                case "sounds":
                case "gain":
                case "pitch":
                break;
                
                default:
                    __VinylError("Shuffle pattern property .", _variableNames[_i], " not supported");
                break;
            }
            
            ++_i;
        }
        
        if (not struct_exists(_json, "sounds")) __VinylError("Shuffle pattern \"", _json.shuffle, "\" property .sounds must be defined");
    }
    
    VinylSetupShuffle(_json.shuffle, _json.sounds, _json[$ "gain"], _json[$ "pitch"]);
    
    return _json.shuffle;
}