// Feather disable all

/// @param stateDict
/// @param resourceDict
/// @param resourceName
/// @param constructor

function __VinylMultiselectAdd(_stateStruct, _resourceDict, _resourceTypeName, _constructor)
{
    var _selectedDict = _stateStruct.__selectedDict;
    
    var _index = 1;
    var _newName = _resourceTypeName + " " + string(_index);
    while(variable_struct_exists(_resourceDict, _newName))
    {
        ++_index;
        _newName = _resourceTypeName + " " + string(_index);
    }
    
    _resourceDict[$ _newName] = new _constructor();
    
    if (_stateStruct.__multiselect)
    {
        _selectedDict[$ _newName] = true;
        _stateStruct.__lastSelected = _newName;
    }
    else
    {
        _stateStruct.__selectedDict = {};
        _selectedDict = _stateStruct.__selectedDict;
        
        _selectedDict[$ _newName] = true;
        _stateStruct.__lastSelected = _newName;
    }
    
    return _selectedDict;
}