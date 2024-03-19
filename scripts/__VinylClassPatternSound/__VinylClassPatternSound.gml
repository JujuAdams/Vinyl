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
        var _gainPattern  = __VinylRandomRange(__gainMin,  __gainMax);
        var _pitchPattern = __VinylRandomRange(__pitchMin, __pitchMax);
        var _voice = audio_play_sound(__sound, 0, _loop ?? __loop, _gainLocal*_gainPattern, 0, _pitchLocal*_pitchPattern);
        __VinylVoiceTrack(_voice, _gainLocal, _pitchLocal, _gainPattern, _pitchPattern).__pattern = __sound;
        return _voice;
    }
    
    static __Update = function(_loop, _gainMin, _gainMax, _pitchMin, _pitchMax)
    {
        static _voiceContextArray = __VinylSystem().__voiceStructArray;
        
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
                var _voice            = _voiceContext.__voice;
                var _gainPatternPrev  = _voiceContext.__gainPattern;
                var _pitchPatternPrev = _voiceContext.__pitchPattern;
                
                if (_gainMinPrev == _gainMaxPrev)
                {
                    var _gainPattern = 0.5*(_gainMin + _gainMax)
                }
                else
                {
                    var _gainPattern = lerp(_gainMin, _gainMax, clamp((_gainPatternPrev - _gainMinPrev) / (_gainMaxPrev - _gainMinPrev), 0, 1));
                }
                
                if (_pitchMinPrev == _pitchMaxPrev)
                {
                    var _pitchPattern = 0.5*(_pitchMin + _pitchMax)
                }
                else
                {
                    var _pitchPattern = lerp(_pitchMin, _pitchMax, clamp((_pitchPatternPrev - _pitchMinPrev) / (_pitchMaxPrev - _pitchMinPrev), 0, 1));
                }
                
                _voiceContext.__gainPattern  = _gainPattern;
                _voiceContext.__pitchPattern = _pitchPattern;
                
                audio_sound_loop(_voice, _loop);
                audio_sound_gain(_voice, _voiceContext.__gainLocal*_gainPattern, VINYL_STEP_DURATION);
                audio_sound_pitch(_voice, _voiceContext.__pitchLocal*_pitchPattern);
            }
            
            ++_i;
        }
    }
}