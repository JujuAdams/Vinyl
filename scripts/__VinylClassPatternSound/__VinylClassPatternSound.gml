// Feather disable all

/// @param name

function __VinylClassPatternSound(_name) : __VinylClassPatternCommon() constructor
{
    static __patternType = __VINYL_PATTERN_TYPE_SOUND;
    static __pool = __VinylGlobalData().__poolSound;
    
    __name = _name;
    
    //Specific variables for sound patterns
    __sound            = asset_get_index(__name);
    __loopPointsOption = __VINYL_OPTION_UNSET;
    __loopPoints       = [0, 0];
    __bpmOption        = __VINYL_OPTION_UNSET;
    __bpm              = VINYL_DEFAULT_BPM;
    
    static toString = function()
    {
        return "<sound " + string(__sound) + " " + audio_get_name(__sound) + ">";
    }
    
    static __Store = function(_document)
    {
        //Special case to add assets by name as well as by index (if VINYL_ALLOW_ASSET_REFERENCE_BY_STRING is <true>)
        
        var _patternDict  = _document.__patternDict;
        var _patternArray = _document.__patternArray;
        
        _patternDict[$ __name] = self;
        array_push(_patternArray, self);
    }
    
    static __Serialize = function(_struct)
    {
        //TODO - Compress on save
        
        __SerializeShared(_struct);
        
        _struct.sound            = audio_get_name(__sound);
        _struct.loopPointsOption = __loopPointsOption;
        _struct.loopPoints       = variable_clone(__loopPoints);
        _struct.bpmOption        = __bpmOption;
        _struct.bpm              = __bpm;
    }
    
    static __Deserialize = function(_struct, _child)
    {
        //TODO - Decompress on load
        
        __DeserializeShared(_struct, _child);
        
        __sound            = asset_get_index(_struct.sound);
        __loopPointsOption = _struct.loopPointsOption;
        __loopPoints       = variable_clone(_struct.loopPoints);
        __bpmOption        = _struct.bpmOption;
        __bpm              = _struct.bpm;
    }
    
    static __Play = function(_patternTop, _parentVoice, _vinylEmitter, _sound_UNUSED, _loop = undefined, _gain = 1, _pitch = 1, _pan = undefined)
    {
        var _voice = __pool.__Depool();
        _voice.__Instantiate(_patternTop, self, _parentVoice, _vinylEmitter, __sound, _loop, _gain, _pitch, _pan);
        return _voice;
    }
    
    static __PlaySimple = function(_sound_UNUSED, _gain = 1, _pitch = 1, _effectChainName = __effectChainName)
    {
        return __VinylPlaySimple(__sound, _gain*__gain[0], _gain*__gain[1], _pitch*__pitch[0], _pitch*__pitch[1], __labelArray, _effectChainName);
    }
}