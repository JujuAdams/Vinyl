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
        var _gainFactor  = __VinylRandom(1);
        var _pitchFactor = __VinylRandom(1);
        
        var _gainPattern  = lerp(__gainMin,  __gainMax,  _gainFactor);
        var _pitchPattern = lerp(__pitchMin, __pitchMax, _pitchFactor);
        
        var _voice = audio_play_sound(__sound, 0, _loop ?? __loop, _gainLocal*_gainPattern, 0, _pitchLocal*_pitchPattern);
        __VinylVoiceTrack(_voice, _gainLocal, _pitchLocal, _gainFactor, _pitchFactor).__pattern = __sound;
        return _voice;
    }
    
    static __Update = function(_loop, _gainMin, _gainMax, _pitchMin, _pitchMax)
    {
        static _voiceContextArray = __VinylSystem().__voiceStructArray;
        
        __loop     = _loop;
        __gainMin  = _gainMin;
        __gainMax  = _gainMax;
        __pitchMin = _pitchMin;
        __pitchMax = _pitchMax;
        
        var _i = 0;
        repeat(array_length(_voiceContextArray))
        {
            var _voiceStruct = _voiceContextArray[_i];
            if (_voiceStruct.__pattern == __sound)
            {
                var _voice = _voiceStruct.__voice;
                
                _voiceStruct.__loop = _loop;
                audio_sound_loop(_voice, _loop);
                
                var _gainPattern  = lerp(_gainMin, _gainMax, _voiceStruct.__gainFactor);
                var _pitchPattern = lerp(_pitchMin, _pitchMax, _voiceStruct.__pitchFactor);
                
                audio_sound_gain(_voice, _voiceStruct.__gainLocal*_gainPattern, VINYL_STEP_DURATION);
                audio_sound_pitch(_voice, _voiceStruct.__pitchLocal*_pitchPattern);
            }
            
            ++_i;
        }
    }
}