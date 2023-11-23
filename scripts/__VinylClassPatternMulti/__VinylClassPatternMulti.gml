// Feather disable all

//Force instantiation of statics for use with __VinylPatternChange()
new __VinylClassPatternMulti();

function __VinylClassPatternMulti() : __VinylClassPatternCommon() constructor
{
    static __patternType   = __VINYL_PATTERN_TYPE_MULTI;
    static __pool          = __VinylGlobalData().__poolMulti;
    static __animCurveDict = __VinylGlobalData().__animCurveDict;
    
    __ResetShared();
    __Reset();
    
    static __Reset = function()
    {
        __sync             = VINYL_DEFAULT_MULTI_SYNC;
        __blend            = 0;
        __blendCurveName   = "";
        __blendFactorLocal = __blend;
        
        __childArray = [];
    }
    
    static __Unset = function()
    {
        variable_struct_remove(self, "__sync");
        variable_struct_remove(self, "__blend");
        variable_struct_remove(self, "__blendCurveName");
        variable_struct_remove(self, "__blendFactorLocal");
        
        variable_struct_remove(self, "__childArray");
    }
    
    static toString = function()
    {
        return "<multi " + string(__name) + ">";
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
        _struct.childrenArray  = __VinylSerializeArray(__childArray, self);
    }
        
    static __Deserialize = function(_struct, _parent)
    {
        //TODO - Decompress on load
        
        __DeserializeShared(_struct, _parent);
        
        __sync           = _struct.sync;
        __blend          = _struct.blend;
        __blendCurveName = _struct.blendCurveName;
        __childArray  = __VinylDeserializePatternArray(_struct.childrenArray, undefined, self);
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
        __SharedWidgets(_selectionHandler);
        __SharedWidgetsChildren(_selectionHandler);
    }
    
    //static __Initialize = function()
    //{
    //    //Find a blend curve to track
    //    __blendCurve = undefined;
    //    if (is_string(_blendCurveName))
    //    {
    //        if ((asset_get_index(_blendCurveName) >= 0) && (asset_get_type(_blendCurveName) == asset_animationcurve))
    //        {
    //            __blendCurve = __VinylAnimCurveEnsure(_blendCurveName);
    //        }
    //        else
    //        {
    //            __VinylError("Error in ", self, "\n\Animation curve \"", _blendCurveName, "\" not recognised");
    //        }
    //    }
    //    else if (_blendCurveName != undefined)
    //    {
    //        __VinylError("Error in ", self, "\n\"blend curve\" property must be the name of an animation curve as a string");
    //    }
    //    
    //    //Set the blend state
    //    var _knobBlend = __VinylParseKnob(_blend, "blend", false, self);
    //    __blendFactorLocal = _knobBlend ?? _blend;
    //    if (!is_numeric(__blendFactorLocal) && !is_undefined(__blendFactorLocal)) __VinylError("Error in ", self, "\n\"blend\" property must be a number or a knob");
    //    
    //    //Set the sync state
    //    __sync = _sync;
    //    if (!is_bool(__sync)) __VinylError("Error in pattern ", self, "\n\"sync\" must be a boolean (<true> or <false>)");
    //    
    //    if (VINYL_DEBUG_READ_CONFIG) __VinylTrace("Created ", self, ", gain=", __gain[0], " -> ", __gain[1], ", pitch=", __pitch[0], " -> ", __pitch[1], ", effect chain=", __effectChainName, ", label=", __VinylDebugLabelNames(__labelArray), ", persistent=", __persistent);
    //}
}
