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
                __scope.__InputGainSet(_value, true);
            }
            else if (__property == "pitch")
            {
                __scope.__InputPitchSet(_value, true);
            }
        }
    }
}