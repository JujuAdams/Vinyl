/// @param stringOrData

function VinylSettingsAssertValid(_inputData)
{
    static _system = __VinylSystem();
    static _mixGroupArray = _system.__mixGroupArray;
    
    //Helper functions
    var _assertStruct = function(_value, _throwMessage)
    {
        if (is_struct(_value))
        {
            return true;
        }
        else
        {
            throw $"{_throwMessage} (was \"{typeof(_value)}\")";
        }
        
        return false;
    }
    
    var _assertStructOrNull = function(_value, _throwMessage)
    {
        if (is_struct(_value))
        {
            return true;
        }
        else if (_value != undefined)
        {
            throw $"{_throwMessage} (was \"{typeof(_value)}\")";
        }
        
        return false;
    }
    
    var _assertNumericOrNull = function(_value, _throwMessage)
    {
        if (is_numeric(_value) || is_bool(_value))
        {
            return true;
        }
        else if (_value != undefined)
        {
            throw $"{_throwMessage} (was \"{typeof(_value)}\")";
        }
        
        return false;
    }
    
    //Convert to raw data if we're a string
    if (is_string(_inputData))
    {
        try
        {
            _inputData = json_parse(_inputData);
        }
        catch(_error)
        {
            __VinylTrace(_error);
            throw "Failed to parse input string as JSON";
        }
    }
    
    //Perform the validation asserts
    _assertStruct(_inputData, $"Input data root must be a struct");
    
    if (_assertStructOrNull(_inputData[$ "master"], "`.master` value must be a struct"))
    {
        _assertNumericOrNull(_inputData.master[$ "gain"], "`.master.gain` must be a number");
        _assertNumericOrNull(_inputData.master[$ "mute"], "`.master.mute` must be a number");
    }
    else
    {
        __VinylTrace("Warning! `.master` missing in input data");
    }
    
    if (_assertStructOrNull(_inputData[$ "mixGroup"], "`.mixGroup` value must be a struct"))
    {
        var _inputMixGroupsData = _inputData.mixGroup;
        var _i = 0;
        repeat(array_length(_mixGroupArray))
        {
            var _exportName = _mixGroupArray[_i].__exportName;
            var _inputMixGroupData = _inputMixGroupsData[$ _exportName];
            
            if (_assertStructOrNull(_inputMixGroupData, $"`.mixGroup.{_exportName}` value must be a struct"))
            {
                _assertNumericOrNull(_inputMixGroupData[$ "gain"], $"`.mixGroup.{_exportName}.gain` must be a number");
                _assertNumericOrNull(_inputMixGroupData[$ "mute"], $"`.mixGroup.{_exportName}.mute` must be a number");
            }
            else
            {
                __VinylTrace($"Warning! `.mixGroup.{_exportName}` missing in input data");
            }
            
            ++_i;
        }
    }
    else
    {
        __VinylTrace("Warning! `.mixGroup` missing in input data");
    }
}