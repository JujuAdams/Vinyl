// Feather disable all

function __VinylVoiceUpdateDuck(_mixStruct)
{
    static _duckDict = __VinylSystem().__duckDict;
    
    if (_mixStruct == undefined)
    {
        var _duckNameFinal = __duckNameLocal ?? __pattern.__duckName;
    }
    else
    {
        var _duckNameFinal = __duckNameLocal ?? (__pattern.__duckName ?? _mixStruct.__membersDuck);
    }
    
    if (_duckNameFinal != undefined)
    {
        var _duckStruct = _duckDict[$ _duckNameFinal];
        if (_duckStruct == undefined)
        {
            __VinylWarning("Duck \"", _duckNameFinal, "\" not recognised");
            __Duck(1, __VINYL_DEFAULT_DUCK_RATE_OF_GAIN, __VINYL_DUCK.__DO_NOTHING);
            return;
        }
        
        _duckStruct.__Push(self, __duckPrioLocal ?? (__pattern.__duckPrio ?? 0), true);
    }
    else
    {
        __Duck(1, __VINYL_DEFAULT_DUCK_RATE_OF_GAIN, __VINYL_DUCK.__DO_NOTHING);
    }
}