/// This is actually n GameMaker emitters in a trenchcoat.
///
/// @param x
/// @param y
/// @param z

function __VinylClassEmitter(_x, _y, _z) constructor
{
    static _mixGroupArray = __VinylSystem().__mixGroupArray;
    
    x = _x;
    y = _y;
    z = _z;
    
    __refDist = VINYL_FALLOFF_REF_DIST;
    __maxDist = VINYL_FALLOFF_MAX_DIST;
    __factor  = VINYL_FALLOFF_FACTOR;
    
    __gmEmitterAndBusArray = array_create(array_length(_mixGroupArray), undefined);
    
    var _i = 0;
    repeat(array_length(__gmEmitterAndBusArray))
    {
        var _mixGroup = _mixGroupArray[_i];
        if (not _mixGroup.__omniOnly)
        {
            __gmEmitterAndBusArray[@ _i] = (new __VinylClassGMGMEmitterAndBus(_mixGroup))
                                            .__SetFalloff(VINYL_FALLOFF_REF_DIST, VINYL_FALLOFF_MAX_DIST, VINYL_FALLOFF_FACTOR)
                                            .__SetPosition(_x, _y, _z);
        }
        
        ++_i;
    }
    
    static __SetPosition = function(_x, _y, _z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        var _i = 0;
        repeat(array_length(__gmEmitterAndBusArray))
        {
            with(__gmEmitterAndBusArray[_i])
            {
                __SetPosition(_x, _y, _z);
            }
            
            ++_i;
        }
    }
    
    static __SetFalloff = function(_refDist, _maxDist, _factor)
    {
        __refDist = _refDist;
        __maxDist = _maxDist;
        __factor  = _factor;
        
        var _i = 0;
        repeat(array_length(__gmEmitterAndBusArray))
        {
            with(__gmEmitterAndBusArray[_i])
            {
                __SetFalloff(_refDist, _maxDist, _factor);
            }
            
            ++_i;
        }
    }
    
    static __Destroy = function()
    {
        var _i = 0;
        repeat(array_length(__gmEmitterAndBusArray))
        {
            with(__gmEmitterAndBusArray[_i])
            {
                __Destroy();
            }
            
            ++_i;
        }
    }
}