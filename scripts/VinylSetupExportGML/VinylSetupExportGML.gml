// Feather disable all

/// @param [useMacros=false]
/// @param [ignoreEmpty=true]

function VinylSetupExportGML(_useMacros = false, _ignoreEmpty = true)
{
    static _mixDict     = __VinylSystem().__mixDict;
    static _patternDict = __VinylSystem().__patternDict;
    static _soundDict   = __VinylSystem().__soundDict;
    
    if (not VINYL_LIVE_EDIT)
    {
        __VinylError("VINYL_LIVE_EDIT must be set to <true>");
        return;
    }
    
    
    
    var _buffer = buffer_create(1024, buffer_grow, 1);
    buffer_write(_buffer, buffer_text, "[\n");
    
    var _patternExportedDict = {};
    var _soundExportedDict   = {};
    
    
    
    //Export mix definitions
    var _namesArray = struct_get_names(_mixDict);
    array_sort(_namesArray, true);
    
    var _i = 0;
    repeat(array_length(_namesArray))
    {
        _mixDict[$ _namesArray[_i]].__ExportGML(_buffer, _useMacros, _soundExportedDict, _patternExportedDict, _ignoreEmpty);
        ++_i;
    }
    
    
    
    //Export pattern definitions
    var _namesArray = struct_get_names(_patternDict);
    array_sort(_namesArray, true);
    
    var _i = 0;
    repeat(array_length(_namesArray))
    {
        var _name = _namesArray[_i];
        
        if (not struct_exists(_patternExportedDict, _name))
        {
            _patternDict[$ _name].__ExportGML(_buffer, "    ", _useMacros);
        }
        
        ++_i;
    }
    
    
    
    //Export sound definitions
    var _namesArray = struct_get_names(_soundDict);
    array_sort(_namesArray, true);
    
    var _i = 0;
    repeat(array_length(_namesArray))
    {
        var _name = _namesArray[_i];
        
        if (not struct_exists(_soundExportedDict, _name))
        {
            _soundDict[$ _namesArray[_i]].__ExportGML(_buffer, "    ", _ignoreEmpty);
        }
        
        ++_i;
    }
    
    
    
    buffer_write(_buffer, buffer_text, "]");
    
    var _string = buffer_peek(_buffer, 0, buffer_string);
    buffer_delete(_buffer);
    
    return _string;
}