// Feather disable all

/// @param dataStruct
/// @param parentStruct

function __VinylPatternResolveInheritedLabel(_dataStruct, _parentStruct, _inheritedArray)
{
    switch(is_struct(_dataStruct)? _dataStruct.__labelsOption : __VINYL_OPTION_UNSET)
    {
        case __VINYL_OPTION_UNSET:
            if (_parentStruct == undefined) return;
            __VinylPatternResolveInheritedLabel(_parentStruct, undefined, _inheritedArray);
        break;
        
        case __VINYL_OPTION_ADD:
            __VinylPatternResolveInheritedLabel(_parentStruct, undefined, _inheritedArray);
            
            var _labelArray = _dataStruct.__labelsArray;
            var _i = 0;
            repeat(array_length(_labelArray))
            {
                var _label = _labelArray[_i];
                
                if (not array_contains(_inheritedArray, _label))
                {
                    array_push(_inheritedArray, _label);
                }
                
                ++_i;
            }
        break;
        
        case __VINYL_OPTION_OVERRIDE:
            array_resize(_inheritedArray, 0);
            
            var _labelArray = _dataStruct.__labelsArray;
            array_copy(_inheritedArray, 0, _labelArray, 0, array_length(_labelArray));
        break;
    }
}