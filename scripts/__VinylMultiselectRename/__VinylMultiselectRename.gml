// Feather disable all
function __VinylMultiselectRename(_stateStruct, _resourceDict, _oldName, _newName)
{
    _resourceDict[$ _newName] = _resourceDict[$ _oldName];
    variable_struct_remove(_resourceDict, _oldName);
    
    _stateStruct.__selectedDict = {};
    var _selectedDict = _stateStruct.__selectedDict;
    
    _selectedDict[$ _newName] = true;
    _stateStruct.__lastSelected = _newName;
    
    return _selectedDict;
}