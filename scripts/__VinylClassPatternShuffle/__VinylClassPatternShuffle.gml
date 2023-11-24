// Feather disable all

//Force instantiation of statics for use with __VinylPatternChange()
new __VinylClassPatternShuffle();

function __VinylClassPatternShuffle() : __VinylClassPatternCommon() constructor
{
    static __patternType = __VINYL_PATTERN_TYPE_SHUFFLE;
    static __pool = __VinylGlobalData().__poolBasic; //No need for a dedicated shuffle voice
    
    __ResetShared();
    __Reset();
    
    static __Reset = function()
    {
        __currentIndex  = 0;
        __childArray = [];
    }
    
    static __Unset = function()
    {
        variable_struct_remove(self, "__currentIndex");
        variable_struct_remove(self, "__childArray");
    }
    
    static toString = function()
    {
        return "<shuffle " + string(__name) + ">";
    }
    
    static __Serialize = function(_struct)
    {
        //TODO - Compress on save
        
        __SerializeShared(_struct);
        _struct.childrenArray = __VinylSerializeArray(__childArray, self);
    }
        
    static __Deserialize = function(_struct, _parent)
    {
        //TODO - Decompress on load
        
        __DeserializeShared(_struct, _parent);
        __childArray = __VinylDeserializePatternArray(_struct.childrenArray, undefined, self);
        
        //Initialize the currently-playing array with a random sample from the overall pattern array
        __currentIndex = 0;
        array_shuffle(__childArray);
    }
    
    static __PopPattern = function()
    {
        var _pattern = __childArray[__currentIndex];
        
        ++__currentIndex;
        if (__currentIndex >= array_length(__childArray))
        {
            //Reshuffle
            array_shuffle(__childArray);
            
            //Ensure we don't play the same sound twice in a row
            if (__childArray[0] == _pattern)
            {
                array_delete(__childArray, 0, 1);
                array_insert(__childArray, ceil(array_length(__childArray)/2), _pattern);
            }
            
            __currentIndex = 0;
        }
        
        return _pattern;
    }
    
    static __Play = function(_patternTop, _parentVoice, _vinylEmitter, _sound_UNUSED, _loop = undefined, _gain = 1, _pitch = 1, _pan = undefined)
    {
        var _voice = __pool.__Depool();
        _voice.__Instantiate(_patternTop, self, _parentVoice, _vinylEmitter, __PopPattern(), _loop, _gain, _pitch, _pan);
        return _voice;
    }
    
    static __PlaySimple = function(_sound_UNUSED, _gain = 1, _pitch = 1, _effectChainName = __effectChainName)
    {
        var _pattern = __PopPattern();
        return __VinylPatternGet(_pattern).__PlaySimple(_pattern, _gain, _pitch, _effectChainName); //TODO - Inherit properly
    }
    
    static __BuildPropertyUI = function(_selectionHandler)
    {
        __SharedWidgetsChildren(_selectionHandler);
        ImGui.NewLine();
        __SharedWidgets(_selectionHandler);
    }
}
