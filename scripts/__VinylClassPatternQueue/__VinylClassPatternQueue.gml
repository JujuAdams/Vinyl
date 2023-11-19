// Feather disable all

function __VinylClassPatternQueue() : __VinylClassPatternCommon() constructor
{
    static __patternType = __VINYL_PATTERN_TYPE_QUEUE;
    static __pool = __VinylGlobalData().__poolQueue;
    
    __behavior      = __VINYL_QUEUE_PLAY_ONCE;
    __childrenArray = [];
    
    static toString = function()
    {
        return "<queue " + string(__name) + ">";
    }
    
    static __Serialize = function(_struct)
    {
        //TODO - Compress on save
        
        __SerializeShared(_struct);
        
        _struct.behavior      = __behavior;
        _struct.childrenArray = __VinylSerializeArray(__childrenArray, self);
    }
        
    static __Deserialize = function(_struct, _child)
    {
        //TODO - Decompress on load
        
        __DeserializeShared(_struct, _child);
        
        __behavior      = _struct.behavior;
        __childrenArray = __VinylDeserializePatternArray(_struct.childrenArray, undefined, self);
    }
    
    static __Play = function(_patternTop, _parentVoice, _vinylEmitter, _sound_UNUSED, _loop = undefined, _gain = 1, _pitch = 1, _pan = undefined)
    {
        var _voice = __pool.__Depool();
        _voice.__Instantiate(_patternTop, self, _parentVoice, _vinylEmitter, __assetArray, _loop, _gain, _pitch, _pan);
        return _voice;
    }
    
    static __PlaySimple = function(_sound, _gain = 1, _pitch = 1, _effectChainName = __effectChainName)
    {
        __VinylError("Cannot use VinylPlaySimple() with a queue pattern");
    }
}
