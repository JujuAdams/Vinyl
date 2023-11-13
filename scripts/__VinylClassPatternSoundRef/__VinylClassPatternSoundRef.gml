// Feather disable all

function __VinylClassPatternSoundRef() constructor
{
    static __patternType = __VINYL_PATTERN_TYPE_SOUND_REF;
    
    static __child = true;
    
    __sound = undefined;
    
    static toString = function()
    {
        return "<sound ref " + string(__sound) + " " + audio_get_name(__sound) + ">";
    }
    
    static __Serialize = function(_struct)
    {
        _struct.type = __VINYL_PATTERN_TYPE_SOUND_REF;
        _struct.name = audio_get_name(__sound);
    }
    
    static __Deserialize = function(_struct, _child__UNUSED)
    {
        __sound = asset_get_index(_struct.name);
    }
    
    static __Play = function(_patternTop, _parentVoice, _vinylEmitter, _sound, _loop = undefined, _gain = 1, _pitch = 1, _pan = undefined)
    {
        __VinylError("TODO");
    }
    
    static __PlaySimple = function(_sound, _gain = 1, _pitch = 1, _effectChainName = __effectChainName)
    {
        __VinylError("TODO");
    }
}
