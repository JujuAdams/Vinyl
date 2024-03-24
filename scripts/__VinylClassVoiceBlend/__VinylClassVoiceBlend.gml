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
    
    __blendFactor = 0;
    
    __voiceTop   = -1;
    __voiceArray = [];
    
    var _soundArray = __pattern.__soundArray;
    if (array_length(_soundArray) > 0)
    {
        var _loop = true;
        
        __voiceTop = audio_play_sound(_soundArray[0], 0, _loop, 1);
        struct_set_from_hash(_voiceStructDict, int64(__voiceTop), self);
        
        var _i = 1;
        repeat(array_length(_soundArray)-1)
        {
            __voiceArray[_i] = audio_play_sound(_soundArray[_i], 0, _loop, 0);
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
    
    static __SetBlend = function(_value)
    {
        __blendFactor = _value;
    }
}