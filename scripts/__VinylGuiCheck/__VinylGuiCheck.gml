function __VinylGuiCheck()
{
    static _globalData = __VinylGlobalData();
    
    var _patternVisArray = _globalData.__uiData.__patternVisArray;
    
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
    
    dbg_view_delete(_globalData.__uiData.__pointerProperties);
    _globalData.__uiData.__pointerProperties = dbg_view("Vinyl Properties", _anyVisible);
    
    var _i = 0;
    repeat(array_length(_patternVisArray))
    {
        var _struct = _patternVisArray[_i];
        if (_struct.__visible)
        {
            var _pattern = _struct.__link;
            
            dbg_section(_pattern.__GetDisplayName());
            
            var _guiStruct = {};
            
            _pattern.__GuiExportStruct(_guiStruct);
            _pattern.__GuiBuildForStruct(_guiStruct);
            dbg_button("Apply", function()
            {
                __VinylGuiCheckForChanges();
            });
            
            _globalData.__guiPattern  = _pattern;
            _globalData.__guiCurrent  = _guiStruct;
            _globalData.__guiPrevious = __VinylDeepCopy(_guiStruct);
        }
        
        ++_i;
    }
}