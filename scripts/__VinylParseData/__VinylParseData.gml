/// @param rawData
/// @param strict

function __VinylParseData(_rawData, _strict)
{
    var _newAssetDict  = {};
    var _newLabelDict  = {};
    var _newLabelOrder = [];
    
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
    
    _loadLabelsFunc(_loadLabelsFunc, _newLabelDict, _newLabelOrder, _rawData.labels, undefined);
    
    //Instantiate assets
    var _inputAssetDict = _rawData.assets;
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
            var _newAsset = new __VinylClassAsset(_assetIndex, _newLabelDict, _assetData);
            
            var _key = (_assetName == "fallback")? "fallback" : string(_assetIndex);
            _newAssetDict[$ _key] = _newAsset;
        }
        
        ++_i;
    }
    
    //Ensure we have a fallback struct for audio assets
    if (!variable_struct_exists(_newAssetDict, "fallback"))
    {
        if (VINYL_DEBUG_PARSER) __VinylTrace("Fallback asset case doesn't exist, creating one");
        _newAssetDict.fallback = new __VinylClassAsset(-1, _newLabelDict);
    }
    
    //Copy state data from old labels to new labels
    var _i = 0;
    repeat(array_length(_newLabelOrder))
    {
        var _newLabel = _newLabelOrder[_i];
        var _oldLabel = global.__vinylLabelDict[$ _newLabel.__name];
        if (is_struct(_oldLabel)) _newLabel.__CopyOldState(_oldLabel);
        ++_i;
    }
    
    //Update our global label/asset tracking
    global.__vinylAssetDict  = _newAssetDict;
    global.__vinylLabelDict  = _newLabelDict;
    global.__vinylLabelOrder = _newLabelOrder;
    
    //Force an update for all playing instances
    var _i = 0;
    repeat(array_length(global.__vinylPlaying))
    {
        with(global.__vinylPlaying[_i])
        {
            __RecalculateLabels();
            __outputChanged = true;
        }
        
        ++_i;
    }
}