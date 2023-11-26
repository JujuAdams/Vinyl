// Feather disable all

//Force instantiation of statics for use with __VinylPatternChange()
new __VinylClassPatternQueue();

function __VinylClassPatternQueue() : __VinylClassPatternCommon() constructor
{
    static __patternType = __VINYL_PATTERN_TYPE_QUEUE;
    static __pool = __VinylGlobalData().__poolQueue;
    static __usesChildArray = true;
    
    __Reset();
    
    static toString = function()
    {
        return "<queue " + string(__name) + ">";
    }
    
    static __Reset = function(_oldStatic = undefined)
    {
        __ResetShared();
        
        __behavior = __VINYL_QUEUE_PLAY_ONCE;
        if ((_oldStatic != undefined) && (not _oldStatic.__usesChildArray)) __childArray = [];
    }
    
    static __Unset = function(_newStatic = undefined)
    {
        variable_struct_remove(self, "__behavior");
        if (not _newStatic.__usesChildArray) variable_struct_remove(self, "__childArray");
    }
    
    static __Serialize = function(_struct)
    {
        //TODO - Compress on save
        
        __SerializeShared(_struct);
        
        _struct.behavior      = __behavior;
        _struct.childrenArray = variable_clone(__childArray);
    }
        
    static __Deserialize = function(_struct)
    {
        //TODO - Decompress on load
        
        __DeserializeShared(_struct);
        
        __behavior   = _struct.behavior;
        __childArray = variable_clone(_struct.childrenArray);
    }
    
    static __Play = function(_patternTop, _parentVoice, _vinylEmitter, _sound_UNUSED, _loop = undefined, _gain = 1, _pitch = 1, _pan = undefined)
    {
        var _voice = __pool.__Depool();
        _voice.__Instantiate(_patternTop, self, _parentVoice, _vinylEmitter, __childArray, _loop, _gain, _pitch, _pan);
        return _voice;
    }
    
    static __PlaySimple = function(_sound, _gain = 1, _pitch = 1, _effectChainName = __effectChainName)
    {
        __VinylError("Cannot use VinylPlaySimple() with a queue pattern");
    }
    
    static __BuildPropertyUI = function(_selectionHandler)
    {
        __SharedWidgetsChildren(_selectionHandler);
        ImGui.NewLine();
        __SharedWidgets(_selectionHandler);
    }
}
