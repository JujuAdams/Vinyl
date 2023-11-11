// Feather disable all

function __VinylMultiselectSelectExclusive(_stateStruct, _name)
{
    var _selectedDict = _stateStruct.__selectedDict;
    
    _stateStruct.__selectedDict = {};
    _selectedDict = _stateStruct.__selectedDict;
    
    _selectedDict[$ _name] = true;
    _stateStruct.__lastSelected = _name;
    
    return _selectedDict;
}