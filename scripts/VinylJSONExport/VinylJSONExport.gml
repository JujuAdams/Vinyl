// Feather disable all

function VinylJSONExport()
{
    static _soundDict   = __VinylSystem().__soundDict;
    static _patternDict = __VinylSystem().__patternDict;
    
    if (not VINYL_LIVE_EDIT)
    {
        __VinylError("VINYL_LIVE_EDIT must be set to <true>");
        return;
    }
    
    var _array = [];
    
    var _soundMethod = method({
        __array: _array,
    },
    function(_name, _value)
    {
        array_push(__array, _value.__ExportJSON());
    });
    
    var _patternMethod = method({
        __array: _array,
    },
    function(_name, _value)
    {
        array_push(__array, _value.__ExportJSON());
    });
    
    struct_foreach(_soundDict, _soundMethod);
    struct_foreach(_patternDict, _patternMethod);
    
    return _array;
}