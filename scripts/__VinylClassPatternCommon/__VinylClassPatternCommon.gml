// Feather disable all
function __VinylClassPatternCommon()
{
    static __effectChainDict = __VinylGlobalData().__effectChainDict;
    
    __Reset();
    
    static __Reset = function()
    {
        __name                  = undefined;
        __child                 = false;
        
        __gainOption            = __VINYL_OPTION_UNSET;
        __gain                  = [1, 1];
        __gainKnob              = __VINYL_ASSET_NULL;
        __gainKnobOverride      = false;
        
        __pitchOption           = __VINYL_OPTION_UNSET;
        __pitch                 = [1, 1];
        __pitchKnob             = __VINYL_ASSET_NULL;
        __pitchKnobOverride     = false;
        
        __loopOption            = __VINYL_OPTION_UNSET;
        __loop                  = false;
        
        __labelsOption          = __VINYL_OPTION_UNSET;
        __labelsArray           = [];
        
        __stackOption           = __VINYL_OPTION_UNSET;
        __stackName             = __VINYL_ASSET_NULL;
        __stackPriority         = undefined;
        
        __effectChainOption     = __VINYL_OPTION_UNSET;
        __effectChainName       = __VINYL_ASSET_NULL;
        
        __persistentOption      = __VINYL_OPTION_UNSET;
        __persistent            = undefined;
        
        __transposeOption       = __VINYL_OPTION_UNSET;
        __transpose             = [0, 0];
        __transposeKnob         = __VINYL_ASSET_NULL;
        __transposeKnobOverride = false;
    }
    
    static __SerializeShared = function(_struct)
    {
        _struct.type                  = __patternType;
        _struct.name                  = __name;
        
        _struct.gainOption            = __gainOption;
        _struct.gainKnob              = __gainKnob;
        _struct.gainKnobOverride      = __gainKnobOverride;
        _struct.gain                  = variable_clone(__gain);
        
        _struct.pitchOption           = __pitchOption;
        _struct.pitchKnob             = __pitchKnob;
        _struct.pitchKnobOverride     = __pitchKnobOverride;
        _struct.pitch                 = variable_clone(__pitch);
        
        _struct.loopOption            = __loopOption;
        _struct.loop                  = __loop;
        
        _struct.labelsOption          = __labelsOption;
        _struct.labels                = variable_clone(__labelsArray);
        
        _struct.stackOption           = __stackOption;
        _struct.stack                 = __stackName;
        _struct.stackPriority         = __stackPriority;
        
        _struct.effectChainOption     = __effectChainOption;
        _struct.effectChain           = __effectChainName;
        
        _struct.persistentOption      = __persistentOption;
        _struct.persistent            = __persistent;
        
        _struct.transposeOption       = __transposeOption;
        _struct.transposeKnob         = __transposeKnob;
        _struct.transposeKnobOverride = __transposeKnobOverride;
        _struct.transpose             = variable_clone(__transpose);
    }
    
    static __DeserializeShared = function(_struct, _child)
    {
        //TODO - Decompress on load
        
        __child                 = _child;
        __name                  = _struct.name;
        
        __gainOption            = _struct.gainOption;
        __gainKnob              = _struct.gainKnob;
        __gainKnobOverride      = _struct.gainKnobOverride;
        __gain                  = variable_clone(_struct.gain);
        
        __pitchOption           = _struct.pitchOption;
        __pitchKnob             = _struct.pitchKnob;
        __pitchKnobOverride     = _struct.pitchKnobOverride;
        __pitch                 = variable_clone(_struct.pitch);
        
        __loopOption            = _struct.loopOption;
        __loop                  = _struct.loop;
        
        __labelsOption          = _struct.labelsOption;
        __labelsArray           = variable_clone(_struct.labels);
        
        __stackOption           = _struct.stackOption;
        __stackName             = _struct.stack;
        __stackPriority         = _struct.stackPriority;
        
        __effectChainOption     = _struct.effectChainOption;
        __effectChainName       = _struct.effectChain;
        
        __persistentOption      = _struct.persistentOption;
        __persistent            = _struct.persistent;
        
        __transposeOption       = _struct.transposeOption;
        __transposeKnob         = _struct.transposeKnob;
        __transposeKnobOverride = _struct.transposeKnobOverride;
        __transpose             = variable_clone(_struct.transpose);
    }
    
    static __CopyTo = function(_new)
    {
        _new.__Reset();
        
        _new.__name                  = __name;
        _new.__child                 = __child;
        
        _new.__gainOption            = __gainOption;
        _new.__gainKnob              = __gainKnob;
        _new.__gainKnobOverride      = __gainKnobOverride;
        _new.__gain                  = variable_clone(__gain);
        
        _new.__pitchOption           = __pitchOption;
        _new.__pitchKnob             = __pitchKnob;
        _new.__pitchKnobOverride     = __pitchKnobOverride;
        _new.__pitch                 = variable_clone(__pitch);
        
        _new.__loopOption            = __loopOption;
        _new.__loop                  = __loop;
        
        _new.__labelsOption          = __labelsOption;
        _new.__labelsArray           = variable_clone(__labelsArray);
        
        _new.__stackOption           = __stackOption;
        _new.__stackName             = __stackName;
        _new.__stackPriority         = __stackPriority;
        
        _new.__effectChainOption     = __effectChainOption;
        _new.__effectChainName       = __effectChainName;
        
        _new.__persistentOption      = __persistentOption;
        _new.__persistent            = __persistent;
        
        _new.__transposeOption       = __transposeOption;
        _new.__transposeKnob         = __transposeKnob;
        _new.__transposeKnobOverride = __transposeKnobOverride;
        _new.__transpose             = variable_clone(__transpose);
    }
    
    static __Store = function(_document)
    {
        var _patternDict  = _document.__patternDict;
        var _patternArray = _document.__patternArray;
        
        _patternDict[$ __name] = self;
        array_push(_patternArray, self);
    }
    
    static __Migrate = function()
    {
        if (__effectChainName == undefined)
        {
            var _j = 0;
            repeat(array_length(__labelArray))
            {
                var _labelStruct = __labelArray[_j];
                
                if (_labelStruct.__effectChainName != undefined)
                {
                    if (__effectChainName == undefined)
                    {
                        __effectChainName = _labelStruct.__effectChainName;
                    }
                    else if (_labelStruct.__effectChainName != __effectChainName)
                    {
                        __VinylTrace("Warning! ", self, " has conflicting effect chains (chosen = \"", __effectChainName, "\", conflict = \"", _labelStruct.__effectChainName, "\" from ", _labelStruct, ")");
                    }
                }
                
                ++_j;
            }
        
            if ((__effectChainName != undefined) && !variable_struct_exists(__effectChainDict, __effectChainName))
            {
                __VinylError("Effect chain \"", __effectChainName, "\" for ", self, " doesn't exist");
            }
        }
    }
    
    static __GainSet = function(_gain)
    {
        __gain[0] = _gain;
        __gain[1] = _gain;
    }
    
    static __PitchSet = function(_pitch)
    {
        __pitch[0] = _pitch;
        __pitch[1] = _pitch;
    }
    
    static __LoopGet = function()
    {
        if (__loop == undefined)
        {
            var _i = 0;
            repeat(array_length(__labelArray))
            {
                var _labelStruct = __labelArray[_i];
                if (_labelStruct.__configLoop == true) return true;
                ++_i;
            }
            
            return undefined;
        }
        
        return __loop;
    }
    
    static __InitializeAssetArray = function(_assetArray, _tagArray)
    {
        __assetArray = _assetArray;
        
        //Convert any basic patterns into audio asset indexes
        var _i = 0;
        repeat(array_length(__assetArray))
        {
            var _asset = __assetArray[_i];
            
            if (is_struct(_asset))
            {
                //Generate an anonymous pattern
                var _patternName = __name + " > " + string(_i);
                __VInylPatternCreate(_patternName, _asset, false, true);
                _assetArray[@ _i] = _patternName;
            }
            else
            {
                if (is_string(_asset))
                {
                    if (VinylLiveUpdateGet())
                    {
                        if (not VinylAssetExists(_asset)) __VinylError("Error in ", self, " for \"assets\" property\nAsset \"", _asset, "\" not recognised");
                        _asset = VinylAssetGetIndex(_asset);
                    }
                    else
                    {
                        if (asset_get_index(_asset) < 0) __VinylError("Error in ", self, " for \"assets\" property\nAsset \"", _asset, "\" not found in the project");
                        if (asset_get_type(_asset) != asset_sound) __VinylError("Error in ", self, " for \"assets\" property\nAsset \"", _asset, "\" not a sound asset");
                        _asset = asset_get_index(_asset);
                    }
                }
                
                if (!is_numeric(_asset)) __VinylError("Error in ", self, " for \"assets\" property\nAssets should be specified as an audio asset index or audio asset name (datatype=", typeof(_asset), ")");
                if (!audio_exists(_asset)) __VinylError("Error in ", self, " for \"assets\" property\nAudio asset with index ", _asset, " not found");
                
                __assetArray[@ _i] = _asset;
            }
            
            ++_i;
        }
        
        //Append any asset we find from tags
        if (_tagArray != undefined)
        {
            if (not is_array(_tagArray))
            {
                if (is_string(_tagArray))
                {
                    _tagArray = [_tagArray];
                }
                else
                {
                    __VinylError("Error in ", self, " for \"assetsWithTag\" property\nDatatype must be an array, string, or undefined, was ", typeof(_tagArray));
                }
            }
            
            var _i = 0;
            repeat(array_length(_tagArray))
            {
                var _tag = _tagArray[_i];
                var _foundAssetArray = tag_get_asset_ids(_tag, asset_sound);
                if (is_array(_foundAssetArray) && (array_length(_foundAssetArray) > 0))
                {
                    var _j = 0;
                    repeat(array_length(_foundAssetArray))
                    {
                        var _assetIndex = _foundAssetArray[_j];
                        if (!array_contains(__assetArray, _assetIndex))
                        {
                            array_push(__assetArray, _assetIndex);
                        }
                        
                        ++_j;
                    }
                }
                else
                {
                    __VinylTrace("Warning! No sound assets found for tag name \"", _tag, "\"");
                }
                
                ++_i;
            }
        }
        
        if (array_length(_assetArray) <= 0) __VinylError("Error in ", self, "\n", __patternType, "-type patterns must have at least one asset");
    }
    
    static __InitializeGain = function(_gain)
    {
        //__gain[0] = 1;
        //__gain[1] = 1;
    }
    
    static __InitializePitch = function(_pitch)
    {
        //__pitch[0] = 1;
        //__pitch[1] = 1;
    }
    
    static __InitializeTranspose = function(_transpose)
    {
        //__transpose = undefined;
    }
    
    static __InitializeLoop = function(_loop)
    {
        //__loop = undefined;
    }
    
    static __InitializePersistent = function(_persistent)
    {
        //__persistent = undefined;
    }
    
    static __InitializeStack = function(_stack, _stackPriority)
    {
        //__stackName     = undefined;
        //__stackPriority = undefined;
    }
    
    static __InitializeEffectChain = function(_effectChainName)
    {
        //__effectChainName = undefined;
    }
    
    static __InitializeLoopPoints = function(_loopPoints)
    {
        //_loopPoints = undefined; //Otherwise must be a 2-element array
    }
    
    static __InitializeLabelArray = function(_labelNameArray)
    {
        //__labelArray = [];
    }
}
