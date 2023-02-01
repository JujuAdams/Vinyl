/// Reads in a data struct, seting asset and label definitions as required
/// This is useful for e.g. writing your own live mixing system
/// 
/// @param configData

function VinylSystemReadConfig(_configData)
{
    var _newPatternDict  = {};
    var _newPatternOrder = [];
    var _newLabelDict    = {};
    var _newLabelOrder   = [];
    
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
    
    _loadLabelsFunc(_loadLabelsFunc, _newLabelDict, _newLabelOrder, _configData.labels, undefined);
    
    //Copy state data from old labels to new labels
    var _i = 0;
    repeat(array_length(_newLabelOrder))
    {
        var _newLabel = _newLabelOrder[_i];
        var _oldLabel = global.__vinylLabelDict[$ _newLabel.__name];
        if (is_struct(_oldLabel)) _newLabel.__CopyOldState(_oldLabel);
        ++_i;
    }
    
    //Instantiate assets
    var _inputAssetDict = _configData.assets;
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
    var _inputPatternsDict = _configData.patterns;
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
    
    //Clean up some unnecesasry memory
    var _i = 0;
    repeat(array_length(_newPatternOrder))
    {
        var _pattern = _newPatternOrder[_i];
        variable_struct_remove(_pattern, "__labelDictTemp__");
        ++_i;
    }
    
    //Update our global label/pattern tracking
    global.__vinylPatternDict = _newPatternDict;
    global.__vinylLabelDict   = _newLabelDict;
    global.__vinylLabelOrder  = _newLabelOrder;
    
    //Force an update for all playing instances
    var _i = 0;
    repeat(array_length(global.__vinylBasicPlaying))
    {
        with(global.__vinylBasicPlaying[_i])
        {
            __ApplyLabel(true);
            __outputChanged = true;
        }
        
        ++_i;
    }
}