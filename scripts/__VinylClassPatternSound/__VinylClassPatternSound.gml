// Feather disable all

/// @param sound
/// @param loop
/// @param gainMin
/// @param gainMax
/// @param pitchMin
/// @param pitchMax

function __VinylClassPatternSound(_sound, _loop, _gainMin, _gainMax, _pitchMin, _pitchMax) constructor
{
    __sound    = _sound;
    __loop     = _loop;
    __gainMin  = _gainMin;
    __gainMax  = _gainMax;
    __pitchMin = _pitchMin;
    __pitchMax = _pitchMax;
    
    //Don't make this static!
    __Play = function(_loop, _gainLocal, _pitchLocal)
    {
        var _gainFinal  = _gainLocal *__VinylRandomRange(__gainMin,  __gainMax);
        var _pitchFinal = _pitchLocal*__VinylRandomRange(__pitchMin, __pitchMax);
        var _voice = audio_play_sound(__sound, 0, _loop ?? __loop, _gainFinal, 0, _pitchFinal);
        __VinylVoiceTrack(_voice, _gainLocal, _gainFinal, _pitchLocal, _pitchFinal).__pattern = __sound;
        return _voice;
    }
    
    static __Update = function(_loop, _gainMin, _gainMax, _pitchMin, _pitchMax)
    {
        static _voiceContextArray = __VinylSystem().__voiceContextArray;
        
        var _gainMinPrev  = __gainMin;
        var _gainMaxPrev  = __gainMax;
        var _pitchMinPrev = __pitchMin;
        var _pitchMaxPrev = __pitchMax;
        
        __loop     = _loop;
        __gainMin  = _gainMin;
        __gainMax  = _gainMax;
        __pitchMin = _pitchMin;
        __pitchMax = _pitchMax;
        
        var _i = 0;
        repeat(array_length(_voiceContextArray))
        {
            var _voiceContext = _voiceContextArray[_i];
            if (_voiceContext.__pattern == __sound)
            {
                var _voice          = _voiceContext.__voice;
                var _gainLocalPrev  = _voiceContext.__gainLocal;
                var _pitchLocalPrev = _voiceContext.__pitchLocal;
                
                if (_gainMinPrev == _gainMaxPrev)
                {
                    var _gainLocal = 0.5*(_gainMin + _gainMax)
                }
                else
                {
                    var _gainLocal = lerp(_gainMin, _gainMax, clamp((_gainLocalPrev - _gainMinPrev) / (_gainMaxPrev - _gainMinPrev), 0, 1));
                }
                
                if (_pitchMinPrev == _pitchMaxPrev)
                {
                    var _pitchLocal = 0.5*(_pitchMin + _pitchMax)
                }
                else
                {
                    var _pitchLocal = lerp(_pitchMin, _pitchMax, clamp((_pitchLocalPrev - _pitchMinPrev) / (_pitchMaxPrev - _pitchMinPrev), 0, 1));
                }
                
                _voiceContext.__gainLocal  = _gainLocal;
                _voiceContext.__pitchLocal = _pitchLocal;
                
                audio_sound_loop( _voice, _loop);
                audio_sound_gain( _voice, audio_sound_get_gain( _voice)/_gainLocalPrev  * _gainLocal, VINYL_STEP_DURATION);
                audio_sound_pitch(_voice, audio_sound_get_pitch(_voice)/_pitchLocalPrev * _pitchLocal);
            }
            
            ++_i;
        }
    }
}