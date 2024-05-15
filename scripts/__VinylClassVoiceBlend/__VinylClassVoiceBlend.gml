// Feather disable all

/// @param pattern
/// @param gainLocal
/// @param pitchLocal

function __VinylClassVoiceBlend(_pattern, _gainLocal, _pitchLocal) constructor
{
    static _soundDict         = __VinylSystem().__soundDict;
    static _mixDict           = __VinylSystem().__mixDict;
    static _voiceLookUpDict   = __VinylSystem().__voiceLookUpDict;
    static _voiceCleanUpArray = __VinylSystem().__voiceCleanUpArray;
    static _voiceUpdateArray  = __VinylSystem().__voiceUpdateArray;
    static _toUpdateArray     = __VinylSystem().__toUpdateArray;
    
    __inUpdateArray = false;
    
    __pattern    = _pattern;
    __gainLocal  = _gainLocal;
    __pitchLocal = _pitchLocal;
    
    __gainPattern = _pattern.__gain;
    
    if (_pattern.__mixName == undefined)
    {
        var _mixStruct = undefined;
        __gainMix = 1;
    }
    else
    {
        var _mixStruct = _mixDict[$ _pattern.__mixName];
        if (_mixStruct == undefined)
        {
            __VinylError("Mix \"", _pattern.__mixName, "\" not recognised");
            return;
        }
        
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
        var _loop = _pattern.__loop ?? false;
        var _soundGainArray = _pattern.__soundGainArray;
        
        __voiceTop      = audio_play_sound(_soundArray[0], 0, _loop, _soundGainArray[0]*__VINYL_VOICE_GAIN_PxLxMxF/VINYL_MAX_VOICE_GAIN, 0, __pitchLocal);
        __voiceArray[0] = __voiceTop;
        __gainArray[ 0] = _soundGainArray[0];
        
        var _i = 1;
        repeat(__voiceCount - 1)
        {
            __voiceArray[_i] = audio_play_sound(_soundArray[_i], 0, _loop, 0, 0, __pitchLocal);
            __gainArray[ _i] = 0;
            
            ++_i;
        }
    }
    
    if (__voiceTop >= 0)
    {
        __voiceReference = __voiceTop;
        
        array_push(_voiceCleanUpArray, self);
        struct_set_from_hash(_voiceLookUpDict, int64(__voiceReference), self);
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
        var _gainArray   = __gainArray;
        var _blendFactor = __blendFactor;
        
        var _soundGainArray = __pattern.__soundGainArray
        
        if (__blendAnimCurve == undefined)
        {
            //Scale up the blend factor to match the number of channels we have
            var _factor = clamp(__blendFactor, 0, 1)*(__voiceCount - 1);
            
            //Set channels using linear crossfades
            var _i = 0;
            repeat(__voiceCount)
            {
                _gainArray[_i] = _soundGainArray[_i]*max(0, 1 - abs(_i - _factor));
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
                _gainArray[_i] = _soundGainArray[_i]*max(0, animcurve_channel_evaluate(animcurve_get_channel(_animCurve, _i), _blendFactor));
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
        
        var _loop = _pattern.__loop ?? false;
        __gainPattern = _pattern.__gain;
        
        __VinylVoiceMoveMix(__voiceReference, _pattern.__mixName);
        
        if (_pattern.__changedSoundArray)
        {
            var _soundArray = _pattern.__soundArray;
            __voiceCount = array_length(_soundArray);
            
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
                __voiceArray[_i] = audio_sound_loop(__voiceArray[_i], _loop);
                ++_i;
            }
                
            __SetMemberGains();
            __UpdateVoiceGains();
        }
    }
}