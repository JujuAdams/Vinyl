/// @param mixGroupIndex
/// @param exportName
/// @param omniOnly
/// @param trim
/// @param otherData

function __VinylClassMixGroup(_mixGroupIndex, _exportName, _omniOnly, _trim, _otherData) constructor
{
    __mixGroupIndex = _mixGroupIndex;
    __exportName    = _exportName;
    __trim          = _trim;
    __omniOnly      = _omniOnly;
    __otherData     = _otherData;
    
    __gain = __trim;
    __mute = false;
    
    __globalGMEmitterAndBus = new __VinylClassGMGMEmitterAndBus(self);
    __gmEmitterAndBusArray = [__globalGMEmitterAndBus];
    
    __soundArray = [];
}