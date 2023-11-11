// Feather disable all

function __VinylMultiselectIsSelected(_stateStruct, _name)
{
    var _selectedDict = _stateStruct.__selectedDict;
    return _selectedDict[$ _name] ?? false;
}