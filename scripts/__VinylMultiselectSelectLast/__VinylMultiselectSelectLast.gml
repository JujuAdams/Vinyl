// Feather disable all

function __VinylMultiselectSelectLast(_stateStruct, _resourceDict)
{
    _stateStruct.__selectedDict = {};
    var _selectedDict = _stateStruct.__selectedDict;
    
    var _lastSelected = _stateStruct.__lastSelected;
    if ((_lastSelected != undefined) && variable_struct_exists(_resourceDict, _lastSelected))
    {
        _selectedDict[$ _lastSelected] = true;
    }
    else
    {
        _stateStruct.__lastSelected = undefined;
    }
    
    return _selectedDict;
}