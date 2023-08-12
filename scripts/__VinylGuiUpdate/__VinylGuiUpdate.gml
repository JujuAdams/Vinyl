function __VinylGuiUpdate()
{
    static _globalData = __VinylGlobalData();
        
    var _patternArray     = _globalData.__patternArray;
    var _labelArray       = _globalData.__labelArray;
    var _effectChainArray = _globalData.__effectChainArray;
    var _knobArray        = _globalData.__knobArray;
    var _stackArray       = _globalData.__stackArray;
    
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
    dbg_button("Save", function()
    {
        show_message("!");
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
					var _pattern = _patternArray[_i];
					if (is_instanceof(_pattern, __VinylClassPatternAsset))
					{
	                    var _struct = new __VinylClassGuiVisibility(_pattern);
	                    array_push(_assetVisArray, _struct);
	                    dbg_checkbox(ref_create(_struct, "__visible"), string(_pattern));
					}
                    
                    ++_i;
                }
            break;
            
            case "Patterns":
                var _i = 0;
                repeat(array_length(_patternArray))
                {
					var _pattern = _patternArray[_i];
					if (!is_instanceof(_pattern, __VinylClassPatternAsset))
					{
	                    var _struct = new __VinylClassGuiVisibility(_pattern);
	                    array_push(_patternVisArray, _struct);
	                    dbg_checkbox(ref_create(_struct, "__visible"), string(_pattern));
					}
                    
                    ++_i;
                }
            break;
            
            case "Labels":
            break;
            
            case "Stacks":
            break;
            
            case "Effect Chains":
            break;
            
            case "Knobs":
            break;
            
            default:
                __VinylError("UI section \"", _sectionName, "\" not supported");
            break;
        }
        
        ++_s;
    }
}