function __VinylGlobalData()
{
    static _struct = {
        __liveUpdate: (VINYL_LIVE_UPDATE_PERIOD > 0),
        
        __listenerX: 0,
        __listenerY: 0,
        
        __idToInstanceDict: ds_map_create(),
        
        __transposeSemitones: 0,
        
        __poolBasic:      new __VinylClassPool(90000000, __VinylClassInstanceBasic),
        __poolQueue:      new __VinylClassPool(91000000, __VinylClassInstanceBasic),
        __poolBlend:      new __VinylClassPool(92000000, __VinylClassInstanceBasic),
        __poolEmitter:    new __VinylClassPool(93000000, __VinylClassEmitter),
        __poolPanEmitter: new __VinylClassPool(94000000, __VinylClassPanEmitter),
        
        __basicPoolPlaying: [],
        __basicPool:        [],
        __basicPoolReturn:  [],
        
        __emitterActive:     [],
        __emitterPool:       [],
        __emitterPoolReturn: [],
        
        __panEmitterActive:     [],
        __panEmitterPool:       [],
        __panEmitterPoolReturn: [],
        
        __patternDict: {},
        __labelDict:   {},
        __labelOrder:  [],
        
        __effectChainDict:  {},
        __effectChainArray: [],
        
        __labelTrackingDict: {},
        
        __knobDict:  {},
        __knobArray: [],
    };
    
    return _struct;
}