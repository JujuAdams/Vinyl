// Feather disable all

/// @param pattern
/// @param gainLocal
/// @param pitchLocal
/// @param duckerNameLocal
/// @param duckPrioLocal
/// @param mixNameLocal

function __VinylClassVoiceAbstract(_pattern, _gainLocal, _pitchLocal, _duckerNameLocal, _duckPrioLocal, _mixNameLocal) constructor
{
    static _mixDict          = __VinylSystem().__mixDict;
    static _duckerDict       = __VinylSystem().__duckerDict;
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    static _voiceUpdateArray = __VinylSystem().__voiceUpdateArray;
    static _toUpdateArray    = __VinylSystem().__toUpdateArray;
    
    static _count = 0;
    __voiceReference = __VINYL_ABSTRACT_VOICE | _count;
    ++_count;
    
    __inUpdateArray = false;
    
    __playing = true;
    __paused  = false;
    
    __gainLocal    = _gainLocal;
    __pitchLocal   = _pitchLocal;
    __mixNameLocal = _mixNameLocal;
    
    //Resolve values inherited from the pattern
    if (_pattern == undefined)
    {
        __gainPattern  = 1;
        __pitchPattern = 1;
        __mixName      = _mixNameLocal;
    }
    else
    {
        __gainPattern  = _pattern.__gain;
        __pitchPattern = _pattern.__pitch;
        __mixName      = _mixNameLocal ?? _pattern.__mixName;
    }
    
    //Resolve values inherited from the mix
    if (__mixName == undefined)
    {
        var _mixStruct = undefined;
        __gainMix  = 1;
        __pitchMix = 1;
        
        __duckerNameFinal = _duckerNameLocal ?? ((_pattern != undefined)? _pattern.__duckerName : undefined);
    }
    else
    {
        var _mixStruct = _mixDict[$ __mixName];
        if (_mixStruct == undefined)
        {
            __VinylError("Mix \"", __mixName, "\" not recognised");
            return;
        }
        
        __gainMix  = _mixStruct.__gainFinal;
        __pitchMix = _mixStruct.__pitchLocal;
        
        __duckerNameFinal = _duckerNameLocal ?? (((_pattern != undefined)? _pattern.__duckerName : undefined) ?? _mixStruct.__membersDuckOn);
    }
    
    //Resolve values inherited from the ducker
    if (__duckerNameFinal != undefined)
    {
        var _duckerStruct = _duckerDict[$ __duckerNameFinal];
        if (_duckerStruct == undefined)
        {
            __VinylError("Ducker \"", __duckerNameFinal, "\" not recognised");
            return;
        }
        
        var _duckPrioFinal = _duckPrioLocal ?? (((_pattern != undefined)? _pattern.__duckPrio : undefined) ?? 0);
        __gainDuck = (_duckerStruct.__maxPriority <= _duckPrioFinal)? 1 : _duckerStruct.__duckedGain;
    }
    else
    {
        var _duckerStruct = undefined;
        __gainDuck = 1;
    }
    
    __gainFadeOut      = 1;
    __gainFadeOutSpeed = undefined;
    __gainFadeOutStop  = false;
    
    __gainLocalTarget = __gainLocal;
    __gainLocalSpeed  = infinity;
    
    __gainDuckTarget = __gainDuck;
    __gainDuckSpeed  = undefined;
    
    __pitchLocalTarget = __pitchLocal;
    __pitchLocalSpeed  = infinity;
    
    _voiceToStructMap[? __voiceReference] = self;
    if (_duckerStruct != undefined) _duckerStruct.__Push(self, _duckPrioFinal, false);
    if (_mixStruct != undefined) _mixStruct.__Add(__voiceReference);
    
    
    
    
    
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
                    return false;
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
    
    static __SetLoop = function(_state_UNUSED)
    {
        //Abstract voices always loop
    }
    
    static __GetLoop = function()
    {
        return true;
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
    
    static __UpdateFromPattern = function()
    {
        if (__pattern == undefined) return;
        
        var _pattern = __pattern;
        
        __gainPattern  = _pattern.__gain;
        __pitchPattern = _pattern.__pitch;
        
        var _mixStruct = __VinylVoiceMoveMix(__voiceReference, __mixNameLocal ?? _pattern.__mixName);
        __VinylVoiceUpdateDucker(_mixStruct);
    }
    
    static __GetFinalGain = function()
    {
        return __VINYL_VOICE_GAIN_PxLxMxDxF/VINYL_MAX_VOICE_GAIN;
    }
    
    static __GetFinalPitch = function()
    {
        return __VINYL_VOICE_PITCH_PxLxM;
    }
}