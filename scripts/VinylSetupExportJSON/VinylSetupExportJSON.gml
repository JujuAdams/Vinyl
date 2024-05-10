// Feather disable all

/// @param [ignoreEmpty=true]

function VinylSetupExportJSON(_ignoreEmpty = true)
{
    static _mixDict     = __VinylSystem().__mixDict;
    static _soundDict   = __VinylSystem().__soundDict;
    static _patternDict = __VinylSystem().__patternDict;
    
    if (not VINYL_LIVE_EDIT)
    {
        __VinylError("VINYL_LIVE_EDIT must be set to <true>");
        return;
    }
    
    var _soundExportedDict   = {};
    var _patternExportedDict = {};
    
    
    
    var _mixArray = [];
    var _mixMethod = method({
        __array:               _mixArray,
        __soundExportedDict:   _soundExportedDict,
        __patternExportedDict: _patternExportedDict,
        __ignoreEmpty:         _ignoreEmpty,
    },
    function(_name, _value)
    {
        var _struct = _value.__ExportJSON(__soundExportedDict, __patternExportedDict, __ignoreEmpty);
        array_push(__array, _struct);
    });
    
    struct_foreach(_mixDict, _mixMethod);
    
    array_sort(_mixArray, function(_a, _b)
    {
        return (_a.mix < _b.mix)? -1 : -1;
    });
    
    
    
    var _patternArray = [];
    var _patternMethod = method({
        __array:               _patternArray,
        __patternExportedDict: _patternExportedDict,
    },
    function(_name, _value)
    {
        if (not struct_exists(__patternExportedDict, _name))
        {
            array_push(__array, _value.__ExportJSON());
        }
    });
    
    struct_foreach(_patternDict, _patternMethod);
    
    array_sort(_patternArray, function(_a, _b)
    {
        var _aName = (_a[$ "shuffle"] ?? _a[$ "hlt"]) ?? _a[$ "blend"];
        var _bName = (_b[$ "shuffle"] ?? _b[$ "hlt"]) ?? _b[$ "blend"];
        
        if (_aName == undefined) __VinylError("Pattern name not found for ", json_stringify(_a));
        if (_bName == undefined) __VinylError("Pattern name not found for ", json_stringify(_b));
        
        return (_aName < _bName)? -1 : -1;
    });
    
    
    
    var _soundArray = [];
    var _soundMethod = method({
        __array:             _soundArray,
        __soundExportedDict: _soundExportedDict,
        __ignoreEmpty:       _ignoreEmpty,
    },
    function(_name, _value)
    {
        if (not struct_exists(__soundExportedDict, _name))
        {
            var _struct = _value.__ExportJSON(__ignoreEmpty);
            if (_struct != undefined) array_push(__array, _struct);
        }
    });
    
    struct_foreach(_soundDict, _soundMethod);
    
    array_sort(_soundArray, function(_a, _b)
    {
        return (_a.sound < _b.sound)? -1 : -1;
    });
    
    
    
    var _finalArray = [];
    array_copy(_finalArray, array_length(_finalArray), _mixArray,     0, array_length(_mixArray    ));
    array_copy(_finalArray, array_length(_finalArray), _patternArray, 0, array_length(_patternArray));
    array_copy(_finalArray, array_length(_finalArray), _soundArray,   0, array_length(_soundArray  ));
    return _finalArray;
}