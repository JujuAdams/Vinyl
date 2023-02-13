/// @param scope
/// @param property

function __VinylClassKnobTarget(_scope, _property) constructor
{
    __scope    = _scope;
    __property = _property;
    
    
    
    static __Update = function(_value)
    {
        if (is_instanceof(__scope, __VinylClassLabel))
        {
            if (__property == "gain")
            {
                __scope.__GainSet(_value, true);
            }
            else if (__property == "pitch")
            {
                __scope.__PitchSet(_value, true);
            }
        }
        else if (is_instanceof(__scope, __VinylClassPatternBasic))
        {
            if (__property == "gain")
            {
                __scope.__gain = _value;
            }
            else if (__property == "pitch")
            {
                __scope.__pitchLo = _value;
                __scope.__pitchHi = _value;
            }
        }
        else
        {
            //Fallback for generic structs
            __scope[$ __property] = _value;
        }
    }
}