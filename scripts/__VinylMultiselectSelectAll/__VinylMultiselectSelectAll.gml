// Feather disable all

function __VinylMultiselectSelectAll(_stateStruct, _resourceNameArray)
{
    _stateStruct.__selectedDict = {};
    var _selectedDict = _stateStruct.__selectedDict;
    
    var _i = 0;
    repeat(array_length(_resourceNameArray))
    {
        _selectedDict[$ _resourceNameArray[_i]] = true;
        ++_i;
    }
    
    return _selectedDict;
}