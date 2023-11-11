// Feather disable all

function __VinylMultiselectDelete(_stateStruct, _resourceDict, _resourceNameArray)
{
    var _selectedDict = _stateStruct.__selectedDict;
    
    if ((variable_struct_names_count(_selectedDict) > 0) && (array_length(_resourceNameArray) > 0))
    {
        var _deleted = false;
        var _nextSelected = undefined;
        
        var _i = 0;
        repeat(array_length(_resourceNameArray))
        {
            var _name = _resourceNameArray[_i];
            if (variable_struct_exists(_selectedDict, _name))
            {
                if ((not _deleted) && (_nextSelected == undefined) && (_i > 0))
                {
                    _nextSelected = _resourceNameArray[_i-1];
                }
                
                _deleted = true;
                
                variable_struct_remove(_resourceDict, _name);
                array_delete(_resourceNameArray, _i, 1);
            }
            else
            {
                ++_i;
            }
        }
        
        _stateStruct.__selectedDict = {};
        _selectedDict = _stateStruct.__selectedDict;
        
        if (_nextSelected != undefined)
        {
            _selectedDict[$ _nextSelected] = true;
            _stateStruct.__lastSelected = _nextSelected;
        }
        else if (array_length(_resourceNameArray) > 0)
        {
            _selectedDict[$ _resourceNameArray[0]] = true;
            _stateStruct.__lastSelected = _resourceNameArray[0];
        }
    }
    
    return _selectedDict;
}