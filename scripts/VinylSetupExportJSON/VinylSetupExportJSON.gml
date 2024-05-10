// Feather disable all

function VinylSetupExportJSON()
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
        __array: _mixArray,
        __soundExportedDict: _soundExportedDict,
        __patternExportedDict: _patternExportedDict,
    },
    function(_name, _value)
    {
        var _struct = _value.__ExportJSON(__soundExportedDict, __patternExportedDict);
        array_push(__array, _struct);
    });
    
    struct_foreach(_mixDict, _mixMethod);
    
    array_sort(_mixArray, function(_a, _b)
    {
        return (_a.mix < _b.mix)? -1 : -1;
    });
    
    
    
    var _soundArray = [];
    var _soundMethod = method({
        __array: _soundArray,
        __soundExportedDict: _soundExportedDict,
    },
    function(_name, _value)
    {
        if (not struct_exists(__soundExportedDict, _name))
        {
            array_push(__array, _value.__ExportJSON());
        }
    });
    
    struct_foreach(_soundDict, _soundMethod);
    
    array_sort(_soundArray, function(_a, _b)
    {
        return (_a.sound < _b.sound)? -1 : -1;
    });
    
    
    
    var _patternArray = [];
    var _patternMethod = method({
        __array: _patternArray,
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
    
    //array_sort(_soundArray, function(_a, _b)
    //{
    //    return (_a.__patternName < _b.__patternName)? -1 : -1;
    //});
    
    
    
    var _finalArray = [];
    array_copy(_finalArray, array_length(_finalArray), _mixArray,     0, array_length(_mixArray    ));
    array_copy(_finalArray, array_length(_finalArray), _soundArray,   0, array_length(_soundArray  ));
    array_copy(_finalArray, array_length(_finalArray), _patternArray, 0, array_length(_patternArray));
    return _finalArray;
}