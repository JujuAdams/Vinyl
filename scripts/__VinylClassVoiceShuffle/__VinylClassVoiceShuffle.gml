// Feather disable all

/// @param sound
/// @param voice
/// @param loopLocal
/// @param gainPattern
/// @param gainLocal
/// @param gainMix
/// @param gainDuck
/// @param pitchPattern
/// @param pitchLocal
/// @param duckNameLocal
/// @param duckPrioLocal
/// @param pattern
/// @param gainFactor
/// @param pitchFactor

function __VinylClassVoiceShuffle(_sound, _voice, _loopLocal, _gainPattern, _gainLocal, _gainMix, _gainDuck, _pitchPattern, _pitchLocal, _duckNameLocal, _duckPrioLocal, _pattern, _gainFactor, _pitchFactor) constructor
{
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    static _voiceUpdateArray = __VinylSystem().__voiceUpdateArray;
    static _toUpdateArray    = __VinylSystem().__toUpdateArray;
    
    __inUpdateArray = false;
    
    __sound        = _sound;
    __voice        = _voice;
    __loopLocal    = _loopLocal;
    
    __gainSound    = __VinylSoundGetGain(_sound);
    __gainPattern  = _gainPattern;
    __gainLocal    = _gainLocal;
    __gainMix      = _gainMix;
    __gainDuck     = _gainDuck;
    
    __pitchSound   = __VinylSoundGetPitch(_sound);
    __pitchPattern = _pitchPattern;
    __pitchLocal   = _pitchLocal;
    
    __duckNameLocal = _duckNameLocal;
    __duckPrioLocal = _duckPrioLocal;
    
    __pattern      = _pattern;
    __mixName      = (_pattern != undefined)? _pattern.__mixName : undefined;
    __gainFactor   = _gainFactor;
    __pitchFactor  = _pitchFactor;
    
    __gainLocalTarget  = _gainLocal;
    __gainLocalSpeed   = infinity;
    
    __gainDuckTarget    = _gainDuck;
    __gainDuckSpeed     = undefined;
    __gainDuckBehaviour = __VINYL_DUCK.__DO_NOTHING;
    
    _voiceToStructMap[? _voice] = self;
    if (VINYL_DEBUG_LEVEL >= 2) __VinylTrace("Adding ", _voice, " to voice lookup struct");
    
    
    
    
    
    static __IsPlaying = function()
    {
        return audio_is_playing(__voice);
    }
    
    static __Stop = function()
    {
        audio_stop_sound(__voice);
    }
    
    static __Pause = function()
    {
        audio_pause_sound(__voice);
    }
    
    static __Resume = function()
    {
        audio_resume_sound(__voice);
    }
    
    static __IsPaused = function()
    {
        return audio_is_paused(__voice);
    }
    
    static __Update = function(_delta)
    {
        var _changed = false;
        
        if (__gainDuckSpeed != undefined)
        {
            _changed = true;
            __gainDuck += clamp(__gainDuckTarget - __gainDuck, -_delta*__gainDuckSpeed, _delta*__gainDuckSpeed);
            
            if ((__gainDuckBehaviour == __VINYL_DUCK.__STOP) && (__gainDuck <= 0))
            {
                __Stop();
                return false;
            }
        }
        
        if (__gainLocal != __gainLocalTarget)
        {
            _changed = true;
            __gainLocal += _delta*clamp(__gainLocalTarget - __gainLocal, -__gainLocalSpeed, __gainLocalSpeed);
        }
        
        if (_changed)
        {
            audio_sound_gain(__voice, __VINYL_VOICE_GAIN_SxPxLxMxD/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
        }
        
        return true;
    }
    
    static __FadeOut = function(_rateOfChange)
    {
        if (not __inUpdateArray)
        {
            __inUpdateArray = true;
            array_push(_voiceUpdateArray, self);
        }
        
        __gainDuckSpeed     = _rateOfChange;
        __gainDuckTarget    = 0;
        __gainDuckBehaviour = __VINYL_DUCK.__STOP;
    }
    
    static __Duck = function(_targetGain, _rateOfChange, _behaviour)
    {
        if (__gainDuckBehaviour != __VINYL_DUCK.__STOP)
        {
            if (not __inUpdateArray)
            {
                __inUpdateArray = true;
                array_push(_voiceUpdateArray, self);
            }
            
            __gainDuckSpeed     = _rateOfChange;
            __gainDuckTarget    = _targetGain;
            __gainDuckBehaviour = _behaviour;
        }
    }
    
    static __SetLoop = function(_state)
    {
        audio_sound_loop(__voice, _state);
    }
    
    static __GetLoop = function()
    {
        return audio_sound_get_loop(__voice);
    }
    
    static __SetLocalGain = function(_gain, _rateOfChange)
    {
        __gainLocalTarget = _gain;
        __gainLocalSpeed  = _rateOfChange;
        
        if (_rateOfChange > 100)
        {
            __gainLocal = _gain;
            audio_sound_gain(__voice, __VINYL_VOICE_GAIN_SxPxLxMxD/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
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
        audio_sound_gain(__voice, __VINYL_VOICE_GAIN_SxPxLxMxD/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
    }
    
    static __QueueUpdateForSound = function(_sound)
    {
        if (__sound == _sound) array_push(_toUpdateArray, self);
    }
    
    static __UpdateFromPattern = function()
    {
        var _pattern = __pattern;
        
        __gainSound  = __VinylSoundGetGain(__sound);
        __pitchSound = __VinylSoundGetPitch(__sound);
        
        __gainPattern  = lerp(_pattern.__gainMin,  _pattern.__gainMax,  __gainFactor);
        __pitchPattern = lerp(_pattern.__pitchMin, _pattern.__pitchMax, __pitchFactor);
        
        var _mixStruct = __VinylVoiceMoveMix(__voice, _pattern.__mixName);
        var _loopMix = (_mixStruct == undefined)? undefined : _mixStruct.__membersLoop;
        
        audio_sound_loop( __voice, __loopLocal ?? (_pattern.__loop ?? (_loopMix ?? false)));
        audio_sound_gain( __voice, __VINYL_VOICE_GAIN_SxPxLxMxD/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
        audio_sound_pitch(__voice, __VINYL_VOICE_PITCH_SxPxL);
    }
}