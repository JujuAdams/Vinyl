// Feather disable all

/// @param [useMacros=false]
/// @param [ignoreEmpty=true]

function VinylSetupExportGML(_useMacros = false, _ignoreEmpty = true)
{
    static _mixDict     = __VinylSystem().__mixDict;
    static _soundDict   = __VinylSystem().__soundDict;
    static _patternDict = __VinylSystem().__patternDict;
    
    if (not VINYL_LIVE_EDIT)
    {
        __VinylError("VINYL_LIVE_EDIT must be set to <true>");
        return;
    }
    
    var _buffer = buffer_create(1024, buffer_grow, 1);
    buffer_write(_buffer, buffer_text, "[\n");
    
    var _soundExportedDict   = {};
    var _patternExportedDict = {};
    
    
    
    //TODO - Sort
    var _mixMethod = method({
        __buffer:              _buffer,
        __useMacros:           _useMacros,
        __soundExportedDict:   _soundExportedDict,
        __patternExportedDict: _patternExportedDict,
        __ignoreEmpty:         _ignoreEmpty,
    },
    function(_name, _value)
    {
        _value.__ExportGML(__buffer, __useMacros, __soundExportedDict, __patternExportedDict, __ignoreEmpty);
    });
    
    struct_foreach(_mixDict, _mixMethod);
    
    
    
    //TODO - Sort
    var _patternMethod = method({
        __buffer:              _buffer,
        __patternExportedDict: _patternExportedDict,
        __useMacros:           _useMacros,
    },
    function(_name, _value)
    {
        if (not struct_exists(__patternExportedDict, _name))
        {
            _value.__ExportGML(__buffer, "    ", __useMacros);
        }
    });
    
    struct_foreach(_patternDict, _patternMethod);
    
    
    
    //TODO - Sort
    var _soundMethod = method({
        __buffer:            _buffer,
        __soundExportedDict: _soundExportedDict,
        __ignoreEmpty:       _ignoreEmpty,
    },
    function(_name, _value)
    {
        if (not struct_exists(__soundExportedDict, _name))
        {
            _value.__ExportGML(__buffer, "    ", __ignoreEmpty);
        }
    });
    
    struct_foreach(_soundDict, _soundMethod);
    
    
    
    buffer_write(_buffer, buffer_text, "]");
    
    var _string = buffer_peek(_buffer, 0, buffer_string);
    buffer_delete(_buffer);
    
    return _string;
}