function __VinylGuiCheckStates()
{
    static _globalData = __VinylGlobalData();
    
	var _stateArray = _globalData.__stackArray;
	
	var _i = 0;
	repeat(array_length(_stateArray))
	{
		var _stateStruct = _stateArray[_i];
	    var _target        = _stateStruct.__target;
	    var _stateCurrent  = _stateStruct.__current;
	    var _statePrevious = _stateStruct.__previous;
		
	    var _changed = false;
		
	    var _namesArray = variable_struct_get_names(_stateCurrent);
	    var _i = 0;
	    repeat(array_length(_namesArray))
	    {
	        var _name = _namesArray[_i];
			
	        var _oldValue = _stateCurrent[$  _name];
	        var _newValue = _statePrevious[$ _name];
			
	        if (_oldValue != _newValue)
	        {
	            __VinylTrace("Detected change in ", _target, " via GUI, ", _name);
	            _statePrevious[$ _name] = _newValue;
	            _changed = true;
	        }
			
	        ++_i;
	    }
		
	    if (_changed)
	    {
	        __VinylTrace("Detected change in ", _target, " via GUI, updating");
	        _target.__GuiImportStruct(_stateCurrent);
	        _target.__GuiExportStruct(_stateCurrent);
	    }
		
		++_i;
	}
}