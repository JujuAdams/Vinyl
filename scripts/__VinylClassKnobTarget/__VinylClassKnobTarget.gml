/// @param scope
/// @param property

function __VinylClassKnobTarget(_scope, _property) constructor
{
    __scope      = _scope;
    __property   = _property;
    
    if (is_instanceof(__scope, __VinylClassLabel)
    ||  is_instanceof(__scope, __VinylClassPatternFallback)
    ||  is_instanceof(__scope, __VinylClassPatternAsset)
    ||  is_instanceof(__scope, __VinylClassPatternBasic)
    ||  is_instanceof(__scope, __VinylClassPatternShuffle)
    ||  is_instanceof(__scope, __VinylClassPatternQueue)
    ||  is_instanceof(__scope, __VinylClassPatternMulti))
    {
        __mode = 1;
    }
    else
    {
        //Fallback for generic structs
        __mode = 0;
    }
    
    static __Update = function(_value)
    {
        if (__mode == 0)
        {
            __scope[$ __property] = _value;
        }
        else if (__mode == 1) //Labels and Patterns
        {
            if (__property == "gain")
            {
                __scope.__GainSet(_value, true);
            }
            else if (__property == "pitch")
            {
                __scope.__PitchSet(_value, true);
            }
            else if (__property == "blend")
            {
                __scope.__MultiBlendSet(_value, true);
            }
        }
    }
}