// Feather disable all

/// @param voice
/// @param loopLocal
/// @param gainLocal
/// @param gainMix
/// @param gainDuck
/// @param pitchLocal
/// @param pitchMix

function __VinylClassVoiceAbstract(_voice, _loopLocal, _gainLocal, _gainMix, _gainDuck, _pitchLocal, _pitchMix) constructor
{
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    static _voiceUpdateArray = __VinylSystem().__voiceUpdateArray;
    
    __inUpdateArray = false;
    
    __voiceReference = _voice;
    __playing = true;
    __paused  = false;
    __looping = _loopLocal;
    
    __gainLocal = _gainLocal;
    __gainMix   = _gainMix;
    __gainDuck  = _gainDuck;
    
    __pitchLocal = _pitchLocal;
    __pitchMix   = _pitchMix;
    
    __gainLocalTarget = _gainLocal;
    __gainLocalSpeed  = infinity;
    
    __gainDuckTarget = _gainDuck;
    __gainDuckSpeed  = undefined;
    
    __gainFadeOut      = 1;
    __gainFadeOutSpeed = undefined;
    __gainFadeOutStop  = false;
    
    __pitchLocalTarget = _pitchLocal;
    __pitchLocalSpeed  = infinity;
    
    _voiceToStructMap[? _voice] = self;
    array_push(_voiceUpdateArray, self);
    
    
    
    
    
    static __GetAsset = function()
    {
        return undefined;
    }
    
    static __GetGameMakerVoice = function()
    {
        return undefined;
    }
    
    static __IsPlaying = function()
    {
        return __playing;
    }
    
    static __WillStop = function()
    {
        return not __playing;
    }
    
    static __Stop = function()
    {
        __playing = false;
    }
    
    static __SetPause = function(_state)
    {
        __paused = _state;
    }
    
    static __IsPaused = function()
    {
        return __paused;
    }
    
    static __Update = function(_delta)
    {
        if (__gainLocal != __gainLocalTarget)
        {
            __gainLocal += clamp(__gainLocalTarget - __gainLocal, -_delta*__gainLocalSpeed, _delta*__gainLocalSpeed);
        }
        
        if (__gainDuckSpeed != undefined)
        {
            __gainDuck += clamp(__gainDuckTarget - __gainDuck, -_delta*__gainDuckSpeed, _delta*__gainDuckSpeed);
        }
        
        if (__gainFadeOutSpeed != undefined)
        {
            __gainFadeOut -= _delta*__gainFadeOutSpeed;
            
            if (__gainFadeOut <= 0)
            {
                if (__gainFadeOutStop)
                {
                    __Stop();
                    return;
                }
                else
                {
                    __gainFadeOut      = 1;
                    __gainFadeOutSpeed = undefined;
                    __SetPause(true);
                }
            }
        }
        
        if (__pitchLocal != __pitchLocalTarget)
        {
            __pitchLocal += clamp(__pitchLocalTarget - __pitchLocal, -_delta*__pitchLocalSpeed, _delta*__pitchLocalSpeed);
        }
        
        return true;
    }
    
    static __FadeOut = function(_rateOfChange, _pause)
    {
        if (__gainFadeOutStop != true)
        {
            if (not __inUpdateArray)
            {
                __inUpdateArray = true;
                array_push(_voiceUpdateArray, self);
            }
            
            __gainFadeOutSpeed = _rateOfChange;
            __gainFadeOutStop  = not _pause;
        }
    }
    
    static __Duck = function(_targetGain, _rateOfChange)
    {
        if (_targetGain != __gainDuckTarget)
        {
            if (not __inUpdateArray)
            {
                __inUpdateArray = true;
                array_push(_voiceUpdateArray, self);
            }
            
            __gainDuckSpeed  = _rateOfChange;
            __gainDuckTarget = _targetGain;
        }
    }
    
    static __SetLoop = function(_state)
    {
        __looping = _state;
    }
    
    static __GetLoop = function()
    {
        return __looping;
    }
    
    static __SetLocalGain = function(_gain, _rateOfChange)
    {
        __gainLocalTarget = _gain;
        __gainLocalSpeed  = _rateOfChange;
        
        if (_rateOfChange > 100)
        {
            __gainLocal = _gain;
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
    }
    
    static __SetLocalPitch = function(_pitch, _rateOfChange)
    {
        __pitchLocalTarget = _pitch;
        __pitchLocalSpeed  = _rateOfChange;
        
        if (_rateOfChange > 100)
        {
            __pitchLocal = _pitch;
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
    
    static __SetMixPitch = function(_pitch)
    {
        __pitchMix = _pitch;
    }
    
    static __GetFinalGain = function()
    {
        return __VINYL_VOICE_GAIN_LxMxDxF/VINYL_MAX_VOICE_GAIN;
    }
    
    static __GetFinalPitch = function()
    {
        return __VINYL_VOICE_PITCH_LxM;
    }
}