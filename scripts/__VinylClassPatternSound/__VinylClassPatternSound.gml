// Feather disable all

function __VinylClassPatternSound() : __VinylClassPatternCommon() constructor
{
    static __patternType = __VINYL_PATTERN_TYPE_SOUND;
    static __pool = __VinylGlobalData().__poolSound;
    static __usesChildArray = false;
    
    __Reset();
    
    static toString = function()
    {
        return "<sound " + string(__sound) + " " + audio_get_name(__sound) + ">";
    }
    
    static __GetName = function(_maxCharacters)
    {
        if (__name != "")
        {
            return string(__name);
        }
        
        return audio_get_name(__sound);
    }
    
    static __Reset = function()
    {
        __ResetShared();
        
        __sound            = undefined;
        __loopPointsOption = __VINYL_OPTION_UNSET;
        __loopPoints       = [0, 0];
        __bpmOption        = __VINYL_OPTION_UNSET;
        __bpm              = VINYL_DEFAULT_BPM;
    }
    
    static __Unset = function()
    {
        variable_struct_remove(self, "__sound");
        variable_struct_remove(self, "__loopPointsOption");
        variable_struct_remove(self, "__loopPoints");
        variable_struct_remove(self, "__bpmOption");
        variable_struct_remove(self, "__bpm");
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
    
    static __Deserialize = function(_struct)
    {
        //TODO - Decompress on load
        
        __DeserializeShared(_struct);
        
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
    
    static __BuildPropertyUI = function(_selectionHandler)
    {
        __SharedWidgets(_selectionHandler);
    }
}
