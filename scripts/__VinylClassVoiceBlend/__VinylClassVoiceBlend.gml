// Feather disable all

/// @param pattern

function __VinylClassVoiceBlend(_pattern) constructor
{
    static _voiceStructArray       = __VinylSystem().__voiceStructArray;
    static _voiceStructDict        = __VinylSystem().__voiceStructDict;
    static _voiceStructUpdateArray = __VinylSystem().__voiceStructUpdateArray;
    
    array_push(_voiceStructArray, self);
    array_push(_voiceStructUpdateArray, self);
    
    __pattern = _pattern;
    
    __voiceTop   = -1;
    __voiceArray = [];
    
    var _soundArray = __pattern.__soundArray;
    if (array_length(_soundArray) > 0)
    {
        var _i = 0;
        repeat(array_length(_soundArray))
        {
            var _sound = _soundArray[_i];
            
            var _voice = audio_play_sound(_sound, 0, true);
            __voiceArray[_i] = _voice;
            
            ++_i;
        }
        
        __voiceTop = __voiceArray[0];
        struct_set_from_hash(_voiceStructDict, int64(__voiceTop), self);
    }
    
    
    
    
    
    static __Update = function()
    {
        return (not VinylWillStop(__voiceTop));
    }
    
    static __IsPlaying = function()
    {
        return (__voiceTop >= 0);
    }
}