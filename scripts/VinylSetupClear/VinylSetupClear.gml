// Feather disable all

function VinylSetupClear()
{
    static _soundDict        = __VinylSystem().__soundDict;
    static _patternDict      = __VinylSystem().__patternDict;
    static _mixDict          = __VinylSystem().__mixDict;
    static _voiceStructArray = __VinylSystem().__voiceStructArray;
    
    var _mixMethod = method(_mixDict, function(_key, _value)
    {
        _value.__Clear();
        struct_remove(self, _key);
    });
    
    struct_foreach(_mixDict, _mixMethod);
    
    var _soundMethod = method(_soundDict, function(_key, _value)
    {
        _value.__Clear();
        struct_remove(self, _key);
    });
    
    struct_foreach(_soundDict, _soundMethod);
    
    var _patternMethod = method(_patternDict, function(_key, _value)
    {
        _value.__Clear();
        struct_remove(self, _key);
    });
    
    struct_foreach(_patternDict, _patternMethod);
}