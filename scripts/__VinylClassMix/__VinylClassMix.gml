// Feather disable all

/// @param mixName
/// @param baseGain

function __VinylClassMix(_mixName, _baseGain) constructor
{
    __mixName  = _mixName;
    __baseGain = _baseGain;
    
    __gainLocal = 1;
    
    static __Update = function(_baseGain)
    {
        __baseGain = _baseGain;
    }
    
    static __Clear = function()
    {
        __Update(1);
    }
    
    static __ExportJSON = function()
    {
        var _struct = {
            mix:      __mixName,
            baseGain: __baseGain,
        };
        
        return _struct;
    }
}