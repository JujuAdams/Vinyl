// Feather disable all

/// @param mixName
/// @param baseGain

function __VinylClassMix(_mixName, _gainBase) constructor
{
    static _voiceStructDict = __VinylSystem().__voiceStructDict;
    
    __mixName  = _mixName;
    __gainBase = _gainBase;
    
    __gainLocal = 1;
    
    __voiceIndex = 0;
    __voiceArray = [];
    
    static __Update = function()
    {
        var _array = __voiceArray;
        var _length = array_length(_array);
        if (_length > 0)
        {
            var _index = (__voiceIndex + 1) mod _length;
            if (not audio_is_playing(_array[_index])) array_delete(_array, _index, 1);
            __voiceIndex = _index;
        }
    }
    
    static __UpdateSetup = function(_gainBase)
    {
        __gainBase = _gainBase;
    }
    
    static __ClearSetup = function()
    {
        __UpdateSetup(1);
    }
    
    static __Add = function(_voice)
    {
        array_push(__voiceArray, _voice);
    }
    
    static __StopVoices = function()
    {
        var _i = 0;
        repeat(array_length(__voiceArray))
        {
            VinylStop(__voiceArray[_i]);
            ++_i;
        }
    }
    
    static __FadeOutVoices = function(_rateOfChange)
    {
        var _i = 0;
        repeat(array_length(__voiceArray))
        {
            VinylFadeOut(__voiceArray[_i], _rateOfChange);
            ++_i;
        }
    }
    
    static __SetGain = function(_gain)
    {
        __gainLocal = _gain;
        var _gainFinal = __gainBase*__gainLocal;
        
        var _array = __voiceArray;
        var _i = 0;
        repeat(array_length(_array))
        {
            __VinylEnsureSoundVoice(_array[_i]).__SetMixGain(_gainFinal);
            ++_i;
        }
    }
    
    static __ExportJSON = function()
    {
        var _struct = {
            mix:      __mixName,
            baseGain: __gainBase,
        };
        
        return _struct;
    }
}