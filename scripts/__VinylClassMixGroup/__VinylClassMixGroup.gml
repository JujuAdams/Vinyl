/// @param mixGroupIndex
/// @param exportName
/// @param allowEmitters
/// @param trim
/// @param otherData

function __VinylClassMixGroup(_mixGroupIndex, _exportName, _allowEmitters, _trim, _otherData) constructor
{
    __mixGroupIndex = _mixGroupIndex;
    __exportName    = _exportName;
    __trim          = _trim;
    __allowEmitters = _allowEmitters;
    __otherData     = _otherData;
    
    __gain = __trim;
    __mute = false;
    
    __globalGMEmitterAndBus = undefined;
    __gmEmitterAndBusArray = [];
    __globalGMEmitterAndBus = new __VinylClassGMEmitterAndBus(self);
    
    __soundArray = [];
    
    static __AddEmitter = function(_gmEmitterAndBus)
    {
        array_push(__gmEmitterAndBusArray, _gmEmitterAndBus);
        
        if (__globalGMEmitterAndBus != undefined)
        {
            //Copy the mix group's effects to the newly added emitter
            var _mixEffects = __globalGMEmitterAndBus.__bus.effects;
            with(_gmEmitterAndBus.__bus)
            {
                effects[@ 4] = _mixEffects[4];
                effects[@ 5] = _mixEffects[5];
                effects[@ 6] = _mixEffects[6];
                effects[@ 7] = _mixEffects[7];
            }
        }
    }
    
    static __DeleteEmitter = function(_gmEmitterAndBus)
    {
        var _index = array_get_index(__gmEmitterAndBusArray, _gmEmitterAndBus);
        if (_index >= 0) array_delete(__gmEmitterAndBusArray, _index, 1);
    }
}