// Feather disable all

/// @param patternIndex
/// @param soundArray
/// @param gainForce
/// @param gainMin
/// @param gainMax
/// @param pitchForce
/// @param pitchMin
/// @param pitchMax

function __VinylClassPatternShuffle(_patternIndex, _soundArray, _gainForce, _gainMin, _gainMax, _pitchForce, _pitchMin, _pitchMax) constructor
{
    __patternIndex = _patternIndex;
    
    __soundArray = __VinylImportSoundArray(_soundArray);
    __gainForce  = _gainForce;
    __gainMin    = _gainMin;
    __gainMax    = _gainMax;
    __pitchForce = _pitchForce;
    __pitchMin   = _pitchMin;
    __pitchMax   = _pitchMax;
    
    __soundCount = array_length(__soundArray);
    __playIndex  = infinity;
    
    //Don't make this static!
    __Play = function(_loop, _gainLocal, _pitchLocal)
    {
        if (__playIndex >= __soundCount) //If we've played through our bank of sounds, reshuffle
        {
            __playIndex = 0;
            var _last = __soundArray[__soundCount-1];
            array_delete(__soundArray, __soundCount-1, 1); //Make sure we don't reshuffle in the last played sound...
            __VinylArrayShuffle(__soundArray);
            array_insert(__soundArray, __soundCount div 2, _last); //...and stick it somewhere in the middle instead
        }
        
        var _sound = __soundArray[__playIndex];
        ++__playIndex;
        
        var _gainFactor  = __VinylRandom(1);
        var _pitchFactor = __VinylRandom(1);
        
        var _gainPattern  = lerp(__gainMin,  __gainMax, _gainFactor);
        var _pitchPattern = lerp(__pitchMin, __pitchMax, _pitchFactor);
        
        var _voice = audio_play_sound(_sound, 0, false, _gainLocal*_gainPattern, 0, _pitchLocal*_pitchPattern);
        __VinylVoiceTrack(_voice, _gainLocal, _pitchLocal, _gainFactor, _pitchFactor, __patternIndex);
        return _voice;
    }
    
    static __Update = function(_soundArray, _gainForce, _gainMin, _gainMax, _pitchForce, _pitchMin, _pitchMax)
    {
        __soundArray = __VinylImportSoundArray(_soundArray);
        __gainForce  = _gainForce;
        __gainMin    = _gainMin;
        __gainMax    = _gainMax;
        __pitchForce = _pitchForce;
        __pitchMin   = _pitchMin;
        __pitchMax   = _pitchMax;
        
        __soundCount = array_length(__soundArray);
        __playIndex  = infinity;
    }
}