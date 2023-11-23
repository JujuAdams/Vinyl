// Feather disable all

//Force instantiation of statics for use with __VinylPatternChange()
new __VinylClassPatternBasic();

function __VinylClassPatternBasic() : __VinylClassPatternCommon() constructor
{
    static __patternType = __VINYL_PATTERN_TYPE_BASIC;
    static __pool = __VinylGlobalData().__poolBasic;
    
    __ResetShared();
    __Reset();
    
    static toString = function()
    {
        return (__sound == undefined)? "<basic ???>" : "<basic " + audio_get_name(__sound) + ">";
    }
    
    static __Reset = function()
    {
        __sound = undefined;
    }
    
    static __Unset = function()
    {
        variable_struct_remove(self, "__sound");
    }
    
    static __Serialize = function(_struct)
    {
        __SerializeShared(_struct);
        
        _struct.sound = audio_get_name(__sound);
    }
    
    static __Deserialize = function(_struct, _parent)
    {
        __DeserializeShared(_struct, _parent);
        
        __sound = asset_get_index(_struct.__sound);
    }
    
    static __Play = function(_patternTop, _parentVoice, _vinylEmitter, _sound_UNUSED, _loop = undefined, _gain = 1, _pitch = 1, _pan = undefined)
    {
        var _voice = __pool.__Depool();
        _voice.__Instantiate(_patternTop, self, _parentVoice, _vinylEmitter, __sound, _loop, _gain, _pitch, _pan);
        return _voice;
    }
    
    static __PlaySimple = function(_sound_UNUSED, _gain = 1, _pitch = 1, _effectChainName = __effectChainName)
    {
        return __VinylPatternGet(__sound).__PlaySimple(__sound, _gain*0.5*(__gain[0] + __gain[1]), _pitch*0.5*(__pitch[0] + __pitch[1]), _effectChainName); //TODO - Inherit properly
    }
    
    static __BuildPropertyUI = function(_selectionHandler)
    {
        __SharedWidgets(_selectionHandler);
    }
}
