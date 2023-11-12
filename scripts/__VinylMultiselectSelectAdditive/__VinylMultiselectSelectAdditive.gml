// Feather disable all

function __VinylMultiselectSelectAdditive(_stateStruct, _name, _state)
{
    var _selectedDict = _stateStruct.__selectedDict;
    
    if (_state)
    {
        _selectedDict[$ _name] = true;
        _stateStruct.__lastSelected = _name;
    }
    else
    {
        variable_struct_remove(_selectedDict, _name);
    }
    
    return _selectedDict;
}