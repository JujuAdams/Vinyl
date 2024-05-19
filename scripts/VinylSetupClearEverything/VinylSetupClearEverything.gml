// Feather disable all

/// Removes al the mixes, sounds, and patterns that have been defined for Vinyl.

function VinylSetupClearEverything()
{
    static _soundDict   = __VinylSystem().__soundDict;
    static _patternDict = __VinylSystem().__patternDict;
    static _mixDict     = __VinylSystem().__mixDict;
    static _mixArray    = __VinylSystem().__mixArray;
    static _duckDict    = __VinylSystem().__duckDict;
    static _duckArray   = __VinylSystem().__duckArray;
    
    var _duckMethod = method(_duckDict, function(_key, _value)
    {
        _value.__ClearSetup();
        struct_remove(self, _key);
    });
    
    struct_foreach(_duckDict, _duckMethod);
    array_resize(_duckArray, 0);
    
    var _mixMethod = method(_mixDict, function(_key, _value)
    {
        _value.__ClearSetup();
        struct_remove(self, _key);
    });
    
    struct_foreach(_mixDict, _mixMethod);
    array_resize(_mixArray, 0);
    
    var _soundMethod = method(_soundDict, function(_key, _value)
    {
        _value.__ClearSetup();
        struct_remove(self, _key);
    });
    
    struct_foreach(_soundDict, _soundMethod);
    
    var _patternMethod = method(_patternDict, function(_key, _value)
    {
        _value.__ClearSetup();
        struct_remove(self, _key);
    });
    
    struct_foreach(_patternDict, _patternMethod);
}