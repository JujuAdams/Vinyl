/// @param mixGroup

function __VinylClassGMGMEmitterAndBus(_mixGroup) constructor
{
    __mixGroup = _mixGroup;
    
    __gmEmitter = audio_emitter_create();
    __bus = audio_bus_create();
    __bus.gain = __mixGroup.__mute? 0 : __mixGroup.__gain;
    audio_emitter_bus(__gmEmitter, __bus);
    
    static __SetFalloff = function(_refDist, _maxDist, _factor)
    {
        audio_emitter_falloff(__gmEmitter, _refDist, _maxDist, _factor);
        return self;
    }
    
    static __SetPosition = function(_x, _y, _z)
    {
        audio_emitter_position(__gmEmitter, _x, _y, _z);
        return self;
    }
    
    static __Destroy = function()
    {
        audio_emitter_free(__gmEmitter);
        __gmEmitter = undefined;
    }
}