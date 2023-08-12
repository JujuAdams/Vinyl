function __VinylGuiUpdateVisiblity()
{
    static _globalData = __VinylGlobalData();
    
    var _patternArray     = _globalData.__patternArray;
    var _labelArray       = _globalData.__labelArray;
    var _stackArray       = _globalData.__stackArray;
    var _effectChainArray = _globalData.__effectChainArray;
    var _knobArray        = _globalData.__knobArray;
    
    var _assetVisArray       = _globalData.__uiData.__assetVisArray
    var _patternVisArray     = _globalData.__uiData.__patternVisArray;
    var _labelVisArray       = _globalData.__uiData.__labelVisArray;
    var _stackVisArray       = _globalData.__uiData.__stackVisArray;
    var _effectChainVisArray = _globalData.__uiData.__effectChainVisArray;
    var _knobVisArray        = _globalData.__uiData.__knobVisArray;
   
	with(_globalData.__uiData)
	{
		var _arrayOfArrays = [__assetVisArray,
                              __patternVisArray,
                              __labelVisArray,
                              __stackVisArray,
                              __effectChainVisArray,
                              __knobVisArray];
		
		var _i = 0;
		repeat(array_length(_arrayOfArrays))
		{
			array_resize(_arrayOfArrays[_i], 0);
			++_i;
		}
	}
	
    dbg_view_delete(_globalData.__uiData.__pointerMain);
    _globalData.__uiData.__pointerMain = dbg_view("Vinyl UI", false);
    
    dbg_section("File Control");
    dbg_button("Save To File", function()
    {
        show_message("!");
    });
	
	dbg_same_line();
	dbg_button("Apply Changes", function()
	{
		__VinylGuiCheckStates();
	});
	
    var _guiOrderArray = VINYL_GUI_SECTION_ORDER;
    var _s = 0;
    repeat(array_length(_guiOrderArray))
    {
        var _sectionName = _guiOrderArray[_s];
        dbg_section(_sectionName);
        
        switch(_sectionName)
        {
            case "Assets":
                var _i = 0;
                repeat(array_length(_patternArray))
                {
					var _patternStruct = _patternArray[_i];
					if (is_instanceof(_patternStruct, __VinylClassPatternAsset))
					{
	                    var _visibilityStruct = new __VinylClassGuiVisibility(_patternStruct);
	                    array_push(_assetVisArray, _visibilityStruct);
	                    dbg_checkbox(ref_create(_visibilityStruct, "__visible"), string(_patternStruct));
					}
                    
                    ++_i;
                }
            break;
            
            case "Patterns":
                var _i = 0;
                repeat(array_length(_patternArray))
                {
					var _patternStruct = _patternArray[_i];
					if (!is_instanceof(_patternStruct, __VinylClassPatternAsset))
					{
	                    var _visibilityStruct = new __VinylClassGuiVisibility(_patternStruct);
	                    array_push(_patternVisArray, _visibilityStruct);
	                    dbg_checkbox(ref_create(_visibilityStruct, "__visible"), string(_patternStruct));
					}
                    
                    ++_i;
                }
            break;
            
            case "Labels":
                var _i = 0;
                repeat(array_length(_labelArray))
                {
					var _labelStruct = _labelArray[_i];
					
	                var _visibilityStruct = new __VinylClassGuiVisibility(_labelStruct);
	                array_push(_labelVisArray, _visibilityStruct);
	                dbg_checkbox(ref_create(_visibilityStruct, "__visible"), string(_labelStruct));
                    
                    ++_i;
                }
            break;
            
            case "Stacks":
                var _i = 0;
                repeat(array_length(_stackArray))
                {
					var _stackStruct = _stackArray[_i];
					
	                var _visibilityStruct = new __VinylClassGuiVisibility(_stackStruct);
	                array_push(_stackVisArray, _visibilityStruct);
	                dbg_checkbox(ref_create(_visibilityStruct, "__visible"), string(_stackStruct));
                    
                    ++_i;
                }
            break;
            
            case "Effect Chains":
                var _i = 0;
                repeat(array_length(_effectChainArray))
                {
					var _effectChainStruct = _effectChainArray[_i];
					
	                var _visibilityStruct = new __VinylClassGuiVisibility(_effectChainStruct);
	                array_push(_effectChainVisArray, _visibilityStruct);
	                dbg_checkbox(ref_create(_visibilityStruct, "__visible"), string(_effectChainStruct));
                    
                    ++_i;
                }
            break;
            
            case "Knobs":
                var _i = 0;
                repeat(array_length(_knobArray))
                {
					var _knobStruct = _knobArray[_i];
					
	                var _visibilityStruct = new __VinylClassGuiVisibility(_knobStruct);
	                array_push(_knobVisArray, _visibilityStruct);
	                dbg_checkbox(ref_create(_visibilityStruct, "__visible"), string(_knobStruct));
                    
                    ++_i;
                }
            break;
            
            default:
                __VinylError("UI section \"", _sectionName, "\" not supported");
            break;
        }
        
        ++_s;
    }
}