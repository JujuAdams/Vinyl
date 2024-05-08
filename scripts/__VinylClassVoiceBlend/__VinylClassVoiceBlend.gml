// Feather disable all

/// @param pattern
/// @param gainLocal
/// @param pitchLocal

function __VinylClassVoiceBlend(_pattern, _gainLocal, _pitchLocal) constructor
{
    static _voiceStructArray       = __VinylSystem().__voiceStructArray;
    static _voiceStructDict        = __VinylSystem().__voiceStructDict;
    static _voiceStructUpdateArray = __VinylSystem().__voiceStructUpdateArray;
    
    array_push(_voiceStructArray, self);
    array_push(_voiceStructUpdateArray, self);
    
    __pattern    = _pattern;
    __gainLocal  = _gainLocal;
    __pitchLocal = _pitchLocal;
    
    __blendFactor = 0;
    
    __voiceTop   = -1;
    __voiceArray = [];
    
    var _soundArray = __pattern.__soundArray;
    if (array_length(_soundArray) > 0)
    {
        var _loop = true;
        
        __voiceTop = audio_play_sound(_soundArray[0], 0, _loop, __gainLocal, 0, __pitchLocal);
        __voiceArray[0] = __voiceTop;
        struct_set_from_hash(_voiceStructDict, int64(__voiceTop), self);
        
        var _i = 1;
        repeat(array_length(_soundArray)-1)
        {
            __voiceArray[_i] = audio_play_sound(_soundArray[_i], 0, _loop, 0, 0, __pitchLocal);
            ++_i;
        }
    }
    
    
    
    
    
    static __Update = function()
    {
        return (not VinylWillStop(__voiceTop));
    }
    
    static __IsPlaying = function()
    {
        return (__voiceTop >= 0);
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
    
    static __SetBlend = function(_value)
    {
        __blendFactor = clamp(_value, 0, 1);
        
        if (array_length(__voiceArray) <= 0) return;
        
        //Scale up the blend factor to match the number of channels we have
        var _factor = clamp(__blendFactor, 0, 1)*(array_length(__voiceArray) - 1);
        
        //Set channels using linear crossfades
        var _i = 0;
        repeat(array_length(__voiceArray))
        {
            var _gain = max(0, 1 - abs(_i - _factor));
            audio_sound_gain(__voiceArray[_i], _gain*__gainLocal, VINYL_STEP_DURATION);
            ++_i;
        }
    }
    
    static __SetBlendAnimCurve = function(_value, _animCurve)
    {
        __blendFactor = clamp(_value, 0, 1);
        
        //Set channels from the animation curve
        var _channelCount = array_length(animcurve_get(_animCurve).channels);
        var _i = 0;
        repeat(min(_channelCount, array_length(__voiceArray)))
        {
            var _gain = max(0, animcurve_channel_evaluate(animcurve_get_channel(_animCurve, _i), __blendFactor));
            audio_sound_gain(__voiceArray[_i], _gain*__gainLocal, VINYL_STEP_DURATION);
            ++_i;
        }
        
        //Set remaining channels to 0
        repeat(array_length(__voiceArray) - _i)
        {
            audio_sound_gain(__voiceArray[_i], 0, VINYL_STEP_DURATION);
            ++_i;
        }
    }
}