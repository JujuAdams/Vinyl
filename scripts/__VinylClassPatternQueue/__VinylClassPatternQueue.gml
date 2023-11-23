// Feather disable all

//Force instantiation of statics for use with __VinylPatternChange()
new __VinylClassPatternQueue();

function __VinylClassPatternQueue() : __VinylClassPatternCommon() constructor
{
    static __patternType = __VINYL_PATTERN_TYPE_QUEUE;
    static __pool = __VinylGlobalData().__poolQueue;
    
    __ResetShared();
    __Reset();
    
    static __Reset = function()
    {
        __behavior = __VINYL_QUEUE_PLAY_ONCE;
        __childArray = [];
    }
    
    static __Unset = function()
    {
        variable_struct_remove(self, "__behavior");
        variable_struct_remove(self, "__childArray");
    }
    
    static toString = function()
    {
        return "<queue " + string(__name) + ">";
    }
    
    static __Serialize = function(_struct)
    {
        //TODO - Compress on save
        
        __SerializeShared(_struct);
        
        _struct.behavior      = __behavior;
        _struct.childrenArray = __VinylSerializeArray(__childArray, self);
    }
        
    static __Deserialize = function(_struct, _child)
    {
        //TODO - Decompress on load
        
        __DeserializeShared(_struct, _child);
        
        __behavior      = _struct.behavior;
        __childArray = __VinylDeserializePatternArray(_struct.childrenArray, undefined, self);
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
    
    static __BuildPropertyUI = function(_selectionHandler)
    {
        __SharedWidgets(_selectionHandler);
        __SharedWidgetsChildren(_selectionHandler);
    }
}
