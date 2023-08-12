function __VinylClassGuiState(_target) constructor
{
    var _state = {};
    _target.__GuiExportStruct(_state);
    
    __target   = _target;
    __current  = _state;
    __previous = __VinylDeepCopy(_state);
	
	static __BuildGui = function()
	{
	    dbg_section(__target.__GetDisplayName());
		__target.__GuiBuildForStruct(__current);
	}
}