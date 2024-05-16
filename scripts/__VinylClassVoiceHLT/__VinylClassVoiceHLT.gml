// Feather disable all

/// @param pattern
/// @param gainLocal
/// @param pitchLocal

function __VinylClassVoiceHLT(_pattern, _gainLocal, _pitchLocal) constructor
{
    static _mixDict          = __VinylSystem().__mixDict;
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    static _voiceUpdateArray = __VinylSystem().__voiceUpdateArray;
    static _toUpdateArray    = __VinylSystem().__toUpdateArray;
    
    __pattern    = _pattern;
    __gainLocal  = _gainLocal;
    __pitchLocal = _pitchLocal;
    
    __gainSound   = 1;
    __gainPattern = _pattern.__gain;
    
    if (VINYL_LIVE_EDIT)
    {
        __mixName = _pattern.__mixName;
    }
    
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
    
    __gainLocalTarget = _gainLocal;
    __gainLocalSpeed  = infinity;
    
    __gainFadeOut      = 1;
    __gainFadeOutSpeed = undefined;
    
    //Manage which sound to play to begin with
    var _soundHead = _pattern.__soundHead;
    if (_soundHead != undefined)
    {
        __gainSound = __VinylSoundGetGain(_soundHead);
        __voiceCurrent = audio_play_sound(_soundHead, 0, false, __VINYL_VOICE_GAIN_SxPxLxMxF/VINYL_MAX_VOICE_GAIN, 0, __pitchLocal);
        __state = __VINYL_HLT_STATE.__HEAD;
    }
    else
    {
        var _soundLoop = _pattern.__soundLoop;
        if (_soundLoop != undefined)
        {
            __gainSound = __VinylSoundGetGain(_soundLoop);
            __voiceCurrent = audio_play_sound(_soundLoop, 0, true, __VINYL_VOICE_GAIN_SxPxLxMxF/VINYL_MAX_VOICE_GAIN, 0, __pitchLocal);
            __state = __VINYL_HLT_STATE.__LOOP;
        }
        else
        {
            var _soundTail = _pattern.__soundTail;
            __gainSound = __VinylSoundGetGain(_soundTail);
            __voiceCurrent = (_soundTail == undefined)? -1 : audio_play_sound(_soundTail, 0, false, __VINYL_VOICE_GAIN_SxPxLxMxF/VINYL_MAX_VOICE_GAIN, 0, __pitchLocal);
            __state = __VINYL_HLT_STATE.__TAIL;
        }
    }
    
    __voiceReference = __voiceCurrent;
    
    //Add the generated voice to the mix's array of voices
    if (__voiceReference >= 0)
    {
        array_push(_voiceUpdateArray, self);
        
        _voiceToStructMap[? __voiceReference] = self;
        if (VINYL_DEBUG_LEVEL >= 2) __VinylTrace("Adding ", __voiceReference, " to voice lookup struct");
        
        if (_mixStruct != undefined) _mixStruct.__Add(__voiceReference);
    }
    
    __doLoop = true;
    
    
    
    
    
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
        
        if (VinylWillStop(__voiceCurrent))
        {
            switch(__state)
            {
                case __VINYL_HLT_STATE.__HEAD:
                    if (__doLoop && (__pattern.__soundLoop != undefined))
                    {
                        __gainSound = __VinylSoundGetGain(__pattern.__soundLoop);
                        __voiceCurrent = audio_play_sound(__pattern.__soundLoop, 0, true, __VINYL_VOICE_GAIN_SxPxLxMxF/VINYL_MAX_VOICE_GAIN, 0, __pitchLocal);
                        __state = __VINYL_HLT_STATE.__LOOP;
                    }
                    else
                    {
                        __state = __VINYL_HLT_STATE.__TAIL;
                        
                        if (__pattern.__soundTail != undefined)
                        {
                            __gainSound = __VinylSoundGetGain(__pattern.__soundTail);
                            __voiceCurrent = audio_play_sound(__pattern.__soundTail, 0, false, __VINYL_VOICE_GAIN_SxPxLxMxF/VINYL_MAX_VOICE_GAIN, 0, __pitchLocal);
                        }
                        else
                        {
                            __voiceCurrent = -1;
                            return false;
                        }
                    }
                break;
                
                case __VINYL_HLT_STATE.__LOOP:
                    __state = __VINYL_HLT_STATE.__TAIL;
                    
                    if (__pattern.__soundTail != undefined)
                    {
                        __gainSound = __VinylSoundGetGain(__pattern.__soundTail);
                        __voiceCurrent = audio_play_sound(__pattern.__soundTail, 0, false, __VINYL_VOICE_GAIN_SxPxLxMxF/VINYL_MAX_VOICE_GAIN, 0, __pitchLocal);
                    }
                    else
                    {
                        __voiceCurrent = -1;
                        return false;
                    }
                break;
                
                case __VINYL_HLT_STATE.__TAIL:
                    ds_map_delete(_voiceToStructMap, __voiceReference);
                    if (VINYL_DEBUG_LEVEL >= 2) __VinylTrace("Removing ", __voiceReference, " from voice lookup struct");
                    
                    __voiceCurrent = -1;
                    return false;
                break;
            }
        }
        else
        {
            if (_changed)
            {
                audio_sound_gain(__voiceCurrent, __VINYL_VOICE_GAIN_SxPxLxMxF/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
            }
        }
        
        return true;
    }
    
    static __IsPlaying = function()
    {
        return (__voiceCurrent >= 0);
    }
    
    static __Stop = function()
    {
        if (__voiceCurrent >= 0)
        {
            audio_stop_sound(__voiceCurrent);
            __state = __VINYL_HLT_STATE.__TAIL;
        }
    }
    
    static __Pause = function()
    {
        audio_pause_sound(__voiceCurrent);
    }
    
    static __Resume = function()
    {
        audio_resume_sound(__voiceCurrent);
    }
    
    static __IsPaused = function()
    {
        return audio_is_paused(__voiceCurrent);
    }
    
    static __FadeOut = function(_rateOfChange)
    {
        __gainFadeOutSpeed = _rateOfChange;
    }
    
    static __SetLocalGain = function(_gain, _rateOfChange)
    {
        __gainLocalTarget = _gain;
        __gainLocalSpeed  = _rateOfChange;
        
        if (_rateOfChange > 100)
        {
            __gainLocal = _gain;
            audio_sound_gain(__voiceCurrent, __VINYL_VOICE_GAIN_SxPxLxMxF/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
        }
    }
    
    static __SetLoop = function(_state)
    {
        __doLoop = _state;
        if (__state == __VINYL_HLT_STATE.__LOOP) audio_sound_loop(__voiceCurrent, _state);
    }
    
    static __GetLoop = function()
    {
        return audio_sound_get_loop(__voiceCurrent);
    }
    
    static __SetMixGain = function(_gain)
    {
        __gainMix = max(0, _gain);
        audio_sound_gain(__voiceCurrent, __VINYL_VOICE_GAIN_SxPxLxMxF/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
    }
    
    static __QueueUpdateForSound = function(_sound)
    {
        if (__pattern.__UsesSound(_sound)) array_push(_toUpdateArray, self);
    }
    
    static __UpdateFromPattern = function()
    {
        var _pattern = __pattern;
        
        __VinylVoiceMoveMix(__voiceReference, _pattern.__mixName);
        
        __gainPattern = _pattern.__gain;
        
        switch(__state)
        {
            case __VINYL_HLT_STATE.__HEAD:
                __gainSound = __VinylSoundGetGain(_pattern.__soundHead);
                
                if (_pattern.__changedHead)
                {
                    audio_stop_sound(__voiceCurrent);
                    __voiceCurrent = audio_play_sound(_pattern.__soundHead, 0, false, __VINYL_VOICE_GAIN_SxPxLxMxF/VINYL_MAX_VOICE_GAIN, 0, __pitchLocal);
                }
                else
                {
                    audio_sound_gain(__voiceCurrent, __VINYL_VOICE_GAIN_SxPxLxMxF/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
                }
            break;
            
            case __VINYL_HLT_STATE.__LOOP:
                __gainSound = __VinylSoundGetGain(_pattern.__soundLoop);
                
                if (_pattern.__changedLoop)
                {
                    var _loop = audio_sound_get_loop(__voiceCurrent);
                    audio_stop_sound(__voiceCurrent);
                    __voiceCurrent = audio_play_sound(_pattern.__soundLoop, 0, _loop, __VINYL_VOICE_GAIN_SxPxLxMxF/VINYL_MAX_VOICE_GAIN, 0, __pitchLocal);
                }
                else
                {
                    audio_sound_gain(__voiceCurrent, __VINYL_VOICE_GAIN_SxPxLxMxF/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
                }
            break;
            
            case __VINYL_HLT_STATE.__TAIL:
                __gainSound = __VinylSoundGetGain(_pattern.__soundTail);
                
                if (_pattern.__changedTail)
                {
                    audio_stop_sound(__voiceCurrent);
                    __voiceCurrent = audio_play_sound(_pattern.__soundTail, 0, false, __VINYL_VOICE_GAIN_SxPxLxMxF/VINYL_MAX_VOICE_GAIN, 0, __pitchLocal);
                }
                else
                {
                    audio_sound_gain(__voiceCurrent, __VINYL_VOICE_GAIN_SxPxLxMxF/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
                }
            break;
        }
    }
}