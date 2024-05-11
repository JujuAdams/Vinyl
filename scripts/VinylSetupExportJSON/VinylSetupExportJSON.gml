// Feather disable all

/// @param [ignoreEmpty=true]

function VinylSetupExportJSON(_ignoreEmpty = true)
{
    static _mixDict     = __VinylSystem().__mixDict;
    static _patternDict = __VinylSystem().__patternDict;
    static _soundDict   = __VinylSystem().__soundDict;
    
    if (not VINYL_LIVE_EDIT)
    {
        __VinylError("VINYL_LIVE_EDIT must be set to <true>");
        return;
    }
    
    
    
    var _outArray            = [];
    var _patternExportedDict = {};
    var _soundExportedDict   = {};
    
    
    
    //Export mix definitions
    var _namesArray = struct_get_names(_mixDict);
    array_sort(_namesArray, true);
    
    var _i = 0;
    repeat(array_length(_namesArray))
    {
        array_push(_outArray, _mixDict[$ _namesArray[_i]].__ExportJSON(_soundExportedDict, _patternExportedDict, _ignoreEmpty));
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
            var _struct = _patternDict[$ _name].__ExportJSON();
            if (_struct != undefined) array_push(_outArray, _struct);
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
            var _struct = _soundDict[$ _name].__ExportJSON(_ignoreEmpty);
            if (_struct != undefined) array_push(_outArray, _struct);
        }
        
        ++_i;
    }
    
    
    
    return _outArray;
}