/// Reads in a data struct, seting asset and label definitions as required
/// This is useful for e.g. writing your own live mixing system
/// 
/// @param configData

function VinylSystemReadConfig(_configData)
{
    var _newPatternDict = {};
    var _newLabelDict   = {};
    var _newLabelOrder  = [];
    
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
            var _assetData = _inputAssetDict[$ _assetName];
            var _newAsset = new __VinylClassBasicPattern(_assetIndex, _newLabelDict, _assetData);
            
            var _key = (_assetName == "fallback")? "fallback" : string(_assetIndex);
            _newPatternDict[$ _key] = _newAsset;
        }
        
        ++_i;
    }
    
    //Ensure we have a fallback struct for audio assets
    if (!variable_struct_exists(_newPatternDict, "fallback"))
    {
        if (VINYL_DEBUG_READ_CONFIG) __VinylTrace("Fallback asset case doesn't exist, creating one");
        _newPatternDict.fallback = new __VinylClassBasicPattern(-1, _newLabelDict);
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
            var _newPattern = new __VinylClassBasicPattern(asset_get_index(_patternData.basic), _newLabelDict, _patternData);
        }
        else if (variable_struct_exists(_patternData, "shuffle"))
        {
            var _newPattern = new __VinylClassShufflePattern(_patternName, _newLabelDict, _patternData);
        }
        else
        {
            __VinylError("Defintion for pattern \"", _patternName, "\" is invalid");
        }
        
        _newPatternDict[$ _patternName] = _newPattern;
        
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
            __ApplyLabel();
            __outputChanged = true;
        }
        
        ++_i;
    }
}