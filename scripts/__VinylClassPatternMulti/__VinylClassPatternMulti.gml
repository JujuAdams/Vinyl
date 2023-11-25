// Feather disable all

//Force instantiation of statics for use with __VinylPatternChange()
new __VinylClassPatternMulti();

function __VinylClassPatternMulti() : __VinylClassPatternCommon() constructor
{
    static __patternType    = __VINYL_PATTERN_TYPE_MULTI;
    static __pool           = __VinylGlobalData().__poolMulti;
    static __usesChildArray = true;
    static __animCurveDict  = __VinylGlobalData().__animCurveDict;
    
    __Reset();
    
    static toString = function()
    {
        return "<multi " + string(__name) + ">";
    }
    
    static __Reset = function(_oldStatic = undefined)
    {
        __ResetShared();
        
        __sync             = VINYL_DEFAULT_MULTI_SYNC;
        __blend            = 0;
        __blendCurveName   = "";
        __blendFactorLocal = __blend;
        
        if ((_oldStatic != undefined) && (not _oldStatic.__usesChildArray)) __childArray = [];
    }
    
    static __Unset = function(_newStatic = undefined)
    {
        variable_struct_remove(self, "__sync");
        variable_struct_remove(self, "__blend");
        variable_struct_remove(self, "__blendCurveName");
        variable_struct_remove(self, "__blendFactorLocal");
        
        if (not _newStatic.__usesChildArray) variable_struct_remove(self, "__childArray");
    }
    
    static __MultiBlendSet = function(_blend)
    {
        __blendFactorLocal = _blend;
    }
    
    static __Serialize = function(_struct)
    {
        //TODO - Compress on save
        
        __SerializeShared(_struct);
        
        _struct.sync           = __sync;
        _struct.blend          = __blend;
        _struct.blendCurveName = __blendCurveName;
        _struct.childrenArray  = variable_clone(__childArray);
    }
        
    static __Deserialize = function(_struct)
    {
        //TODO - Decompress on load
        
        __DeserializeShared(_struct);
        
        __sync           = _struct.sync;
        __blend          = _struct.blend;
        __blendCurveName = _struct.blendCurveName;
        __childArray  = variable_clone(_struct.childrenArray);
    }
    
    static __Play = function(_patternTop, _parentVoice, _vinylEmitter, _sound, _loop = undefined, _gain = 1, _pitch = 1, _pan = undefined)
    {
        var _voice = __pool.__Depool();
        _voice.__Instantiate(_patternTop, self, _parentVoice, _vinylEmitter, __assetArray, _loop, _gain, _pitch, _pan);
        return _voice;
    }
    
    static __PlaySimple = function(_sound, _gain = 1, _pitch = 1, _effectChainName = __effectChainName)
    {
        __VinylError("Cannot use VinylPlaySimple() with a multi pattern");
    }
    
    static __BuildPropertyUI = function(_selectionHandler)
    {
        __SharedWidgetsChildren(_selectionHandler);
        ImGui.NewLine();
        __SharedWidgets(_selectionHandler);
    }
}
