function __VinylGuiCheckVisibility()
{
    static _globalData = __VinylGlobalData();
    
    var _anyChanged = false;
    var _anyVisible = false;
	
	with(_globalData.__uiData)
	{
		var _arrayOfArrays = [__assetVisArray,
                              __patternVisArray,
                              __labelVisArray,
                              __stackVisArray,
                              __effectChainVisArray,
                              __knobVisArray];
	}
	
	var _j = 0;
	repeat(array_length(_arrayOfArrays))
	{
		var _checkArray = _arrayOfArrays[_j];
		
	    var _i = 0;
	    repeat(array_length(_checkArray))
	    {
	        with(_checkArray[_i])
	        {
	            if (__visible != __oldVisibility)
	            {
	                _anyChanged = true;
	                __oldVisibility = __visible;
	            }
            
	            if (__visible) _anyVisible = true;
	        }
        
	        ++_i;
	    }
		
		++_j;
	}
    
    if (!_anyChanged) return;
    
	var _stateArray = _globalData.__uiData.__stateArray;
	array_resize(_stateArray, 0);
	
    dbg_view_delete(_globalData.__uiData.__pointerProperties);
    _globalData.__uiData.__pointerProperties = dbg_view("Vinyl Properties", _anyVisible);
	
	var _j = 0;
	repeat(array_length(_arrayOfArrays))
	{
		var _checkArray = _arrayOfArrays[_j];
		
	    var _i = 0;
	    repeat(array_length(_checkArray))
	    {
	        var _struct = _checkArray[_i];
	        if (_struct.__visible)
	        {
				var _state = new __VinylClassGuiState(_struct.__target);
				_state.__BuildGui();
				
				array_push(_stateArray, _state);
	        }
        
	        ++_i;
	    }
		
		++_j;
	}
}