// Feather disable all

function __VinylClassPatternShuffle() : __VinylClassPatternCommon() constructor
{
    static __patternType = __VINYL_PATTERN_TYPE_SHUFFLE;
    static __pool = __VinylGlobalData().__poolBasic; //No need for a dedicated shuffle voice
    
    //Specific variables for sound patterns
    __currentIndex  = 0;
    __childrenArray = [];
    
    static toString = function()
    {
        return "<shuffle " + string(__name) + ">";
    }
    
    static __Serialize = function(_struct)
    {
        //TODO - Compress on save
        
        __SerializeShared(_struct);
        _struct.childrenArray = __VinylSerializeArray(__childrenArray, self);
    }
        
    static __Deserialize = function(_struct, _parent)
    {
        //TODO - Decompress on load
        
        __DeserializeShared(_struct, _parent);
        __childrenArray = __VinylDeserializePatternArray(_struct.childrenArray, undefined, self);
        
        //Initialize the currently-playing array with a random sample from the overall pattern array
        __currentIndex = 0;
        array_shuffle(__childrenArray);
    }
    
    static __PopPattern = function()
    {
        var _pattern = __childrenArray[__currentIndex];
        
        ++__currentIndex;
        if (__currentIndex >= array_length(__childrenArray))
        {
            //Reshuffle
            array_shuffle(__childrenArray);
            
            //Ensure we don't play the same sound twice in a row
            if (__childrenArray[0] == _pattern)
            {
                array_delete(__childrenArray, 0, 1);
                array_insert(__childrenArray, ceil(array_length(__childrenArray)/2), _pattern);
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
}
