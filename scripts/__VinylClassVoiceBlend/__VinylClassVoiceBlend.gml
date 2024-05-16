// Feather disable all

/// @param pattern
/// @param loopLocal
/// @param gainLocal
/// @param pitchLocal
/// @param mixName

function __VinylClassVoiceBlend(_pattern, _loopLocal, _gainLocal, _pitchLocal, _mixName) constructor
{
    static _soundDict        = __VinylSystem().__soundDict;
    static _mixDict          = __VinylSystem().__mixDict;
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    static _voiceUpdateArray = __VinylSystem().__voiceUpdateArray;
    static _toUpdateArray    = __VinylSystem().__toUpdateArray;
    
    __inUpdateArray = false;
    
    __pattern    = _pattern;
    __gainLocal  = _gainLocal;
    __pitchLocal = _pitchLocal;
    __loopLocal  = _loopLocal;
    
    __gainPattern = _pattern.__gain;
    __mixName     = _mixName;
    
    if (_mixName == undefined)
    {
        var _mixStruct = undefined;
        var _mixLoop   = undefined;
        __gainMix = 1;
    }
    else
    {
        var _mixStruct = _mixDict[$ _mixName];
        if (_mixStruct == undefined)
        {
            __VinylError("Mix \"", _mixName, "\" not recognised");
            return;
        }
        
        var _mixLoop = _mixStruct.__membersLoop;
        __gainMix = _mixStruct.__gainFinal;
    }
    
    __gainLocalTarget  = _gainLocal;
    __gainLocalSpeed   = infinity;
    
    __gainFadeOut      = 1;
    __gainFadeOutSpeed = undefined;
    
    __blendFactor    = 0;
    __blendAnimCurve = undefined;
    
    __voiceReference = -1;
    __voiceTop       = -1;
    __voiceArray     = [];
    
    var _soundArray = _pattern.__soundArray;
    __voiceCount = array_length(_soundArray);
    
    if (__voiceCount > 0)
    {
        var _loopFinal = _loopLocal ?? (_pattern.__loop ?? (_mixLoop ?? false));
        var _soundTop  = _soundArray[0];
        var _gainTop   = struct_get_from_hash(_soundDict, int64(_soundTop)).__gain;;
        
        __voiceTop      = audio_play_sound(_soundTop, 0, _loopFinal, _gainTop*__VINYL_VOICE_GAIN_PxLxMxF/VINYL_MAX_VOICE_GAIN, 0, __pitchLocal);
        __voiceArray[0] = __voiceTop;
        __gainArray[ 0] = _gainTop;
        
        var _i = 1;
        repeat(__voiceCount - 1)
        {
            __voiceArray[_i] = audio_play_sound(_soundArray[_i], 0, _loopFinal, 0, 0, __pitchLocal);
            __gainArray[ _i] = 0;
            
            ++_i;
        }
    }
    
    if (__voiceTop >= 0)
    {
        __voiceReference = __voiceTop;
        _voiceToStructMap[? __voiceReference] = self;
        
        if (VINYL_DEBUG_LEVEL >= 2) __VinylTrace("Adding ", __voiceReference, " to voice lookup struct");
        if (_mixStruct != undefined) _mixStruct.__Add(__voiceReference);
    }
    
    
    
    
    
    static __Update = function(_delta)
    {
        var _changed = false;
        
        if (__gainFadeOutSpeed != undefined)
        {
            __gainFadeOut -= _delta*__gainFadeOutSpeed;
            
            if (__gainFadeOut <= 0)
            {
                __Stop();
                return false;
            }
            
            _changed = true;
        }
        
        if (__gainLocal != __gainLocalTarget)
        {
            _changed = true;
            __gainLocal += _delta*clamp(__gainLocalTarget - __gainLocal, -__gainLocalSpeed, __gainLocalSpeed);
        }
        
        if (_changed)
        {
            __UpdateVoiceGains();
        }
        
        return true;
    }
    
    static __UpdateVoiceGains = function()
    {
        var _voiceArray = __voiceArray;
        var _gainArray  = __gainArray;
        var _gainShared = __VINYL_VOICE_GAIN_PxLxMxF;
        
        var _i = 0;
        repeat(__voiceCount)
        {
            audio_sound_gain(_voiceArray[_i], _gainArray[_i]*_gainShared/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
            ++_i;
        }
    }
    
    static __IsPlaying = function()
    {
        return audio_is_playing(__voiceTop);
    }
    
    static __Stop = function()
    {
        if (__voiceTop >= 0)
        {
            __voiceTop = -1;
            
            var _i = 0;
            repeat(array_length(__voiceArray))
            {
                audio_stop_sound(__voiceArray[_i]);
                ++_i;
            }
        }
    }
    
    static __Pause = function()
    {
        var _i = 0;
        repeat(array_length(__voiceArray))
        {
            audio_pause_sound(__voiceArray[_i]);
            ++_i;
        }
    }
    
    static __Resume = function()
    {
        var _i = 0;
        repeat(array_length(__voiceArray))
        {
            audio_resume_sound(__voiceArray[_i]);
            ++_i;
        }
    }
    
    static __IsPaused = function()
    {
        if (__voiceTop < 0) return false;
        return audio_is_paused(__voiceTop);
    }
    
    static __FadeOut = function(_rateOfChange)
    {
        __gainFadeOutSpeed = _rateOfChange;
        
        if (not __inUpdateArray)
        {
            __inUpdateArray = true;
            array_push(_voiceUpdateArray, self);
        }
    }
    
    static __SetLoop = function(_state)
    {
        var _i = 0;
        repeat(__voiceCount)
        {
            audio_sound_loop(__voiceArray[_i], _state);
            ++_i;
        }
    }
    
    static __GetLoop = function()
    {
        return audio_sound_get_loop(__voiceTop);
    }
    
    static __SetLocalGain = function(_gain, _rateOfChange)
    {
        __gainLocalTarget = _gain;
        __gainLocalSpeed  = _rateOfChange;
        
        if (_rateOfChange > 100)
        {
            __gainLocal = _gain;
            __UpdateVoiceGains();
        }
        else
        {
            if (not __inUpdateArray)
            {
                __inUpdateArray = true;
                array_push(_voiceUpdateArray, self);
            }
        }
    }
    
    static __SetMixGain = function(_gain)
    {
        __gainMix = _gain;
        __UpdateVoiceGains();
    }
    
    static __SetBlend = function(_factor)
    {
        _factor = clamp(_factor, 0, 1);
        
        if (_factor != __blendFactor)
        {
            __blendFactor = _factor;
            __SetMemberGains();
            __UpdateVoiceGains();
        }
    }
    
    static __SetBlendAnimCurve = function(_animCurve, _factor)
    {
        if (_animCurve != __blendAnimCurve)
        {
            if (_factor != undefined) __blendFactor = clamp(_factor, 0, 1);
            __blendAnimCurve = _animCurve;
            __SetMemberGains();
            __UpdateVoiceGains();
        }
        else
        {
            __SetBlend(_factor);
        }
    }
    
    static __SetMemberGains = function()
    {
        var _soundArray = __pattern.__soundArray;
        
        var _gainArray   = __gainArray;
        var _blendFactor = __blendFactor;
        
        if (__blendAnimCurve == undefined)
        {
            //Scale up the blend factor to match the number of channels we have
            var _factor = clamp(__blendFactor, 0, 1)*(__voiceCount - 1);
            
            //Set channels using linear crossfades
            var _i = 0;
            repeat(__voiceCount)
            {
                var _gainSound = struct_get_from_hash(_soundDict, int64(_soundArray[_i])).__gain;
                _gainArray[_i] = _gainSound*max(0, 1 - abs(_i - _factor));
                ++_i;
            }
        }
        else
        {
            var _animCurve = __blendAnimCurve;
            
            //Set channels from the animation curve
            var _channelCount = array_length(animcurve_get(_animCurve).channels);
            var _i = 0;
            repeat(min(_channelCount, __voiceCount))
            {
                var _gainSound = struct_get_from_hash(_soundDict, int64(_soundArray[_i])).__gain;
                _gainArray[_i] = _gainSound*max(0, animcurve_channel_evaluate(animcurve_get_channel(_animCurve, _i), _blendFactor));
                ++_i;
            }
            
            //Set remaining channels to 0
            repeat(__voiceCount - _i)
            {
                _gainArray[_i] = 0;
                ++_i;
            }
        }
    }
    
    static __QueueUpdateForSound = function(_sound)
    {
        if (__pattern.__UsesSound(_sound)) array_push(_toUpdateArray, self);
    }
    
    static __UpdateFromPattern = function()
    {
        var _pattern = __pattern;
        
        __gainPattern = _pattern.__gain;
        
        var _mixStruct = __VinylVoiceMoveMix(__voiceReference, _pattern.__mixName);
        var _loopMix = (_mixStruct == undefined)? undefined : _mixStruct.__membersLoop;
        
        var _loop = __loopLocal ?? (_pattern.__loop ?? (_loopMix ?? false));
        
        if (_pattern.__changedSoundArray)
        {
            var _soundArray = _pattern.__soundArray;
            __voiceCount = array_length(_soundArray);
            
            __Stop();
            
            __voiceTop   = -1;
            __voiceArray = [];
            __gainArray  = [];
            
            if (__voiceCount > 0)
            {
                __SetMemberGains();
                
                var _i = 0;
                repeat(__voiceCount)
                {
                    __voiceArray[_i] = audio_play_sound(_soundArray[_i], 0, _loop, __gainArray[_i]/VINYL_MAX_VOICE_GAIN, 0, __pitchLocal);
                    ++_i;
                }
                
                __voiceTop = __voiceArray[0];
            }
        }
        else
        {
            var _i = 0;
            repeat(__voiceCount)
            {
                audio_sound_loop(__voiceArray[_i], _loop);
                ++_i;
            }
            
            __SetMemberGains();
            __UpdateVoiceGains();
        }
    }
}