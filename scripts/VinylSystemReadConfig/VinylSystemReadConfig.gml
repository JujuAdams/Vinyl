/// Reads in a data struct, seting asset and label definitions as required
/// This is useful for e.g. writing your own live mixing system
/// 
/// @param configData

function VinylSystemReadConfig(_configData)
{
    static _globalData       = __VinylGlobalData();
    static _basicPoolPlaying = _globalData.__basicPoolPlaying;
    static _effectChainDict  = _globalData.__effectChainDict;
    static _effectChainArray = _globalData.__effectChainArray;
    
    var _oldKnobDict = _globalData.__knobDict;
    
    var _newKnobDict     = {};
    var _newKnobArray    = [];
    var _newPatternDict  = {};
    var _newPatternOrder = [];
    var _newLabelDict    = {};
    var _newLabelOrder   = [];
    
    
    
    //Create new knobs and inherit values where possible
    var _inputKnobDict = _configData[$ "knobs"];
    if (is_undefined(_inputKnobDict))
    {
        __VinylTrace("Warning! \"knobs\" data missing");
    }
    else if (!is_struct(_inputKnobDict))
    {
        __VinylError("\"knobs\" data should be defined as an object (struct)");
    }
    else
    {
        var _knobNameArray = variable_struct_get_names(_inputKnobDict);
        var _i = 0;
        repeat(array_length(_knobNameArray))
        {
            var _knobName = _knobNameArray[_i];
            
            //Create a new knob
            var _newKnob = new __VinylClassKnob(_knobName, _newKnobDict, _newKnobArray);
            _newKnob.__Initialize(_inputKnobDict[$ _knobName]);
            
            //Copy the old value from the old knob if possible
            var _oldKnob = _oldKnobDict[$ _knobName];
            if (is_struct(_oldKnob)) _newKnob.__value = _oldKnob.__value;
            
            ++_i;
        }
    }
    
    
    
    //Instantiate labels, creating a dictionary for lookup and an array that contains the order to update the labels to respect parenting
    static _loadLabelsFunc = function(_loadLabelsFunc, _newLabelDict, _newLabelOrder, _inputLabelDict, _parent)
    {
        var _nameArray = variable_struct_get_names(_inputLabelDict);
        var _i = 0;
        repeat(array_length(_nameArray))
        {
            var _labelName = _nameArray[_i];
            
            if (string_count(" ", _labelName) > 0)
            {
                __VinylTrace("Warning! Label names cannot contain spaces. \"", _labelName, "\" will be ignored");
                ++_i;
                continue;
            }
            
            var _labelData = _inputLabelDict[$ _labelName];
            var _label = new __VinylClassLabel(_labelName, _parent, false, _labelData);
            
            _newLabelDict[$ _labelName] = _label;
            array_push(_newLabelOrder, _label);
            
            if (is_struct(_labelData) && variable_struct_exists(_labelData, "children"))
            {
                var _childrenDict = _labelData[$ "children"];
                if (is_struct(_childrenDict))
                {
                    _loadLabelsFunc(_loadLabelsFunc, _newLabelDict, _newLabelOrder, _childrenDict, _label);
                }
                else
                {
                    __VinylTrace("Warning! Label \"", _labelName, "\" has an invalid \"children\" dictionary");
                }
            }
            
            ++_i;
        }
    }
    
    var _inputLabelDict = _configData[$ "labels"];
    if (is_undefined(_inputLabelDict))
    {
        __VinylTrace("Warning! \"labels\" data missing");
    }
    else if (!is_struct(_inputLabelDict))
    {
        __VinylError("\"labels\" data should be defined as an object (struct)");
    }
    else
    {
        _loadLabelsFunc(_loadLabelsFunc, _newLabelDict, _newLabelOrder, _inputLabelDict, undefined);
        
        //Copy state data from old labels to new labels
        var _oldLabelDict = _globalData.__labelDict;
        var _i = 0;
        repeat(array_length(_newLabelOrder))
        {
            var _newLabel = _newLabelOrder[_i];
            var _oldLabel = _oldLabelDict[$ _newLabel.__name];
            if (is_struct(_oldLabel)) _newLabel.__CopyOldState(_oldLabel);
            ++_i;
        }
    }
    
    
    
    //Instantiate assets
    var _inputAssetDict = _configData[$ "assets"];
    if (is_undefined(_inputAssetDict))
    {
        __VinylTrace("Warning! \"assets\" data missing");
    }
    else if (!is_struct(_inputAssetDict))
    {
        __VinylError("\"assets\" data should be defined as an object (struct)");
    }
    else
    {
        var _assetNameArray = variable_struct_get_names(_inputAssetDict);
        var _i = 0;
        repeat(array_length(_assetNameArray))
        {
            var _assetName = _assetNameArray[_i];
        
            var _assetIndex = asset_get_index(_assetName);
            if ((_assetIndex < 0) && (_assetName != "fallback"))
            {
                __VinylTrace("Warning! Asset \"", _assetName, "\" doesn't exist");
            }
            else if ((asset_get_type(_assetName) != asset_sound) && (_assetName != "fallback"))
            {
                __VinylTrace("Warning! Asset \"", _assetName, "\" isn't a sound");
            }
            else
            {
                var _key = (_assetName == "fallback")? "fallback" : string(_assetIndex);
                if (variable_struct_exists(_newPatternDict, _key))
                {
                    __VinylTrace("Warning! Asset \"", _key, "\" has already been defined");
                }
                else
                {
                    //Pull out the asset data
                    var _assetData = _inputAssetDict[$ _assetName];
                    
                    //Make a new basic pattern for this asset
                    _newPatternDict[$ _key] = new __VinylClassBasicPattern(_assetIndex, _newPatternOrder, _newLabelDict, _assetData);
                    
                    //Apply this asset data to all of the named "copyTo" assets
                    var _copyToArray = _assetData[$ "copyTo"];
                    if (is_string(_copyToArray)) _copyToArray = [_copyToArray]; //Create an array out of a string if needed
                    
                    if (is_array(_copyToArray))
                    {
                        var _j = 0;
                        repeat(array_length(_copyToArray))
                        {
                            var _copyToName = _copyToArray[_j];
                            var _copyToIndex = asset_get_index(_copyToName);
                            var _copyToKey = string(_copyToIndex);
                            
                            if (_copyToName == "fallback")
                            {
                                __VinylTrace("Warning! Cannot copy to fallback asset (parent asset=\"", _assetName, "\")");;
                            }
                            else if (_copyToIndex < 0)
                            {
                                __VinylTrace("Warning! copyTo asset \"", _copyToName, "\" doesn't exist (parent asset=\"", _assetName, "\")");
                            }
                            else if (asset_get_type(_copyToName) != asset_sound)
                            {
                                __VinylTrace("Warning! copyTo asset \"", _copyToName, "\" isn't a sound (parent asset=\"", _assetName, "\")");
                            }
                            else if (variable_struct_exists(_newPatternDict, _copyToKey))
                            {
                                __VinylTrace("Warning! copyTo asset \"", _copyToName, "\" has already been defined (parent asset=\"", _assetName, "\")");
                            }
                            else
                            {
                                //Make a basic pattern for this copyTo asset
                                _newPatternDict[$ _copyToKey] = new __VinylClassBasicPattern(_copyToIndex, _newPatternOrder, _newLabelDict, _assetData);
                            }
                            
                            ++_j;
                        }
                    }
                }
            }
            
            ++_i;
        }
    }
    
    //Ensure we have a fallback struct for audio assets
    if (!variable_struct_exists(_newPatternDict, "fallback"))
    {
        if (VINYL_DEBUG_READ_CONFIG) __VinylTrace("Fallback asset case doesn't exist, creating one");
        _newPatternDict.fallback = new __VinylClassBasicPattern(-1, _newPatternOrder, _newLabelDict);
    }
    
    
    
    //Iterate over every label and collect up sound assets with tags that match the label's definition
    var _i = 0;
    repeat(array_length(_newLabelOrder))
    {
        var _labelData = _newLabelOrder[_i];
        var _tagArray = _labelData.__tagArray;
        
        if (is_array(_tagArray))
        {
            var _j = 0;
            repeat(array_length(_tagArray))
            {
                var _tag = _tagArray[_j];
                var _assetArray = tag_get_asset_ids(_tag, asset_sound);
                if (is_array(_assetArray))
                {
                    var _k = 0;
                    repeat(array_length(_assetArray))
                    {
                        var _assetIndex = _assetArray[_k];
                        var _key = string(_assetIndex);
                        
                        var _assetData = _newPatternDict[$ _key];
                        if (!is_struct(_assetData))
                        {
                            _assetData = new __VinylClassBasicPattern(_assetIndex, _newPatternOrder, _newLabelDict, undefined);
                            _newPatternDict[$ _key] = _assetData;
                        }
                        
                        _labelData.__BuildAssetLabelArray(_assetData.__labelArray, _assetData.__labelDictTemp__);
                        
                        ++_k;
                    }
                }
                
                ++_j;
            }
        }
        
        ++_i;
    }
    
    
    
    //Instantiate patterns
    var _inputPatternsDict = _configData[$ "patterns"];
    if (is_undefined(_inputAssetDict))
    {
        __VinylTrace("Warning! \"patterns\" data missing");
    }
    else if (!is_struct(_inputAssetDict))
    {
        __VinylError("\"patterns\" data should be defined as an object (struct)");
    }
    else
    {
        var _patternNameArray = variable_struct_get_names(_inputPatternsDict);
        var _i = 0;
        repeat(array_length(_patternNameArray))
        {
            var _patternName = _patternNameArray[_i];
            
            var _patternData = _inputPatternsDict[$ _patternName];
            
            if (variable_struct_exists(_patternData, "basic"))
            {
                var _newPattern = new __VinylClassBasicPattern(asset_get_index(_patternData.basic), _newPatternOrder, _newLabelDict, _patternData);
            }
            else if (variable_struct_exists(_patternData, "shuffle"))
            {
                var _newPattern = new __VinylClassShufflePattern(_patternName, _newPatternOrder, _newLabelDict, _patternData);
            }
            else
            {
                __VinylError("Defintion for pattern \"", _patternName, "\" is invalid");
            }
            
            _newPatternDict[$ _patternName] = _newPattern;
            
            ++_i;
        }
    }
    
    
    
    //Set up effect chains
    var _inputEffectChainDict = _configData[$ "effect chains"];
    if (is_undefined(_inputAssetDict))
    {
        __VinylTrace("Warning! \"effect chains\" data missing");
    }
    else if (!is_struct(_inputAssetDict))
    {
        __VinylError("\"effect chains\" data should be defined as an object (struct)");
    }
    else
    {
        var _effectChainNameArray = variable_struct_get_names(_inputEffectChainDict);
        var _i = 0;
        repeat(array_length(_effectChainNameArray))
        {
            var _effectChainName = _effectChainNameArray[_i];
            __VinylEffectChainEnsure(_effectChainName).__Update(_inputEffectChainDict[$ _effectChainName]);
            ++_i;
        }
    }
    
    //Clean up any unmentioned effect chains
    var _i = 0;
    repeat(array_length(_effectChainArray))
    {
        var _effectChain = _effectChainArray[_i];
        var _effectChainName = _effectChain.__name;
        
        if ((_effectChainName != "main") && !variable_struct_exists(_inputEffectChainDict, _effectChainName))
        {
            _effectChain.__Destroy();
            variable_struct_remove(_effectChainDict, _effectChainName);
            array_delete(_effectChainArray, _i, 1);
        }
        else
        {
            ++_i;
        }
    }
    
    
    
    var _i = 0;
    repeat(array_length(_newPatternOrder))
    {
        var _pattern = _newPatternOrder[_i];
        
        //Try to figure out what effect chain to use
        with(_pattern)
        {
            if (__effectChainName == undefined)
            {
                var _j = 0;
                repeat(array_length(__labelArray))
                {
                    var _labelStruct = __labelArray[_j];
                    
                    if (__effectChainName == undefined)
                    {
                        __effectChainName = _labelStruct.__effectChainName;
                    }
                    else if (_labelStruct.__effectChainName != __effectChainName)
                    {
                        __VinylTrace("Warning! Pattern \"", __name, "\" has conflicting effect chains (chosen = \"", __effectChainName, "\", conflict = \"", _labelStruct.__effectChainName, "\" from label \"", _labelStruct.__name, "\")");
                    }
                    
                    ++_j;
                }
                
                if (__effectChainName == undefined) __effectChainName = "main";
            }
            
            if (!variable_struct_exists(_effectChainDict, __effectChainName))
            {
                __VinylError("Effect chain \"", __effectChainName, "\" for pattern \"", __name, "\" doesn't exist");
            }
        }
        
        //Clean up some unnecesasry memory
        variable_struct_remove(_pattern, "__labelDictTemp__");
        
        ++_i;
    }
    
    
    
    //Update all values from knobs
    var _i = 0;
    repeat(array_length(_newKnobArray))
    {
        _newKnobArray[_i].__Refresh();
        ++_i;
    }
    
    
    
    //Update our global label/pattern tracking
    _globalData.__patternDict = _newPatternDict;
    _globalData.__labelDict   = _newLabelDict;
    _globalData.__labelOrder  = _newLabelOrder;
    
    //Force an update for all playing instances
    var _i = 0;
    repeat(array_length(_basicPoolPlaying))
    {
        with(_basicPoolPlaying[_i])
        {
            __ApplyLabel(true);
            __LoopPointsSet();
            __outputChanged = true;
        }
        
        ++_i;
    }
    
    
    
    //Workaround for problems setting effects on the main audio effect bus in 2023.1
    gc_collect();
}